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

    /// Vars
    @IBOutlet weak var payContent: DesignableTextView!
    @IBOutlet weak var wishContent: DesignableTextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var scrollview: UIScrollView!
    
    private var preCacheView: UIView?
    private var currentAlertView: AIAlertWishInputView?
    private var cucacheModel: AIWishHotModel?
    
    /// reqeust json args
    private var typeID: Int = 0
    private var name: String = ""
    private var contents: String = ""
    private var money: Double = 0.0
    
    /**
     Method Init
     */
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
    
    //刷新按钮状态
    func refereshButtonStatus(enble: Bool) {
        if enble {
            self.submitButton.backgroundColor = UIColor(hexString: "#0E79CC", alpha: 0.8)
            self.submitButton.enabled = true
        } else {
            self.submitButton.backgroundColor = UIColor.grayColor()
            self.submitButton.enabled = false
        }
        
    }
    
    /// 查询最火和推荐心愿
    func queryWishs() {
        
        AIWishServices.requestHotQueryWishs("") { (objc, error) in
            if let model = objc as? AIWishHotModel {
                self.refereshBubble(model)
            }
        }
        
    }
    
    //刷新最热和推荐心愿气泡
    func refereshBubble(wishModel: AIWishHotModel) {
        cucacheModel = wishModel
        
        let deepColor = ["ca9e82", "936d4c", "aa6e28", "574d71", "7e3d60", "438091", "ad2063", "5f257d", "162c18", "B10000", "4a5679", "6b4a1d", "1b1a3a", "aa6e28", "6a8e5c", "", "", "", ""]
        let undertoneColor = ["5198ac", "ae9277", "cdaf13", "696a9a", "c3746a", "6c929f", "cf4e5a", "9c417c", "32542c", "F25A68", "7e6479", "aa822a", "81476a", "cdaf13", "93a44b", "", "", "", ""]
        let borderColor = ["9bd6f2", "f8b989", "fee34a", "8986c2", "f88d8e", "6db8d5", "ef6d83", "cd53e1", "528319", "F25A68", "8986c2", "e6ad44", "c474ac", "fee34a", "93bd78", "", "", "", ""]
        
        /**
         推荐许愿
         */
        let title1 = AIWishTitleIconView.initFromNib() as! AIWishTitleIconView
        title1.icon.image = UIImage(named: "AI_Wish_Make_instrst")
        title1.title.text = "Recommended Wish"
        addNewSubView(title1, preView: UIView(), space : 12)
        
        let bubbleViewContain = UIView()
        bubbleViewContain.setHeight(0)
        let modelHotCount = wishModel.recommended_wish_list?.count
        if modelHotCount > 0 {
            var i = 0
            for hotModel in wishModel.recommended_wish_list! {
                let model = AIBuyerBubbleModel()
                model.proposal_id = hotModel.type_id
                model.proposal_name = hotModel.name
                model.proposal_price = "\(hotModel.money_unit)\(hotModel.money_adv)"
                model.order_times = hotModel.already_wish
                
                model.deepColor = deepColor[i]
                model.undertoneColor = undertoneColor[i]
                model.borderColor = borderColor[i]
                
                let marginLeft = AITools.displaySizeFrom1242DesignSize(34)
                let space = AITools.displaySizeFrom1242DesignSize(15)
                let bubbleWidth = (screenWidth - marginLeft * 2 - space * 3) / 4
                model.bubbleSize = Int(bubbleWidth)/2
                let bubbleView = AIBubble(center: .zero, model: model, type: Int(typeToNormal.rawValue), index: 0)
                bubbleViewContain.addSubview(bubbleView)
                bubbleView.tag = i
                let bubbleY = AITools.displaySizeFrom1242DesignSize(87)
                bubbleView.frame = CGRect(x: marginLeft + CGFloat(i) * (bubbleWidth + space), y: bubbleY, width: bubbleWidth, height: bubbleWidth)
                bubbleView.tag = i
                
                bubbleView.userInteractionEnabled = true
                bubbleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AIWishVowViewController.prewishReComAction(_:))))
                i += 1
            }
            bubbleViewContain.setHeight(125)
        }
        addNewSubView(bubbleViewContain, preView: title1, space : 0)
        
        let title2 = AIWishTitleIconView.initFromNib() as! AIWishTitleIconView
        title2.icon.image = UIImage(named: "AI_Wish_Make_hot")
        title2.title.text = "Popular Wish"
        addNewSubView(title2, preView: bubbleViewContain, space : 12)
        
        
        /**
         最火心愿
         */
        let bubbleViewContainHot = UIView()
        bubbleViewContainHot.setHeight(0)
        let modelHotHotCount = wishModel.hot_wish_list?.count
        if modelHotHotCount > 0 {
            var i = 0
            for hotModel in wishModel.hot_wish_list! {
                let model = AIBuyerBubbleModel()
                model.proposal_id = hotModel.type_id
                model.proposal_name = hotModel.name
                model.proposal_price = "\(hotModel.money_unit)\(hotModel.money_adv)"
                model.order_times = hotModel.already_wish
                
                model.deepColor = deepColor[i]
                model.undertoneColor = undertoneColor[i]
                model.borderColor = borderColor[i]
                
                let marginLeft = AITools.displaySizeFrom1242DesignSize(34)
                let space = AITools.displaySizeFrom1242DesignSize(15)
                let bubbleWidth = (screenWidth - marginLeft * 2 - space * 3) / 4
                model.bubbleSize = Int(bubbleWidth)/2
                let bubbleView = AIBubble(center: .zero, model: model, type: Int(typeToNormal.rawValue), index: 0)
                bubbleViewContainHot.addSubview(bubbleView)
                bubbleView.tag = i
                let bubbleY = AITools.displaySizeFrom1242DesignSize(87)
                bubbleView.frame = CGRect(x: marginLeft + CGFloat(i) * (bubbleWidth + space), y: bubbleY, width: bubbleWidth, height: bubbleWidth)
                bubbleView.tag = i
                
                bubbleView.userInteractionEnabled = true
                bubbleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AIWishVowViewController.prewishHotAction(_:))))
                i += 1
            }
            bubbleViewContainHot.setHeight(125)
        }
        addNewSubView(bubbleViewContainHot, preView: title2, space : 0)
        
    }
    
    //查看推荐心愿详情
    func prewishReComAction(send: UITapGestureRecognizer) {
        if let s = send.view {
            if let models = cucacheModel?.recommended_wish_list {
                let model = models[s.tag]
                let vc = AIWishPreviewController.initFromNib()
                vc.model = model
                showTransitionStyleCrossDissolveView(vc)
            }
            
        }
    }
    
    //查看最火心愿详情
    func prewishHotAction(send: UITapGestureRecognizer) {
        if let s = send.view {
            if let models = cucacheModel?.hot_wish_list {
                let model = models[s.tag]
                let vc = AIWishPreviewController.initFromNib()
                vc.model = model
                showTransitionStyleCrossDissolveView(vc)
            }
            
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
    
    func realSubmitAction() {
        
        if let text = currentAlertView?.textInputView.text {            
            view.showLoading()
            self.name = text
            AIWishServices.requestMakeWishs(typeID, name: text, money: money, contents: contents, complate: { (obj, error) in
                self.view.hideLoading()
                if let proposal_id = obj as? Int {
                    let model = AIBuyerBubbleModel()
                    model.order_times = 1
                    model.proposal_id_new = 1
                    model.proposal_name = self.name
                    model.proposal_price = "￥\(self.money)"
                    model.service_list = []
                    self.typeID = proposal_id
                    model.service_id = proposal_id
                    model.proposal_type = 3
                    NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.WishVowViewControllerNOTIFY, object: model)
                } else {
                    AIAlertView().showError("提示", subTitle: "提交失败，请重新提交")
                }
            })
            
            
        }
 
    }
    
    
    
    /// 提交按钮
    @IBAction func SubmitAction(sender: AnyObject) {
        
        if let stext = self.wishContent.text {
            let number = self.payContent.text
            let d = Double(number) ?? 0
            if d <= 0.0 {
                AIAlertView().showError("提示", subTitle: "提交失败，金额输入有误")
                return
            }
            contents = stext
            money = d
            if let alertView = AIAlertWishInputView.initFromNib() as? AIAlertWishInputView {
                self.view.addSubview(alertView)
                alertView.alpha = 0
                alertView.snp_makeConstraints(closure: { (make) in
                    make.edges.equalTo(self.view)
                })
                SpringAnimation.springEaseIn(0.5, animations: {
                    alertView.alpha = 1
                })
                self.currentAlertView = alertView
                alertView.buttonSubmit.addTarget(self, action: #selector(AIWishVowViewController.realSubmitAction), forControlEvents: UIControlEvents.TouchUpInside)
            }
            
        }
    }
    
}

// MARK: - extension
extension AIWishVowViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        let text = textView.text
        if text == "  Your Could write down your wish here or select from blew." || text == "  0 Euro" {
            textView.text = ""
        }
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        if payContent.text.length > 0 && wishContent.text.length > 0 {
            //判断金额为数字
            let number = self.payContent.text
            let d = Double(number) ?? 0
            if d > 0.0 {
                refereshButtonStatus(true)
            } else {
                refereshButtonStatus(false)
            }
        } else {
            refereshButtonStatus(false)
        }
    }
}
