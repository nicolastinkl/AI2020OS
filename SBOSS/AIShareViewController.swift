//
//  AIShareViewController.swift
//  AI2020OS
//
//  Created by tinkl on 2/6/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit
import Social
import WebKit

private let TitleKeyPath = "title"

private let EstimatedProgressKeyPath = "estimatedProgress"


public class AIShareViewController: UIViewController,UIWebViewDelegate {
 
    @IBOutlet weak var tableView: UITableView!
 
    private var currentUrl:String?
    
    // MARK: Properties
    
    ///  Returns the web view for the controller.
    public final var webView: UIWebView {
        get {
            return _webView
        }
    }
    
    ///  Returns the progress view for the controller.
    public final var progressBar: UIProgressView {
        get {
            return _progressBar
        }
    }
    
    ///  The URL request for the web view. Upon setting this property, the web view immediately begins loading the request.
    public final var urlRequest: NSURLRequest {
        didSet {
            webView.loadRequest(urlRequest)
        }
    }
    
    ///  Specifies whether or not to display the web view title as the navigation bar title.
    ///  The default value is `false`, which sets the navigation bar title to the URL host name of the URL request.
    public final var displaysWebViewTitle: Bool = false
    
    // MARK: Private properties
    
    private lazy final var _webView: UIWebView = { [unowned self] in
        // FIXME: prevent Swift bug, lazy property initialized twice from `init(coder:)`
        // return existing webView if webView already added
        let views = self.view.subviews.filter {$0 is UIWebView } as [UIWebView]
        if views.count != 0 {
            return views.first!
        }
        
//        let webView = WKWebView(frame: self.view.bounds, configuration: self.configuration)
        let webView = UIWebView(frame: self.view.bounds)
        self.view.addSubview(webView)
        webView.delegate = self
        webView.addObserver(self, forKeyPath: TitleKeyPath, options: .New, context: nil)
        webView.addObserver(self, forKeyPath: EstimatedProgressKeyPath, options: .New, context: nil)
//        webView.allowsBackForwardNavigationGestures = true
        return webView
        }()
    
    private lazy final var _progressBar: UIProgressView = { [unowned self] in
        let progressBar = UIProgressView(progressViewStyle: .Bar)
        progressBar.backgroundColor = .clearColor()
        progressBar.trackTintColor = .clearColor()
        self.view.addSubview(progressBar)
        return progressBar
        }()
    
    private final let configuration: WKWebViewConfiguration
    
    private final let activities: [UIActivity]?
    
    // MARK: Initialization
    
    ///  Constructs a new `WebViewController`.
    ///
    ///  :param: urlRequest    The URL request for the web view to load.
    ///  :param: configuration The configuration for the web view.
    ///  :param: activities    The custom activities to display in the `UIActivityViewController` that is presented when the action button is tapped.
    ///
    ///  :returns: A new `WebViewController` instance.
    public init(urlRequest: NSURLRequest, configuration: WKWebViewConfiguration = WKWebViewConfiguration(), activities: [UIActivity]? = nil) {
        self.configuration = configuration
        self.urlRequest = urlRequest
        self.activities = activities
        super.init(nibName: nil, bundle: nil)
    }
    
    ///  Constructs a new `WebViewController`.
    ///
    ///  :param: url The URL to display in the web view.
    ///
    ///  :returns: A new `WebViewController` instance.
    public convenience init(url: NSURL) {
        self.init(urlRequest: NSURLRequest(URL: url))
    }
    
    ///  :nodoc:
    public required init(coder aDecoder: NSCoder) {
        self.configuration = WKWebViewConfiguration()
        self.urlRequest = NSURLRequest(URL: NSURL(string: "")!)
        self.activities = nil
        super.init(coder: aDecoder)
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: TitleKeyPath, context: nil)
        webView.removeObserver(self, forKeyPath: EstimatedProgressKeyPath, context: nil)
    }
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.webView.frame.origin.y = 20
        
        let item: NSExtensionItem = self.extensionContext!.inputItems.first as NSExtensionItem
       
        let itemProvider = item.attachments?.first as NSItemProvider
        itemProvider.loadItemForTypeIdentifier("public.url", options: nil) { (objcet, error) -> Void in
            let string = String(stringLiteral: "\(objcet)")
            self.currentUrl = string
            
            if let url  = self.currentUrl {
                self.urlRequest = NSURLRequest(URL: NSURL(string: url)!)
                self.webView.loadRequest(self.urlRequest)
                self.title = self.urlRequest.URL.host
                
            }
        }
        
        
        /*if let dict = item.userInfo{
            for item in item.attachments as [NSItemProvider]{
                println(item)
            }
            
            if let data = dict[NSExtensionItemAttributedContentTextKey] as NSData?{
                //http://detail.m.tmall.com/item.htm?id=38131345289&spm=a2147.7632989.mainList.5
                let strinssg = String(UTF8String:UnsafePointer<CChar>((data as NSData).bytes))
               
            }
        }

        */
    }
    
    
    ///  :nodoc:
    public override func viewWillAppear(animated: Bool) {
        assert(navigationController != nil, "\(AIShareViewController.self) must be presented in a \(UINavigationController.self)")
        super.viewWillAppear(animated)
    }
    
    ///  :nodoc:
    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        webView.stopLoading()
    }
    
    ///  :nodoc:
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
        view.bringSubviewToFront(progressBar)
        progressBar.frame = CGRect(x: 0, y: topLayoutGuide.length, width: view.frame.size.width, height: 2)
    }
    
    
    // MARK: Actions
    
    @IBAction func closeThisViewController(){
        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
    }
    
    // MARK: KVO
    
    ///  :nodoc:
   /* public override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if object as? NSObject == webView {
            switch keyPath {
            case TitleKeyPath:
                if displaysWebViewTitle {
                    title = webView.title
                }
                
            case EstimatedProgressKeyPath:
                let completed = webView.estimatedProgress == 1.0
                progressBar.setProgress(completed ? 0.0 : Float(webView.estimatedProgress), animated: !completed)
                //UIApplication.sharedApplication().networkActivityIndicatorVisible = !completed
                
            default: break
            }
        }
        else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    */

    // MARK: Web Delegate
    
    func webView(webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: UIWebViewNavigationType) -> Bool {
        var url = request.URL.absoluteString!;
 
        if(url.hasPrefix("ios://")){
            println(url)
            var a = (url as NSString).substringFromIndex(6)
            self.extensionContext!.openURL(NSURL(string: "sboss://"+a)!, completionHandler: nil)
            self.closeThisViewController()
            return false
        }
        return true
    }
    
}


extension AIShareViewController: UITableViewDataSource,UITableViewDelegate {
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AIShareHeadViewCell") as AIShareHeadViewCell
        
        return cell
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
}

class AIShareHeadViewCell :UITableViewCell{
    
}
