//
//  SwiftWebViewBridge.swift
//  SwiftWebViewBridge
//
//  Version: 0.1.2
//  Last Modified: 16/3/4.
//  Created by ShawnFoo on 16/1/18.
//  Copyright © 2016年 ShawnFoo. All rights reserved.
//

import UIKit

// MARK: - Custom Type

/// 1st param: responseData to JS
public typealias SWVBResponseCallBack = AnyObject -> Void
/// 1st param: jsonData sent from JS; 2nd param: responseCallback for sending data back to JS
public typealias SWVBHandler = (AnyObject, SWVBResponseCallBack) -> Void
public typealias SWVBHandlerDic = [String: SWVBHandler]
public typealias SWVBCallbackDic = [String: SWVBResponseCallBack]
public typealias SWVBMessage = [String: AnyObject]

// MARK: - SwiftWebViewBridge

public class SwiftWebViewBridge: NSObject {
    
    // MARK: Constants
    
    private var kCustomProtocolScheme: String {
        return "swvbscheme" //lowercase!
    }
    
    private var kCustomProtocolHost: String {
        return "__SWVB_Host_MESSAGE__"
    }
    
    private var kJsCheckObjectDefinedCommand: String {
        return "typeof SwiftWebViewBridge == \'object\';"
    }
    
    private var kJsFetchMessagesCommand: String {
        return "SwiftWebViewBridge._fetchJSMessage();"
    }
    
    // MARK: Proporties
    
    public static var logging = true
    
    private weak var webView: UIWebView?
    private weak var oriDelegate: AnyObject?
    private var numOfLoadingRequests = 0
    
    // identity of the response callback
    private var uniqueId = 1
    // the queue stored messages called or sent before webView did finish load(js injection also finished in that function)
    private lazy var startupMessageQueue: [SWVBMessage]? = {
        return [SWVBMessage]()
    }()
    private var defaultHandler: SWVBHandler? {
        get {
            return self.messageHandlers["__kDefaultHandler__"]
        }
        set {
            if let handler = newValue {
                
                self.messageHandlers["__kDefaultHandler__"] = handler
            }
        }
    }
    // save the JS callback in the Swift side, only pass the uniqueId to JS for the callback
    private lazy var jsCallbacks: SWVBCallbackDic = SWVBCallbackDic()
    // handlers for JS calling
    private lazy var messageHandlers: SWVBHandlerDic = SWVBHandlerDic()
    
    
    // MARK: Factory / Initilizers
    
    /**
    Generate a bridge with associated webView and default handler to deal with messages from js
    
    - parameter webView: webView
    - parameter handler: default handler to deal with messages from js
    
    - returns: bridge
    */
    public class func bridge(webView: UIWebView, defaultHandler handler: SWVBHandler?) -> SwiftWebViewBridge {
        
        let bridge = SwiftWebViewBridge.init(webView: webView)
        
        // keep ref to original delegate
        bridge.oriDelegate = webView.delegate
        // replace it
        bridge.webView!.delegate = bridge
        bridge.defaultHandler = handler
        
        return bridge
    }
    
    private override init() {
        super.init()
    }
    
    private convenience init(webView: UIWebView) {
        self.init()
        
        self.webView = webView
    }
}

// MARK: - SwiftWebViewBridge + Message Manage

extension SwiftWebViewBridge {
    
    // MARK: Message Sent To JS
    
    /**
    Add message that will be sent to JS to Queue
    
    - parameter msg: message that will be sent to JS
    */
    private func addToMessageQueue(msg: SWVBMessage) {
        
        if nil != self.startupMessageQueue {
            self.startupMessageQueue!.append(msg)
        } else {
            self.dispatchMessage(msg)
        }
    }
    
    /**
     Sending every message(send data or call handler) that happened before UIWebView did finish all loadings to JS one by one
     */
    private func dispatchStartupMessageQueue() {
        
        if let queue = self.startupMessageQueue {
            for message in queue {
                self.dispatchMessage(message)
            }
            self.startupMessageQueue = nil
        }
    }
    
    /**
     Send message to JS. (Swift/ObjC call JS Handlers here)
     
     - parameter msg: message that will be sent to JS
     */
    private func dispatchMessage(msg: SWVBMessage) {
        
        if let jsonMsg: String = self.javascriptStylizedJSON(msg), webView = self.webView {
            
            self.swvb_printLog(.SENT(jsonMsg))
            let jsCommand = "SwiftWebViewBridge._handleMessageFromSwift('\(jsonMsg)')"
            if NSThread.isMainThread() {
                webView.stringByEvaluatingJavaScriptFromString(jsCommand)
            } else {
                dispatch_sync(dispatch_get_main_queue()) {
                    webView.stringByEvaluatingJavaScriptFromString(jsCommand)
                }
            }
        } else {
            self.swvb_printLog(.ERROR("Swift Object Serialization Failed: \(msg)"))
        }
    }
    
