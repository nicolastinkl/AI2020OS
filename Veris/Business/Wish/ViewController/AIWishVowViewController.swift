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
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var scrollview: UIScrollView!
    
    private var preCacheView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refereshButtonStatus(false)
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
    
    func refereshButtonStatus(enble: Bool){
        if enble {
            self.submitButton.backgroundColor = UIColor(hexString: "#0E79CC", alpha: 0.8)
            self.submitButton.enabled = true
        }else{
            self.submitButton.backgroundColor = UIColor.grayColor()
            self.submitButton.enabled = false
        }
        
    }
    
    func queryWishs(){
        AIWishServices.requestQueryWishs { (objc, error) in
            
        }
        
        Async.main { 
            self.refereshBubble()
        }
    }
    
    
    func refereshBubble(){
        let title1 = AIWishTitleIconView.initFromNib() as! AIWishTitleIconView
        title1.icon.image = UIImage(named: "AI_Wish_Make_instrst")
        title1.title.text = "Recommended Wish"
        addNewSubView(title1, preView: UIView(), space : 12)
        
        let bubbleViewContain = UIView()
        bubbleViewContain.setHeight(0)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let bubbleModels = appDelegate.dataSourcePop
        if bubbleModels.count > 0 {
            for i in 0..<min(4, bubbleModels.count) {
                let model: AIBuyerBubbleModel! = bubbleModels[i]
                let marginLeft = AITools.displaySizeFrom1242DesignSize(34)
                let space = AITools.displaySizeFrom1242DesignSize(15)
                let bubbleWidth = (screenWidth - marginLeft * 2 - space * 3) / 4
                model.bubbleSize = Int(bubbleWidth)/2
                let bubbleView = AIBubble(center: .zero, model: model, type: model.bubbleType, index: 0)
                bubbleViewContain.addSubview(bubbleView)
                bubbleView.tag = i
                let bubbleY = AITools.displaySizeFrom1242DesignSize(87)
                bubbleView.frame = CGRect(x: marginLeft + CGFloat(i) * (bubbleWidth + space), y: bubbleY, width: bubbleWidth, height: bubbleWidth)
                bubbleView.tag = i
                
                bubbleView.userInteractionEnabled = true
                bubbleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AIWishVowViewController.prewishAction(_:))))
                
            }
            
            bubbleViewContain.setHeight(125)
        }
        addNewSubView(bubbleViewContain, preView: title1, space : 0)
        
        
        let title2 = AIWishTitleIconView.initFromNib() as! AIWishTitleIconView
        title2.icon.image = UIImage(named: "AI_Wish_Make_hot")
        title2.title.text = "Popular Wish"
        addNewSubView(title2, preView: bubbleViewContain, space : 12)
 
    }
    
    func prewishAction(send: UITapGestureRecognizer){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let bubbleModels = appDelegate.dataSourcePop
        if let s = send.view {
            let model = bubbleModels[s.tag]
            let vc = AIWishPreviewController.initFromNib() 
            vc.model = model
            showTransitionStyleCrossDissolveView(vc)
        }
    }
    
    /**
     copy from old View Controller.
     */
    func addNewSubView(cview: UIView, preView: UIView, color: UIColor = UIColor.clearColor(), space: CGFloat = 0) {
        scrollview.addSubview(cview)
        cview.setWidth(UIScreen.mainScreen().bounds.width)
        cview.setTop(preView.top + preView.height+space)
        cview.backgroundColor =  UIColor.clearColor()
        scrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), cview.top + cview.height)
        preCacheView = cview
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
                        // 退出当前界面 然后通知主页刷新
                        // AIAlertView().showSuccess("提示", subTitle: "提交成功")
                        self.payContent.text = "  0 Euro"
                        self.wishContent.text = "  Your Could write down your wish here or select from blew."
                        
                        let model = AIBuyerBubbleModel()
                        model.order_times = 1
                        model.proposal_id_new = 1
                        model.proposal_name = stext
                        model.proposal_price = number
                        model.service_list = []
                        NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.WishVowViewControllerNOTIFY, object: model)
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        AIAlertView().showError("提示", subTitle: "提交失败，请重新提交")
                    }
            })
        }
    }
    
}


extension AIWishVowViewController: UITextViewDelegate{
    func textViewDidChange(textView: UITextView) {
        if payContent.text.length > 0 && wishContent.text.length > 0  {
            refereshButtonStatus(true)
        }else{
            refereshButtonStatus(false)
        }
    }
}
