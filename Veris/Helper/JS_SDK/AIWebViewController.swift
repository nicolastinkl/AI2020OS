//
//  AIWebViewController.swift
//  AIVeris
//
//  Created by zx on 6/30/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIWebViewController: UIViewController {
	var webView: UIWebView!
	var bridge: SwiftWebViewBridge!
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.whiteColor()
		setupWebView()
		let refresh = UIBarButtonItem(barButtonSystemItem: .Refresh, target: webView, action: #selector(UIWebView.reload))
		navigationItem.rightBarButtonItem = refresh
	}
	func setupWebView() {
		
		webView = UIWebView(frame: .zero)
		view.addSubview(webView)
		webView.snp_makeConstraints { (make) in
			make.edges.equalTo(view)
		}
		webView.delegate = self
        SwiftWebViewBridge.logging = false
		bridge = SwiftWebViewBridge.bridge(webView, defaultHandler: { data, responseCallback in
			print("Swift received message from JS: \(data)")
			responseCallback("Swift already got your msg, thanks")
		})
		
		JSSDKAPI.setupAPIWithBridge(bridge)
		
		let request = NSURLRequest(URL: NSURL(string: "http://10.5.4.73:8000/test.html")!)
		webView.loadRequest(request)
	}
	
	private func printReceivedParmas(data: AnyObject) {
		print("Swift recieved data passed from JS: \(data)")
	}
	
	func injectJS() {
		let filePath = NSBundle.mainBundle().pathForResource("JSSDK", ofType: "js")!
		let fileData = NSData(contentsOfFile: filePath)!
		let jsString = String(data: fileData, encoding: NSUTF8StringEncoding)!
		webView.stringByEvaluatingJavaScriptFromString(jsString)
	}
}

extension AIWebViewController: UIWebViewDelegate {
	func webViewDidFinishLoad(webView: UIWebView) {
		injectJS()
	}
}

class JSSDKAPI: NSObject {
	class func setupAPIWithBridge(bridge: SwiftWebViewBridge) {
		bridge.registerHandlerForJS(handlerName: "getUserInfo", handler: { jsonData, responseCallback in
			print(responseCallback)
			responseCallback([
				"name": "zx",
				"userId": 233
			])
		})
        
        bridge.registerHandlerForJS(handlerName: "getDeviceInfo", handler: { jsonData, responseCallback in
            print(responseCallback)
            let deviceType = UIDevice.currentDevice().deviceType.description()
            responseCallback([
                "deviceType": deviceType,
                "systemVersion": UIDevice.currentDevice().systemVersion,
                "systemName": UIDevice.currentDevice().systemName
                ])
        })
	}
}