    // MARK: Messages Sent From JS
    private func handleMessagesFromJS(jsonMessages: String) {
        
        guard let messages = self.deserilizeMessage(jsonMessages) as? Array<SWVBMessage> else {
            
            self.swvb_printLog(.ERROR("Failed to deserilize received msg from JS: \(jsonMessages)"))
            return
        }
        
        self.swvb_printLog(.RCVD(messages))
        
        for swvbMsg in messages {
            // Swift callback(after JS finished designated handler called by Swift)
            if let responseId = swvbMsg["responseId"] as? String {
                
                if let callback = self.jsCallbacks[responseId] {
                    
                    let responseData = swvbMsg["responseData"] != nil ? swvbMsg["responseData"] : NSNull()
                    
                    callback(responseData!)
                    self.jsCallbacks.removeValueForKey(responseId)
                } else {
                    self.swvb_printLog(.ERROR("No matching callback closure for: \(swvbMsg)"))
                }
            } else { // JS call Swift Handler
                
                let callback: SWVBResponseCallBack = {
                    // if there is callbackId(that means JS has a callback), Swift send it back as responseId to JS so that JS can find and execute callback
                    if let callbackId: String = swvbMsg["callbackId"] as? String {
                        
                        return { [unowned self] (responseData: AnyObject?) -> Void in
                            
                            let data: AnyObject = responseData != nil ? responseData! : NSNull()
                            
                            let msg: SWVBMessage = ["responseId": callbackId, "responseData": data]//
                            self.addToMessageQueue(msg)
                        }
                    } else {
                        return { (data: AnyObject?) -> Void in
                            // emtpy closure, make sure callback closure param is non-optional
                        }
                    }
                }()
                
                let handler: SWVBHandler? = { [unowned self] in
                    
                    if let handlerName = swvbMsg["handlerName"] as? String {
                        
                        return self.messageHandlers[handlerName]
                    }
                    
                    return self.defaultHandler
                    }()
                
                guard let handlerClosure = handler else {
                    fatalError("No handler for msg from JS: \(swvbMsg)..Please at least create a default handler when initializing the bridge = )")
                }
                
                let msgData = swvbMsg["data"] != nil ? swvbMsg["data"] : NSNull()
                
                handlerClosure(msgData!, callback)
            }// else end
        }//for end
    }// func end
    
    // MARK: Swift Send Message To JS
    
    /**
    Sent data to JS simply
    */
    public func sendDataToJS(data: AnyObject) {
        self.callJSHandler(nil, params: data, responseCallback: nil)
    }
    
    /**
     Send data to JS with callback closure
     */
    public func sendDataToJS(data: AnyObject, responseCallback: SWVBResponseCallBack?) {
        self.callJSHandler(nil, params: data, responseCallback: responseCallback)
    }
    
    /**
     Call JavaScript handler
     
     - parameter handlerName:      handlerName should be identical to handler registered in JS. If this param is nil or no-matching name in JS, its params will be sent to JS defaultHandler
     - parameter params:           params(optional)
     - parameter responseCallback: callback(optional) will execute, after JS finished the matching handler
     */
    public func callJSHandler(handlerName: String?, params: AnyObject?, responseCallback: SWVBResponseCallBack?) {
        
        var message = SWVBMessage()
        
        message["data"] = params != nil ? params : NSNull()
        
        if let name = handlerName {
            message["handlerName"] = name
        }
        
        if let callback = responseCallback {
            // pass this Id to JS, and then after JS finish its handler, this Id will pass back to Swift as responseId, so Swift can use it to find and execute the matching callback
            let callbackId = "cb_\(uniqueId)_Swift_\(NSDate().timeIntervalSince1970)"
            uniqueId += 1
            self.jsCallbacks[callbackId] = callback
            message["callbackId"] = callbackId
        }
        
        self.addToMessageQueue(message)
    }
    
    // MARK: Rigister Handler For Message From JS
    
    /**
    Register a handler for JavaScript calling
    
    - parameter name:    handlerName
    - parameter handler: closure
    */
    public func registerHandlerForJS(handlerName name: String, handler: SWVBHandler) {
        
        self.messageHandlers[name] = handler
    }
}

// MARK: - SwiftWebViewBridge + WebViewDelegate

extension SwiftWebViewBridge: UIWebViewDelegate {
    
