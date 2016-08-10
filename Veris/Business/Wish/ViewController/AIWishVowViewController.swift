//
//  AIWishVowViewController.swift
//  AIVeris
//
// Copyright (c) 2016 ___ASIAINFO___
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import UIKit
import Spring
import Cartography
import AIAlertView
import SnapKit

/// 许愿视图
class AIWishVowViewController: UIViewController {

    @IBOutlet weak var payContent: DesignableTextView!
    @IBOutlet weak var wishContent: DesignableTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Register Audio Tools Notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AICustomSearchHomeViewController.listeningAudioTools), name: AIApplication.Notification.AIListeningAudioTools, object: nil)
        
        if let navi = AINavigationBar.initFromNib() as? AINavigationBar {
            view.addSubview(navi)
            navi.holderViewController = self
            constrain(navi, block: { (layout) in
                layout.left == layout.superview!.left
                layout.top == layout.superview!.top
                layout.right == layout.superview!.right
                layout.height == 44.0 + 10.0
            })
            navi.titleLabel.font = AITools.myriadLightWithSize(24)
            navi.titleLabel.text = "Make a wish"
            navi.backButton.setImage(UIImage(named: "scan_back"), forState: UIControlState.Normal)
        }

        Async.background(after: 0.1) { 
            self.queryWishs()
        }
    }
    
    func queryWishs() {
        AIWishServices.requestQueryWishs { (objc, error) in
            
        }
    }
    
    /**
     处理语音识别数据搜索
     
     */
    func listeningAudioTools(notify: NSNotification) {
        if let result = notify.userInfo {
            let string = result["Results"] as? String
            Async.main({
                self.wishContent.text = string ?? ""                
            })
        }
    }
    
    /// 语音录入
    @IBAction func audioAction(sender: AnyObject) {
    
        showTransitionStyleCrossDissolveView(AIAudioSearchViewController.initFromNib())
        
    }
    
    /// 提交按钮
    @IBAction func SubmitAction(sender: AnyObject) {
        
        if let stext = self.wishContent.text {
            let number = self.payContent.text
            let d = Double(number) ?? 0
            view.showLoading()
            AIWishServices.requestMakeWishs(d, wish: stext, complate: { (obj, error)  in
                    self.view.hideLoading()
                    if let _ = obj {
                        AIAlertView().showSuccess("提示", subTitle: "提交成功")
                        self.payContent.text = "  0 Euro"
                        self.wishContent.text = "  Your Could write down your wish here or select from blew."
                    } else {
                        AIAlertView().showError("提示", subTitle: "提交失败，请重新提交")
                    }
            })
        }
    }
    
}
