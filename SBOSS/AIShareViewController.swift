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

class AIShareViewController: UIViewController {
 
    @IBOutlet weak var tableView: UITableView!
    private var currentUrl:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        ("http://detail.m.tmall.com/item.htm?id=38131345289&spm=a2147.7632989.mainList.5",
        "<WBUPrintPageRenderer: 0x7fe1bb42cfb0>",
        "<UIPrintInfo: 0x7fe1bb3846e0>")
        */

        let item: NSExtensionItem = self.extensionContext!.inputItems.first as NSExtensionItem
       
        let itemProvider = item.attachments?.first as NSItemProvider
        itemProvider.loadItemForTypeIdentifier("public.url", options: nil) { (objcet, error) -> Void in
            let string = String(stringLiteral: "\(objcet)")
            self.currentUrl = string
            println(string)
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
    
    @IBAction func closeThisViewController(){
        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
    }
}


extension AIShareViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AIShareHeadViewCell") as AIShareHeadViewCell
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
}

class AIShareHeadViewCell :UITableViewCell{
    
}