    // It's the only entrance where JavaScript can call Swift/ObjC handler or callback.Every URL loading in any frames will trigger this method
    public func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if let url: NSURL = request.URL {
            
            if self.isSchemeCorrect(url) && self.isHostCorrect(url) {
                // after JS trigger this method by loading URL, Swift needs to ask JS for messages by itself
                if let jsonMessages = webView.stringByEvaluatingJavaScriptFromString(self.kJsFetchMessagesCommand) {
                    
                    self.handleMessagesFromJS(jsonMessages)
                } else {
                    AILog("Didn't fetch any message from JS!")
                }
            } else if let oriDelegate = self.oriDelegate as? UIWebViewDelegate {
                
                if let shouldLoad = oriDelegate.webView?(webView, shouldStartLoadWithRequest: request, navigationType: navigationType) {
                    
                    return shouldLoad
                }
            }
            
            return true
        }
        
        return false
    }
    
    public func webViewDidStartLoad(webView: UIWebView) {
        
        self.numOfLoadingRequests += 1
        if let oriDelegate = self.oriDelegate as? UIWebViewDelegate {
            oriDelegate.webViewDidStartLoad?(webView)
        }
    }
    
    public func webViewDidFinishLoad(webView: UIWebView) {
        
        self.numOfLoadingRequests -= 1
        // after all frames have loaded, starting to inject js and dispatch unhanlded message
        
        let loadedAll = self.numOfLoadingRequests == 0
        let noDefinedBridge = webView.stringByEvaluatingJavaScriptFromString(kJsCheckObjectDefinedCommand) == "false"

        // make sure the js has not been injected or no duplicated SwiftWebViewBridge js object
        if  loadedAll && noDefinedBridge {
            
            // inject js
            webView.stringByEvaluatingJavaScriptFromString(self.loadMinifiedJS())
            if webView.stringByEvaluatingJavaScriptFromString(kJsCheckObjectDefinedCommand) != "true" {
                AILog("Injection of js Failed!")
            } else {
                self.dispatchStartupMessageQueue()
            }
        }

        
        if let oriDelegate = self.oriDelegate as? UIWebViewDelegate {
            oriDelegate.webViewDidFinishLoad?(webView)
        }
    }
    
    public func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
        if let oriDelegate = self.oriDelegate as? UIWebViewDelegate {
            oriDelegate.webView?(webView, didFailLoadWithError: error)
        }
    }
    
    // MARK: URL Checking
    
    private func isSchemeCorrect(url: NSURL) -> Bool {
        
        return url.scheme == self.kCustomProtocolScheme
    }
    
    private func isHostCorrect(url: NSURL) -> Bool {
        
        return url.host == self.kCustomProtocolHost
    }
}

// MARK: - SwiftWebViewBridge + Nested Enum

extension SwiftWebViewBridge {
    
    private enum LogType: CustomStringConvertible {
        
        case ERROR(String), SENT(AnyObject), RCVD(AnyObject)
        
        var description: String {
            switch self {
            case let .ERROR(msg):
                return "LOGGING_ERROR: \(msg)"
            case let .SENT(msg):
                return "LOGGING_SENT: \(msg)"
            case let .RCVD(msg):
                return "LOGGING_RCVD: \(msg)"
            }
        }
    }
    
    // Print Log
    private func swvb_printLog(logType: LogType) {
        
        if SwiftWebViewBridge.logging {
            AILog(logType.description)
        }
    }
}

// MARK: - SwiftWebViewBridge + JSON Serilization

extension SwiftWebViewBridge {
    
    private func javascriptStylizedJSON(message: AnyObject) -> String? {
        
        if let jsonMsg = self.serilizeMessage(message) {
            
            let jsonStr = jsonMsg.stringByReplacingOccurrencesOfString("\\", withString: "\\\\")
                .stringByReplacingOccurrencesOfString("\"", withString: "\\\"")
                .stringByReplacingOccurrencesOfString("\'", withString: "\\\'")
                .stringByReplacingOccurrencesOfString("\n", withString: "\\n")
                .stringByReplacingOccurrencesOfString("\r", withString: "\\r")
                .stringByReplacingOccurrencesOfString("\t", withString: "\\t")
                .stringByReplacingOccurrencesOfString("\u{2028}", withString: "\\u2028")
                .stringByReplacingOccurrencesOfString("\u{2029}", withString: "\\u2029")
            
            //   \u2028: Line Seperator, 2029: Paragraph Seperator
            return jsonStr
        }
        return nil
    }
    
    private func serilizeMessage(message: AnyObject) -> String? {
        
        let jsonData: NSData
        do {
            jsonData = try NSJSONSerialization.dataWithJSONObject(message, options: NSJSONWritingOptions())
        } catch let error as NSError {
            self.swvb_printLog(.ERROR(error.description))
            return nil
        }
        
        return String(data: jsonData, encoding: NSUTF8StringEncoding)
    }
    
    private func deserilizeMessage(message: String) -> AnyObject? {

        if let serilizedData = message.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                //  allow top-level objects that are not an instance of NSArray or NSDictionary
                let jsonObj = try NSJSONSerialization.JSONObjectWithData(serilizedData, options: .AllowFragments)
                return jsonObj
            } catch let error as NSError {
                self.swvb_printLog(.ERROR(error.description))
                return nil
            }
        }
        
        return nil
    }
}

// MARK: - SwiftWebViewBridge + JS Loading

extension SwiftWebViewBridge {
    
    /*
    Since Swift can't define macro like this #define MultilineString(x) #x in Objective-C project..
    This is only way I can imagine to load the text of javascript by minifying it..
    If you have better ways to load js in Swift, please let me know, thanks a lot😄
    */
    
    private func loadMinifiedJS() -> String {
        
        return ";(function(){if(window.SwiftWebViewBridge){return}var hiddenMessagingIframe;var unsentMessageQueue=[];var startupRCVDMessageQueue=[];var messageHandlers={};var CUSTOM_PROTOCOL_SCHEME='swvbscheme';var CUSTOM_PROTOCOL_HOST='__SWVB_Host_MESSAGE__';var responseCallbacks={};var uniqueId=1;function createHiddenIframe(doc){hiddenMessagingIframe=doc.createElement('iframe');hiddenMessagingIframe.style.display='none';hiddenMessagingIframe.src=CUSTOM_PROTOCOL_SCHEME+'://'+CUSTOM_PROTOCOL_HOST;doc.documentElement.appendChild(hiddenMessagingIframe)}function init(defaultHandler){if(SwiftWebViewBridge._defaultHandler){throw new Error('SwiftWebViewBridge.init called twice');}SwiftWebViewBridge._defaultHandler=defaultHandler;var receivedMessages=startupRCVDMessageQueue;startupRCVDMessageQueue=null;for(var i=0;i<receivedMessages.length;i++){dispatchMessageFromSwift(receivedMessages[i])}}function _fetchJSMessage(){var messageQueueString=JSON.stringify(unsentMessageQueue);unsentMessageQueue=[];return messageQueueString}function _handleMessageFromSwift(jsonMsg){if(startupRCVDMessageQueue){startupRCVDMessageQueue.push(jsonMsg)}else{dispatchMessageFromSwift(jsonMsg)}}function sendDataToSwift(data,responseCallback){callSwiftHandler(null,data,responseCallback)}function callSwiftHandler(handlerName,data,responseCallback){var message=handlerName?{handlerName:handlerName,data:data}:{data:data};if(responseCallback){var callbackId='cb_'+(uniqueId++)+'_JS_'+new Date().getTime();responseCallbacks[callbackId]=responseCallback;message['callbackId']=callbackId}unsentMessageQueue.push(message);hiddenMessagingIframe.src=CUSTOM_PROTOCOL_SCHEME+'://'+CUSTOM_PROTOCOL_HOST}function registerHandlerForSwift(handlerName,handler){messageHandlers[handlerName]=handler}function dispatchMessageFromSwift(jsonMsg){setTimeout(function timeoutDispatchMessageFromSwift(){var message=JSON.parse(jsonMsg);var responseCallback;if(message.responseId){responseCallback=responseCallbacks[message.responseId];if(responseCallback){responseCallback(message.responseData);delete responseCallbacks[message.responseId]}}else{if(message.callbackId){var callbackResponseId=message.callbackId;responseCallback=function(responseData){sendDataToSwift({responseId:callbackResponseId,responseData:responseData})}}var handler=SwiftWebViewBridge._defaultHandler;if(message.handlerName){handler=messageHandlers[message.handlerName]}if(handler){try{handler(message.data,responseCallback)}catch(exception){if(typeof console!='undefined'){console.log('SwiftWebViewBridge: WARNING: javascript handler threw.',message,exception)}}}else{onerror('No defaultHandler!')}}})}window.SwiftWebViewBridge={init:init,sendDataToSwift:sendDataToSwift,registerHandlerForSwift:registerHandlerForSwift,callSwiftHandler:callSwiftHandler,_fetchJSMessage:_fetchJSMessage,_handleMessageFromSwift:_handleMessageFromSwift};var doc=document;createHiddenIframe(doc);var readyEvent=doc.createEvent('Events');readyEvent.initEvent('SwiftWebViewBridgeReady');doc.dispatchEvent(readyEvent)})();"
    }
}
