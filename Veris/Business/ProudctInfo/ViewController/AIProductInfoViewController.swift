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
import IQKeyboardManagerSwift

/// 商品详情视图
class AIProductInfoViewController: UIViewController {
	
    // MARK: - Propites
	private let defaultTableViewHeaderMargin: CGFloat = 184//413.0
    
	private let imageScalingFactor: CGFloat = 184//413.0
	
	@IBOutlet weak var scrollview: UIScrollView!
	
	private var preCacheView: UIView?
	
	private var navi = AINavigationBar.initFromNib()
	
	private let topImage = AIImageView()
    var sid: Int = 0
    var proposal_id: Int = 0 //服务定制
    private var dataModel: AIProdcutinfoModel?
	
    private var currentAudioView: AIAudioInputView?
    
    var curTextField: UITextField?
    private var singleButton: DesignableButton?
    var curAudioView: AIAudioMessageView?
    
    // 缓存输入信息
    var customNoteModelCache: AIProductInfoCustomerNote?
    private var inputMessageCache: String = ""
    var serviceContentType: AIServiceContentType = .None
    private var audioView_AudioRecordView: AIAudioRecordView?
    private var scrollViewSubviews = [UIView]()
    
    private let redColor: String = "#b32b1d"
    @IBOutlet var tapGes: UITapGestureRecognizer!
    
    private let topButton = UIButton()
    private let editButton = UIButton()
    private let isStepperEditing = false
    private var cacheNote: AIProposalServiceDetail_WishModel?
    private var bottomViewCache: UIView?
    private var cachePriceLabel: UILabel?
    private var selectedPID: Int = 0
    // MARK: 取消键盘
    
    func shouldHideKeyboard () {
        if curTextField != nil {
            curTextField?.resignFirstResponder()
            curTextField = nil
        }
    }
    
    // MARK: - Init Function
	/**
	 Init
	 */
	override func viewDidLoad() {
		super.viewDidLoad()
        
		// Add ContentOffSet Listen.
		configureObserver()
		
		// Make AINavigationBar 'View.
		initLayoutViews()
        
        // Make Config Buttons.
        configButtons()
		
        // add addKeyboardNotifications
        addKeyboardNotifications()
        
        // add Notify
        addNotifyListen()
        
		// Make UIScrollView.
		Async.main(after: 0.1) {
            self.requestData()			
		}
	}
    
    func addNotifyListen() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AIProductInfoViewController.referCustomDataStuct(_:)), name: "referCustomDataStuctNOTIFY", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = true
    }
    
    // MARK: 键盘事件
    
    func addKeyboardNotifications () {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AIServiceContentViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AIServiceContentViewController.keyboardDidShow(_:)), name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AIServiceContentViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AIServiceContentViewController.keyboardDidHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AIProductInfoViewController.popToRootView), name: AIApplication.Notification.WishVowViewControllerNOTIFY, object: nil)
        
    }
    
    func popToRootView() {
        self.dismissViewControllerAnimated(false, completion: nil)
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func removeKeyboardNotifications() {
        let names = [UIKeyboardWillShowNotification,
                     UIKeyboardDidShowNotification, UIKeyboardWillHideNotification, UIKeyboardDidHideNotification, UIKeyboardDidChangeFrameNotification]
        let center = NSNotificationCenter.defaultCenter()
        for name in names {
            center.removeObserver(self, name: name, object: nil)
        }
    }
    
    func keyboardDidChange(notification: NSNotification) {
        if self.isStepperEditing {
            return
        }
        // change keyboard height
        
        if let userInfo = notification.userInfo {
            
            // step 1: get keyboard height
            let keyboardRectValue: NSValue = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
            let keyboardRect: CGRect = keyboardRectValue.CGRectValue()
            let keyboardHeight: CGFloat = min(CGRectGetHeight(keyboardRect), CGRectGetWidth(keyboardRect))
            
            if let view1 = self.currentAudioView {
                if keyboardHeight > 0 {
                    let newLayoutConstraint = keyboardHeight - view1.holdViewHeigh
                    view1.inputButtomValue.constant = newLayoutConstraint
                }
            }
            
        }
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if self.isStepperEditing {
            return
        }
        
        if curTextField == nil {
            return
        }
        
        if let userInfo = notification.userInfo {
            self.currentAudioView?.changeModel(1)
            // step 1: get keyboard height
            let keyboardRectValue: NSValue = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
            let keyboardRect: CGRect = keyboardRectValue.CGRectValue()
            let keyboardHeight: CGFloat = min(CGRectGetHeight(keyboardRect), CGRectGetWidth(keyboardRect))
            
//            scrollview.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0)
//            scrollViewBottom()
            
            if let view1 = self.currentAudioView {
                if keyboardHeight > 0 {
                    let newLayoutConstraint = keyboardHeight - view1.holdViewHeigh
                    view1.inputButtomValue.constant = newLayoutConstraint
                }
            }
            // hidden
            if let view1 = self.currentAudioView {
                view1.audioButtonView.hidden = true
            }
            
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        if self.isStepperEditing {
            return
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.isStepperEditing {
            return
        }
        
        if curTextField == nil {
            return
        }
        //scrollview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        //scrollViewBottom()
        if let view1 = self.currentAudioView {
            view1.audioButtonView.hidden = false
        }
        
    }
    
    func keyboardDidHide(notification: NSNotification) {
        
        
        if self.isStepperEditing {
            return
        }
        
        if curTextField == nil {
            return
        }
        
        if let view1 = self.currentAudioView {
            view1.inputButtomValue.constant = 1
        }
    }
    
    func requestData() {
        view.showLoading()
        AIProdcutInfoService.requestServiceInfo("\(sid)") { (response, error) in
            self.view.hideLoading()
            if let model = response as? AIProdcutinfoModel {
                self.view.hideErrorView()
                self.dataModel = model
                self.customNoteModelCache = model.customer_note
                self.initScrollViewData()
            } else {
                self.view.showErrorView()
            }
        }
    }
    
    /**
     重新请求数据
     */
    func retryNetworkingAction() {        
        requestData()
    }
    
    /**
     定制按钮和Top按钮
     */
    func configButtons() {
        
        view.addSubview(topButton)
        view.addSubview(editButton)
        self.editButton.hidden = true
        self.topButton.hidden = true
        topButton.setImage(UIImage(named: "AI_ProductInfo_Home_Edit"), forState: UIControlState.Normal)
        editButton.setImage(UIImage(named: "AI_ProductInfo_Home_Top"), forState: UIControlState.Normal)
        
        topButton.sizeToWidthAndHeight(38.6)
        editButton.sizeToWidthAndHeight(38.6)
        topButton.pinToRightEdgeOfSuperview(offset: 13, priority: UILayoutPriorityDefaultHigh)
        editButton.pinToRightEdgeOfSuperview(offset: 13, priority: UILayoutPriorityDefaultHigh)
        
        topButton.positionViewsBelow([editButton], offset: 15, priority: UILayoutPriorityDefaultHigh)
        topButton.pinToBottomEdgeOfSuperview(offset: 100, priority: UILayoutPriorityDefaultHigh)
        
        topButton.addTarget(self, action: #selector(AIProductInfoViewController.editAction), forControlEvents: UIControlEvents.TouchUpInside)
        editButton.addTarget(self, action: #selector(AIProductInfoViewController.topAction), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
	/**
	 observerValueForKeyPath.
	 */
	override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String: AnyObject]?, context: UnsafeMutablePointer<Void>) {
		if keyPath == "contentOffset" {
			scrollViewDidScrollWithOffset(scrollview.contentOffset.y)
		} else {
			super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
		}
	}
	
	private func configureObserver() {
		scrollview.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
	}
	
	/**
	 处理大图放大缩小效果
	 */
	func scrollViewDidScrollWithOffset(scrollOffset: CGFloat) {
        
        let alphaSc = (scrollOffset / defaultTableViewHeaderMargin)
        if let navi = self.navi as? AINavigationBar {
            navi.bgView.subviews.first?.alpha = alphaSc
        }
        
        if alphaSc >= 1 {
            self.editButton.hidden = false
            self.topButton.hidden = false
        } else {
            self.editButton.hidden = true
            self.topButton.hidden = true
        }
        
        /*if self.scrollview.contentOffset.y >= self.scrollview.height && (self.scrollview.contentOffset.y + self.scrollview.height) >= self.scrollview.contentSize.height {
            //self.scrollview.setContentOffset(CGPointMake(0, self.scrollview.contentSize.height), animated: false)
            self.scrollview.scrollEnabled = false
        } else {
            self.scrollview.scrollEnabled = true
        }
		//animateImageView(scrollOffset, draggingPoint: scrollViewDragPoint, alpha: 1.0)
		*/
	}
	
	// MAKE 处理Navigationbar 背景模糊虚化效果.
	func animateImageView(scrollOffset: CGFloat, draggingPoint: CGPoint, alpha: CGFloat) {
		
		animateNavigationBar(scrollOffset, draggingPoint: draggingPoint)
		if scrollOffset > draggingPoint.y && scrollOffset > defaultTableViewHeaderMargin {
			UIView.animateWithDuration(0.3, animations: {
				if let navi = self.navi as? AINavigationBar {
					navi.bgView.subviews.first?.alpha = 1.0
				}
			})
		} else if scrollOffset <= defaultTableViewHeaderMargin {
			UIView.animateWithDuration(0.3, animations: {
				if let navi = self.navi as? AINavigationBar {
					navi.bgView.subviews.first?.alpha = 0
				}
			})
		}
	}
	
	func animateNavigationBar(scrollOffset: CGFloat, draggingPoint: CGPoint) {
		
	}
	
	/**
	 Init with TOP VIEW.
	 */
	func initLayoutViews() {
		
        /// self.scrollview.contentInset = UIEdgeInsetsMake(0, 0, 300, 0)
		/// Title.
		if let navi = navi as? AINavigationBar {
			view.addSubview(navi)
			navi.holderViewController = self
			constrain(navi, block: { (layout) in
				layout.left == layout.superview!.left
				layout.top == layout.superview!.top
				layout.right == layout.superview!.right
				layout.height == 44.0 + 10.0 + 17
			})
            
            navi.backButton.setImage(UIImage(named: "AI_ProductInfo_Home_Back"), forState: UIControlState.Normal)
            navi.commentButton.setImage(UIImage(named: "AI_ProductInfo_Home_Favirtor"), forState: UIControlState.Normal)
            navi.videoButton.setImage(UIImage(named: "AI_ProductInfo_Home_Shared"), forState: UIControlState.Normal)
            navi.videoButton.addTarget(self, action: #selector(shareAction), forControlEvents: UIControlEvents.TouchUpInside)
			navi.titleLabel.text = ""
            navi.commentButton.addTarget(self, action: #selector(favoriteAction), forControlEvents: UIControlEvents.TouchUpInside)
            
		}
	}

    func favoriteAction() {
        //查看哪个选中
        var ssid = 0
        if let button = singleButton {
            ssid = button.tag
        }
        func refershFaviButtonStatus(isFavi: Bool) {
            if let navi = self.navi as? AINavigationBar {
                
                if isFavi {
                    navi.setRightIcon1Action(UIImage(named: "AINavigationBar_faviator_ok_pro")!)

                } else {
                    navi.setRightIcon1Action(UIImage(named: "AI_ProductInfo_Home_Favirtor")!)
                }
                
                navi.commentButton.animation = "pop"
                navi.commentButton.animate()

                NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIRefreshBuyerCenterNotification, object: nil)
            }
        }
        
        // 判断是否已经收藏
        view.showLoading()
        if let bol = dataModel?.collected {
            if bol {
                AIProdcutInfoService.removeFavoriteServiceInfo(String(dataModel?.proposal_inst_id ?? 0), complate: { (obj, error) in
                    self.view.hideLoading()
                    if let res = obj as? String {
                        // MARK: Loading Data Views
                        if res == "1" {
                            self.dataModel?.collected = false
                            refershFaviButtonStatus(false)
                        } else {
                            AIAlertView().showError("取消收藏失败", subTitle: "")
                        }
                    }
                })
            } else {
                AIProdcutInfoService.addFavoriteServiceInfo(String(dataModel?.proposal_inst_id ?? 0), proposal_spec_id: ssid == 0 ? "" : String(ssid)) { (obj, error) in
                    self.view.hideLoading()
                    if let res = obj as? String {
                        // MARK: Loading Data Views
                        if res == "1" {
                            self.dataModel?.collected = true
                            refershFaviButtonStatus(true)
                        } else {
                            AIAlertView().showError("收藏失败", subTitle: "")
                        }
                    }
                }
                
            }
        }
        
    }


    //MARK: Share Action

    func shareAction() {
        //如果需要分享回调，请将delegate对象设置self，并实现下面的回调方法
        UMSocialData.defaultData().extConfig.title = "分享的title"
        UMSocialSnsService.presentSnsIconSheetView(self, appKey: AIApplication.UMengAppID, shareText: "ZhuangBi With Me & Fly With Me", shareImage: nil, shareToSnsNames: [UMShareToWechatSession, UMShareToWechatTimeline, UMShareToSina, UMShareToQQ, UMShareToQzone], delegate: self)
    }

    private lazy var galleryView: AIGalleryView = {
        let gView = AIGalleryView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 184))
        return gView
    }()
    
    private func addGalleryView() {
        // Add gallery View        
        scrollview.addSubview(galleryView)
        scrollViewSubviews.append(galleryView)
        let imageArray = dataModel?.intro_urls ?? [String]()
        galleryView.imageModelArray = imageArray
        galleryView.setTop(5)
    }
    
    // MARK: - Init ScrollData
	func initScrollViewData() {
        //处理是否收藏
        if let navinew = navi as? AINavigationBar {
            
            if dataModel?.collected == false {
                //未收藏
                navinew.setRightIcon1Action(UIImage(named: "AI_ProductInfo_Home_Favirtor")!)
            } else {
                navinew.setRightIcon1Action(UIImage(named: "AINavigationBar_faviator_ok_pro")!)
            }
        }
        
		/**
		 定制的TitleView
		 */
		func getTitleLabelView(title: String, desctiption: String = "", showRight: Bool = true) -> UIView {
			let heightLabel: CGFloat = 108 / 3
			let tView = UIView()
			tView.frame = CGRectMake(0, 0, self.view.width, heightLabel)
			
			let titleLabel = AILabel()
			titleLabel.text = title
			titleLabel.setHeight(heightLabel)
			titleLabel.font = UIFont.systemFontOfSize(42 / 3)
			titleLabel.textColor = UIColor(hexString: "#FFFFFF")
			
			let desLabel = AILabel()
			desLabel.text = desctiption
			desLabel.setHeight(heightLabel)
			desLabel.font = UIFont.systemFontOfSize(36 / 3)
			desLabel.textColor = UIColor(hexString: "#FFFFFF", alpha: 0.5)
			
			tView.addSubview(titleLabel)
			tView.addSubview(desLabel)
			titleLabel.frame = CGRectMake(0, 0, 300, heightLabel)
			desLabel.frame = CGRectMake(80, 0, 180, heightLabel)
			
			let imageview = UIImageView()
			imageview.image = UIImage(named: "right_triangle")
			tView.addSubview(imageview)
			imageview.contentMode = UIViewContentMode.ScaleToFill
			imageview.frame = CGRectMake(view.width - 15, 10, 8, 12)
			imageview.hidden = !showRight
			return tView
		}
		
		// Setup 1 : Top UIImageView.
//		topImage.setImgURL(NSURL(string: dataModel?.image ?? ""), placeholderImage: smallPlace())
//		topImage.setHeight(imageScalingFactor)
//		topImage.contentMode = UIViewContentMode.ScaleAspectFill
//		addNewSubView(topImage, preView: UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)))
        
        addNewSubView(galleryView, preView: UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)))
        let imageArray = dataModel?.intro_urls ?? ["http://tse3.mm.bing.net/th?id=OIP.Ma65ba536a2e6bb096726be3701507c3co0&w=104&h=149&c=7&rs=1&qlt=90&o=4&pid=1.1", "http://tse4.mm.bing.net/th?id=OIP.Mc525a3687ccd072a8d84057cb6922e4fo0&w=210&h=131&c=7&rs=1&qlt=90&o=4&pid=1.1"]
        galleryView.imageModelArray = imageArray
        galleryView.setTop(0)
		
		// Setup 2: title Info View.
		let titleLabel = getTitleLabelView(dataModel?.name ?? "", desctiption: "", showRight: false)
		addNewSubView(titleLabel, preView: galleryView)
		titleLabel.backgroundColor = UIColor(hexString: "#000000", alpha: 0.3)
		
		let desLabel = AILabel()
		desLabel.text = dataModel?.desc ?? ""
		desLabel.setHeight((desLabel.text ?? "").sizeWithFont(UIFont.systemFontOfSize(14), forWidth: self.view.width).height + 15)
		desLabel.numberOfLines = 0
		desLabel.lineBreakMode = .ByCharWrapping
		desLabel.font = UIFont.systemFontOfSize(42 / 3)
		desLabel.textColor = UIColor(hexString: "#b4b4ca", alpha: 0.7)
		addNewSubView(desLabel, preView: titleLabel)
		
		let priceLabel = AILabel()
		//priceLabel.text = "\(dataModel?.price?.price_show ?? "")"
		priceLabel.setHeight(112 / 3)
		priceLabel.font = AITools.myriadBoldWithSize(52 / 3)
		priceLabel.textColor = UIColor(hexString: "#e7c400")
		addNewSubView(priceLabel, preView: desLabel)
        priceLabel.addBottomWholeSSBorderLineLeftMapping(AIApplication.AIColor.AIVIEWLINEColor, leftMapping: 40 / 3)
		cachePriceLabel = priceLabel
		let tagsView = UIView()
		tagsView.setHeight(165 / 3)
        let countPackage = dataModel?.package?.count ?? 0
        var index = 0
        dataModel?.package?.forEach({ (model) in
            // add tag view.
            let tag = DesignableButton()
            tag.borderColor = UIColor.whiteColor()
            tag.borderWidth = 0.5
            tag.cornerRadius = 14
            tagsView.addSubview(tag)
            tag.titleLabel?.textColor = UIColor.whiteColor()
            tag.titleLabel?.font = UIFont.systemFontOfSize(13)
            let len = model.name?.length ?? 1
            let widthButton: CGFloat = CGFloat(len * 9) + 35
            tag.frame = CGRectMake(CGFloat(index) * (widthButton + 10), 14, widthButton, 80 / 3)
            tag.layer.masksToBounds = true
            tag.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            if model.collected {
                tag.associatedName = "1"
                tag.setBackgroundImage(UIColor(hexString: "#0f86e8").imageWithColor(), forState: UIControlState.Normal)
                tag.borderColor = UIColor(hexString: "#0f86e8")
                singleButton = tag
                cachePriceLabel?.text = "\(model.price?.price_show ?? "")"
            } else {
                tag.associatedName = "0"
                changeButtonNormalState(tag)
            }
            
            if let arr = dataModel?.package {
                let modelp: AIProductInfoPackageModel = arr[index]
                tag.setTitle(modelp.name, forState: UIControlState.Normal)
                tag.tag = modelp.pid ?? 0
                tag.addTarget(self, action: #selector(AIProductInfoViewController.changeButtonState(_:)), forControlEvents: UIControlEvents.TouchDown)
                index = index + 1
            }
        })
        
		
		tagsView.setLeft(10)
		
		// Add Free Custom Make View Button.
		func addFreeButton() {
			// add tag view.
			let tag = DesignableButton()
			tag.borderColor = UIColor.whiteColor()
			tag.borderWidth = 0.5
			tag.cornerRadius = 14
			tagsView.addSubview(tag)
			tag.titleLabel?.textColor = UIColor.whiteColor()
			tag.titleLabel?.font = UIFont.systemFontOfSize(13)
			let width: CGFloat = 283 / 3
			tag.frame = CGRectMake(self.view.width - width - 14 - 10, 14, width, 80 / 3)
			
			tag.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
			
			tag.setTitle("自由定制", forState: UIControlState.Normal)
            tag.addTarget(self, action: #selector(AIProductInfoViewController.showDiyCustomView(_:)), forControlEvents: UIControlEvents.TouchDown)
			tag.setBackgroundImage(UIColor(hexString: "#0f86e8").imageWithColor(), forState: UIControlState.Highlighted)
			tag.layer.masksToBounds = true
			let lineView = UIView()
			lineView.backgroundColor = UIColor(hexString: AIApplication.AIColor.AIVIEWLINEColor, alpha: 0.3)
			tagsView.addSubview(lineView)
			
			lineView.frame = CGRectMake(tag.left - 72 / 3, (44) / 6, 0.5, 108 / 3)
		}
		
		addFreeButton()
		
		addNewSubView(tagsView, preView: priceLabel)
		
		let lineView1 = addSplitView()
		
		// 评论数据 
      
        // Setup 3:
        let commond = getTitleLabelView("商品评价", desctiption: "")
        addNewSubView(commond, preView: lineView1)
        commond.backgroundColor = UIColor(hexString: "#000000", alpha: 0.3)
        commond.userInteractionEnabled = true
        commond.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AIProductInfoViewController.showCommentView)))         
        if let commentModel = dataModel?.commentLast {
            let content = commentModel.descripation ?? ""
            let hcom = content.sizeWithFont(UIFont.systemFontOfSize(14), forWidth: UIScreen.mainScreen().bounds.width).height
            var commentView = AICommentInfoView.initFromNib() as? AICommentInfoView
            commentView = AICommentInfoView.initFromNib() as? AICommentInfoView
            addNewSubView(commentView!, preView: commond)
            commentView?.initSubviews()
            commentView?.setWidth(UIScreen.mainScreen().bounds.width)
            commentView?.fillDataWithModel(commentModel)
            commentView?.setHeight((commentView?.getheight() ?? 0) + hcom - 20)
            commentView?.bgView.hidden = true
            // Add Normal Answer Button
            commentView?.addBottomWholeSSBorderLineLeftMapping(AIApplication.AIColor.AIVIEWLINEColor, leftMapping: 40 / 3)
        } else {
            tagsView.addBottomWholeSSBorderLineLeftMapping(AIApplication.AIColor.AIVIEWLINEColor, leftMapping: 40 / 3)
        }
        
		let answerView = UIView()
		addNewSubView(answerView, preView: preCacheView!)
		answerView.setHeight(245 / 3)
		
		let aButton = DesignableButton()
		answerView.addSubview(aButton)
		
		aButton.borderColor = UIColor(hexString: "#FFFFFF", alpha: 0.3)
		aButton.borderWidth = 1
		aButton.cornerRadius = 5
		aButton.titleLabel?.font = UIFont.systemFontOfSize(48 / 3)
		aButton.setTitle("常见问题", forState: UIControlState.Normal)
		aButton.setWidth(self.view.width / 1.6)
		aButton.setHeight(126 / 3)
		aButton.setTop(42 / 3)
		aButton.setCenterX(self.view.width / 2)
		aButton.layer.masksToBounds = true
		aButton.setBackgroundImage(UIColor(hexString: "#0f86e8").imageWithColor(), forState: UIControlState.Highlighted)
		aButton.addTarget(self, action: #selector(AIProductInfoViewController.qaButtonPressed), forControlEvents: .TouchUpInside)
		
		let lineView2 = addSplitView()
		
		// Setup 4:
        let pLabel44 = getTitleLabelView("为您推荐")
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(AIProductInfoViewController.recommondForYouPressed))
        pLabel44.addGestureRecognizer(tap4)
        addNewSubView(pLabel44, preView: lineView2)
        pLabel44.backgroundColor = UIColor(hexString: "#000000", alpha: 0.3)
        
        let bubbleViewContain = UIView()
        bubbleViewContain.setHeight(0)
        if let remodel = dataModel?.recommendation {
            
            let deepColor = ["ca9e82", "936d4c", "aa6e28", "574d71", "7e3d60", "438091", "ad2063", "5f257d", "162c18", "B10000", "4a5679", "6b4a1d", "1b1a3a", "aa6e28", "6a8e5c", "", "", "", ""]
            let undertoneColor = ["5198ac", "ae9277", "cdaf13", "696a9a", "c3746a", "6c929f", "cf4e5a", "9c417c", "32542c", "F25A68", "7e6479", "aa822a", "81476a", "cdaf13", "93a44b", "", "", "", ""]
            let borderColor = ["9bd6f2", "f8b989", "fee34a", "8986c2", "f88d8e", "6db8d5", "ef6d83", "cd53e1", "528319", "F25A68", "8986c2", "e6ad44", "c474ac", "fee34a", "93bd78", "", "", "", ""]
            
            if remodel.count > 0 {
                var i = 0
                remodel.forEach({ (modelJSON) in
                    let model: AIBuyerBubbleModel! = AIBuyerBubbleModel()
                    model.proposal_name = modelJSON.name ?? ""
                    model.proposal_id = modelJSON.rid ?? 0
                    model.proposal_price = modelJSON.price?.price_show ?? ""
                    
                    let newi = i % 16
                    model.deepColor = deepColor[newi]
                    model.undertoneColor = undertoneColor[newi]
                    model.borderColor = borderColor[newi]
                    
                    let marginLeft = AITools.displaySizeFrom1242DesignSize(34)
                    let space = AITools.displaySizeFrom1242DesignSize(15)
                    let bubbleWidth = (screenWidth - marginLeft * 2 - space * 3) / 4
                    model.bubbleSize = Int(bubbleWidth)/2
                    let bubbleView = AIBubble(center: .zero, model: model, type: Int(typeToNormal.rawValue), index: 0)
                    bubbleViewContain.addSubview(bubbleView)
                    bubbleView.tag = i
                    let bubbleY = AITools.displaySizeFrom1242DesignSize(87)
                    bubbleView.frame = CGRect(x: marginLeft + CGFloat(i) * (bubbleWidth + space), y: bubbleY, width: bubbleWidth, height: bubbleWidth)
                    i = i + 1
                })
                bubbleViewContain.setHeight(125)
            }
        }
        
        addNewSubView(bubbleViewContain, preView: pLabel44)
        
        // Setup 5:
        let pLabel = getTitleLabelView("服务者介绍")
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(AIProductInfoViewController.providerDetailPressed))
        pLabel.addGestureRecognizer(tap5)
        addNewSubView(pLabel, preView: bubbleViewContain, color: UIColor.clearColor(), space: 21)
        pLabel.backgroundColor = UIColor(hexString: "#000000", alpha: 0.3)
        let hView4 = AIServerProviderView.initFromNib() as? AIServerProviderView
        addNewSubView(hView4!, preView: pLabel)
        hView4?.fillDataWithModel(dataModel?.provider)
        let lineView3 = addSplitView()
        
        // Setup 6:
        let pcLabel = getTitleLabelView("商品介绍", desctiption: "", showRight: false)
        addNewSubView(pcLabel, preView: lineView3)
        pcLabel.backgroundColor = UIColor(hexString: "#000000", alpha: 0.3)
        
        /*
         let holdSpaceView = UIView()
         addNewSubView(holdSpaceView, preView: pcLabel)
         holdSpaceView.setHeight(44/3)
        */
        let bottomImage = AIImageView()
        //var imageHeight: CGFloat = 0
        bottomImage.sd_setImageWithURL(NSURL(string:dataModel?.desc_image ?? ""))
        if (dataModel?.name ?? "") == "孕检陪护" {
            bottomImage.setHeight(1652)
        } else if (dataModel?.name ?? "") == "孕检无忧" {
            bottomImage.setHeight(3000)
        }
        
        bottomImage.backgroundColor = UIColor(hexString: "#6AB92E", alpha: 0.7)
        bottomImage.contentMode = UIViewContentMode.ScaleAspectFill
        bottomImage.clipsToBounds = true
        self.addNewSubView(bottomImage, preView: pcLabel)
        
        // Setup 7: Provider Info
        
        let provideView = addCustomView(bottomImage)
        
        // Setup 8: Audio
        let audioView = AICustomAudioNotesView.currentView()
        addNewSubView(audioView, preView: provideView!)
        audioView.delegateShowAudio = self
       
        // Setup 9: Audio And Text Data
        addNoteList()
        
        // Setup 10: add bottom view but don't cache this view.
        if let bottomView = AIProductinfoBottomView.initFromNib() {
            addNewSubView(bottomView, preView: preCacheView!)
            bottomViewCache = bottomView
            (bottomView as? AIProductinfoBottomView)?.bottomButton.addGestureRecognizer(tapGes)
        }
    }
    
    func addNoteList() {
        // 处理语音 文本数据
        // 处理数据填充
        if let wish = cacheNote {
            if let hopeList = wish.hope_list as? [AIProposalServiceDetailHopeModel] {
                var perViews: UIView?
                for item in hopeList {
                    if item == hopeList.first {
                        perViews = preCacheView
                    }
                    
                    if item.type == "Text" {
                        // text.
                        let newText = AITextMessageView.currentView()
                        newText.content.text = item.text ?? ""
                        let newSize = item.text?.sizeWithFont(AITools.myriadLightSemiCondensedWithSize(36 / 2.5), forWidth: self.view.width - 50)
                        newText.setHeight(30 + newSize!.height)
                        newText.wishID = wish.wish_id
                        newText.noteID = item.hope_id
                        addNewSubView(newText, preView: perViews!)
                        newText.delegate = self
                        perViews = newText
                        newText.backgroundColor = UIColor(hex: redColor)
                        
                    } else if item.type == "Voice" {
                        // audio.
                        let audio1 = AIAudioMessageView.currentView()
                        audio1.audioDelegate = self
                        audio1.deleteDelegate = self
                        addNewSubView(audio1, preView: perViews!)
                        audio1.wishID = wish.wish_id
                        audio1.noteID = item.hope_id
                        audio1.fillData(item)
                        audio1.loadingView.hidden = true
                        audio1.backgroundColor = UIColor(hex: redColor)
                        perViews = audio1
                    }
                }
                if let s = perViews {
                    self.preCacheView = s
                }
                
            }
        }//end
    }
    
    func showCommentView() {
        let vc = AIProductCommentsViewController()
        vc.service_id = sid
        let nav = UINavigationController(rootViewController: vc)
        presentBlurViewController(nav, animated: true, completion: nil)
    
    }
    
    @IBAction func targetProInfoAction(any: AnyObject) {
        showTransitionStyleCrossDissolveView(AIProductProviderViewControler.initFromNib())
    }
    
    // 刷新数据结构
    func referCustomDataStuct (notify: NSNotification) {
        if let model = customNoteModelCache {
            if let dict = notify.userInfo {
                let label_id = dict["label_id"] as? Int ?? 0
                let newState = dict["newState"] as? Int ?? 0
                // update cache
                var newModel = AIProductInfoTagListModel()
                var newArray = model.tag_list?.filter({ (childModel) -> Bool in
                    if let cid = childModel.instance_id {
                        if cid == label_id {
                            //处理状态
                            newModel = childModel                            
                            newModel.is_chosen = newState
                            return false
                        }
                    }
                    return true
                })
                newArray?.append(newModel)
                customNoteModelCache?.tag_list = newArray
            }
        }
    }
    
    private func addCustomView(preView: UIView) -> UIView? {
        
        var viw: UIView = preView
        
        if let customNot = dataModel?.customer_note {
            
            let wish = AIProposalServiceDetail_WishModel()
            wish.wish_id = customNot.wish_id ?? 0
            wish.intro = customNot.wish_name ?? ""
            var array1 = Array<AIProposalServiceDetailLabelModel>()
            var array2 = Array<AIProposalServiceDetailHopeModel>()
            if let taglist = customNot.tag_list {
                taglist.forEach({ (model) in
                    let labelModel_1 = AIProposalServiceDetailLabelModel()
                    labelModel_1.content = model.name ?? ""
                    labelModel_1.label_id = model.instance_id ?? 0
                    labelModel_1.selected_flag = model.is_chosen ?? 0
                    labelModel_1.selected_num = model.chosen_times ?? 0
                    array1.append(labelModel_1)
                })
            }
            
            if let notelist = customNot.note_list {
                notelist.forEach({ (model) in
                    let m = AIProposalServiceDetailHopeModel()
                    m.hope_id = model.nid ?? 0
                    m.text = model.content ?? ""
                    m.type = model.type ?? ""
                    m.audio_url = model.content ?? ""
                    m.time = model.create_time?.toInt() ?? 0
                    array2.append(m)
                })
            }
            
            wish.label_list = array1
            wish.hope_list = array2
            cacheNote = wish
            let providerView = AIProviderView.currentView()
            addNewSubView(providerView, preView: viw)
            viw = providerView
            providerView.title.text = customNot.wish_name ?? ""
            providerView.content.text = customNot.wish_desc ?? ""
            if wish.label_list != nil || (wish.hope_list != nil) {
                if wish.hope_list.count > 0 || wish.label_list.count > 0 {
                    let custView = AICustomView.currentView()
                    let heisss = 200 + wish.label_list.count * 16
                    custView.setHeight(CGFloat(heisss))
                    addNewSubView(custView, preView: viw)
                    viw = custView
                    custView.wish_id = wish.wish_id
                    if let labelList = wish.label_list as? [AIProposalServiceDetailLabelModel] {
                        custView.fillTags(labelList, isNormal: true)
                    }
                }
            }
            
        }
        if view == preView {
            return nil
        }
        return viw
    }
    
    /**
     copy from old View Controller. not have cache view
     */
    func addNewNoCacheSubView(cview: UIView, preView: UIView, color: UIColor = UIColor.clearColor(), space: CGFloat = 0) {
        scrollview.addSubview(cview)
        cview.setWidth(self.view.width)
        cview.setTop(preView.top + preView.height+space)
        cview.backgroundColor = color
        scrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), cview.top + cview.height)
    }
    
    /**
     copy from old View Controller.
     */
    func addNewSubView(cview: UIView, preView: UIView, color: UIColor = UIColor.clearColor(), space: CGFloat = 0) {
        scrollview.addSubview(cview)
        cview.setWidth(self.view.width)
        cview.setTop(preView.top + preView.height+space)
        cview.backgroundColor = color
        scrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), cview.top + cview.height)
        preCacheView = cview
    }

    // Make Add Split View.
    func addSplitView() -> UIView {
        let splitView = UIView()
        splitView.setHeight(0)
        if let preCacheView = preCacheView {
            addNewSubView(splitView, preView: preCacheView)
            splitView.backgroundColor = UIColor(hexString: "#372D49", alpha: 0.8)
        }
        return splitView
    }
    
    // MARK: - Change state
    func changeButtonState(sender: AnyObject) {
        if let button = sender as? DesignableButton {
            if let sib = singleButton {
                if sib == button {
                    //点击相同的按钮
                    // GO
                } else {
                    //点击不同的按钮
                    // return
                    changeButtonNormalState(singleButton!)
                    singleButton = button
                }
            }
            
            
            if let tagCon = button.associatedName?.toInt() {
                if tagCon == 1 {
                    button.associatedName = "0"
                    changeButtonNormalState(button)
                } else {
                    button.associatedName = "1"
                    button.setBackgroundImage(UIColor(hexString: "#0f86e8").imageWithColor(), forState: UIControlState.Normal)
                    button.borderColor = UIColor(hexString: "#0f86e8")
                    
                    let tagPID = button.tag
                    dataModel?.package?.forEach({ (modelPackage) in
                        if let pid = modelPackage.pid {
                            if pid == tagPID {
                                //刷新价格
                                cachePriceLabel?.text = "\(modelPackage.price?.price_show ?? "")"
                                selectedPID =  modelPackage.pid ?? 0
                            }
                        }
                    })
                }
                
            }
            
        }
    }
    
    func changeButtonNormalState(sender: AnyObject) {
        if let button = sender as? DesignableButton {
            button.setBackgroundImage(nil, forState: UIControlState.Normal)
            button.borderColor = UIColor.whiteColor()
            button.associatedName = "0"
        }
    }
    
    // MARK: - DIY ACTION
    func showDiyCustomView(sender: AnyObject) {
        let model = AIBuyerBubbleModel()
        if proposal_id <= 0 {
            model.proposal_id = dataModel?.proposal_inst_id ?? 0
        } else {
            model.proposal_id = proposal_id
        }
        model.proposal_name = dataModel?.name ?? ""
        let viewsss = createBuyerDetailViewController(model)
        viewsss.customNoteModel = dataModel?.customer_note
        showTransitionStyleCrossDissolveView(viewsss)
    }
    
    func showDetailView(sender: AnyObject) {
        let model = AIBuyerBubbleModel()
        model.proposal_id = dataModel?.proposal_inst_id ?? 0
        model.proposal_name = dataModel?.name ?? ""
        let viewsss = createBuyerDetailViewController(model)
        viewsss.customNoteModel = dataModel?.customer_note
        showTransitionStyleCrossDissolveView(viewsss)
    }
    
    func createBuyerDetailViewController(model: AIBuyerBubbleModel) -> AIBuyerDetailViewController {
        
        let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIBuyerStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIBuyerDetailViewController) as! AIBuyerDetailViewController
        viewController.bubbleModel = model
        viewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        viewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        
        return viewController
    }
    

    //跳转订单确认界面
    func configOrderAction() {
        
        let model = AIProposalInstModel()
        model.proposal_id = dataModel?.proposal_inst_id ?? 0
        model.proposal_name = dataModel?.name ?? ""
        //pakcage id in selectedPID.
        if let vc = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIBuyerStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIConfirmOrderViewController) as? AIConfirmOrderViewController {
            vc.dataSource  = model
            //cache 部分tags
            vc.customNoteModel = customNoteModelCache//dataModel?.customer_note
            showTransitionStyleCrossDissolveView(vc)
        }
    }
   
    // MARK: - Action Event Touch Up Inside
    @IBAction func showOrderAction(sender: AnyObject) {
        configOrderAction()
    }
    
    func providerDetailPressed() {
        let vc = AIProviderDetailViewController.initFromNib()
        vc.provider_id = dataModel!.provider!.provider_id ?? 0
        vc.id = dataModel!.provider!.id ?? 0
        let nav = UINavigationController(rootViewController: vc)
        presentBlurViewController(nav, animated: true, completion: nil)
    }
    
    func recommondForYouPressed() {
        // 为您推荐
        let vc = AIRecommondForYouViewController()
        vc.service_id = sid
        let nav = UINavigationController(rootViewController: vc)
        presentBlurViewController(nav, animated: true, completion: nil)
    }
    
	func qaButtonPressed() {
        let vc = AIProductQAViewController()
        vc.service_id = sid

        let nav = UINavigationController(rootViewController: vc)
        presentBlurViewController(nav, animated: true, completion: nil)
//        presentViewController(nav, animated: true, completion: nil)
	}
    
    /**
     Back to top position.
     */
    func topAction() {
        scrollview.scrollsToTop = true
        scrollview.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    /**
     Target to Edit ViewController.
     */
    func editAction() {
        scrollview.setContentOffset(CGPointMake(0, scrollview.contentSize.height - scrollview.height), animated: true)
    }
	 
}

// MARK: - Extension 

extension AIProductInfoViewController: AICustomAudioNotesViewShowAudioDelegate {
    
    // show audio view...
    func showAudioView(type: Int) {
        // type 0 : audio  1: text
        let childView = AIAudioInputView.currentView()
        childView.alpha = 0
        self.view.addSubview(childView)
        
        childView.delegateAudio = self
        childView.textInput.delegate = self
        childView.inputTextView.delegate = self
        curTextField = childView.textInput
//        childView.textInput.inputAccessoryView = childView.audioInputBarView
        currentAudioView = childView
        
        constrain(childView) { (cview) -> () in
            cview.leading == cview.superview!.leading
            cview.trailing == cview.superview!.trailing
            cview.top == cview.superview!.top
            cview.bottom == cview.superview!.bottom
        }
        SpringAnimation.spring(0.5) { () -> Void in
            childView.inputTextView.text = self.inputMessageCache
            childView.alpha = 1
        }
        
        if type == 1 {
            childView.changeModel(1)
        } else {
            childView.changeModel(0)
        }
        
    }
}

//MARK: ShareDelegate
extension AIProductInfoViewController: UMSocialUIDelegate {

    func didFinishGetUMSocialDataInViewController(response: UMSocialResponseEntity!) {
        if response.responseCode == UMSResponseCodeSuccess {
            AILog("share to sns name is" + "\(response.data.keys.first)")
        }
    }
}

extension AIProductInfoViewController: UITextFieldDelegate, UIScrollViewDelegate {
    
    // MARK: ScrollDelegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if curTextField != nil {
            shouldHideKeyboard()
        }
        SpringAnimation.spring(0.3) {
            //设置透明度
            self.topButton.alpha = 0.5
            self.editButton.alpha = 0.5
        }
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        SpringAnimation.spring(0.3) {
            //设置透明度
            self.topButton.alpha = 0.5
            self.editButton.alpha = 0.5
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        SpringAnimation.spring(0.3) {
            //设置透明度
            self.topButton.alpha = 1.0
            self.editButton.alpha = 1.0
        }
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //设置透明度
        SpringAnimation.spring(0.3) {
            self.topButton.alpha = 1.0
            self.editButton.alpha = 1.0
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        curTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        // scrollView.userInteractionEnabled = false
        return serviceContentType != .None
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return textField.text?.length < 198
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // add a new View Model
        let newText = AITextMessageView.currentView()
        if let cview = preCacheView {
            newText.content.text = textField.text
            let newSize = textField.text?.sizeWithFont(AITools.myriadLightSemiCondensedWithSize(36 / 2.5), forWidth: self.view.width - 50)
            newText.setHeight(30 + newSize!.height)
            addNewSubView(newText, preView: cview)
            scrollViewBottom()
            newText.delegate = self
            refereshBottomView(newText)
            if let c = currentAudioView {
                c.closeThisView()
            }
        }
        textField.resignFirstResponder()
        textField.text = ""
        
        return true
    }
    
    /*
     刷新位置信息
     */
    func refereshBottomView(prview: UIView) {
        preCacheView = self.bottomViewCache
        prview.setTop(self.scrollview.contentSize.height-prview.height-(self.bottomViewCache?.height)!)
        self.bottomViewCache?.setTop((self.bottomViewCache?.top)! + prview.height)
    }
}

extension AIProductInfoViewController: AICustomAudioNotesViewDelegate, AIAudioMessageViewDelegate {
    
    // AIAudioMessageViewDelegate
    func willPlayRecording(audioView: AIAudioMessageView) {
        curAudioView?.stopPlay()
        curAudioView = audioView
    }
    
    func didEndPlayRecording(audioView: AIAudioMessageView) {
        curAudioView = nil
    }
    
    /**
     开始录音处理
     */
    func willStartRecording() {
        audioView_AudioRecordView?.hidden = false
    }
    
    // 更新Meters 图片处理
    func updateMetersImage(lowPass: Double) {
        var imageName: String = "RecordingSignal001"
        if lowPass >= 0.8 {
            imageName = "RecordingSignal008"
        } else if lowPass >= 0.7 {
            imageName = "RecordingSignal007"
        } else if lowPass >= 0.6 {
            imageName = "RecordingSignal006"
        } else if lowPass >= 0.5 {
            imageName = "RecordingSignal005"
        } else if lowPass >= 0.4 {
            imageName = "RecordingSignal004"
        } else if lowPass >= 0.3 {
            imageName = "RecordingSignal003"
        } else if lowPass >= 0.2 {
            imageName = "RecordingSignal002"
        } else if lowPass >= 0.1 {
            imageName = "RecordingSignal001"
        } else {
            imageName = "RecordingSignal001"
        }
        
        audioView_AudioRecordView?.passImageView.image = UIImage(named: imageName)
    }
    
    // 结束录音添加view到scrollview
    func endRecording(audioModel: AIProposalServiceDetailHopeModel) {
        
        audioView_AudioRecordView?.hidden = true
        if audioModel.time > 1000 {
            // add a new View Model
            let audio1 = AIAudioMessageView.currentView()
            audio1.audioDelegate = self
            addNewSubView(audio1, preView: preCacheView!)
            audio1.fillData(audioModel)
            audio1.deleteDelegate = self
            scrollViewBottom()
            audio1.backgroundColor = UIColor(hex: redColor)
            audio1.loadingView.startAnimating()
            audio1.loadingView.hidden = false
            refereshBottomView(audio1)
            
            let att: [AIAnalyticsKeys: AnyObject] = [
                .OfferingId: dataModel?.proposal_inst_id ?? "",
                .URL: audioModel.audio_url ?? ""
            ]
            AIAnalytics.event(.LeaveMessage, attributes: att)
            // upload
            let wishid = self.dataModel?.customer_note?.wish_id ?? 0
            let message = AIMessageWrapper.addWishNoteWithWishID(wishid, type: "Voice", content: audioModel.audio_url, duration: audioModel.time)
            message.url = AIApplication.AIApplicationServerURL.addWishListNote.description
            audio1.messageCache = message
            weak var weakSelf = self
            AIRemoteRequestQueue().asyncRequset(audio1, message: message, successRequst: { (subView, response) -> Void in
                if let eView = subView as? AIAudioMessageView {
                    
                    eView.loadingView.stopAnimating()
                    eView.loadingView.hidden = true
                    eView.errorButton.hidden = true
                    
                    let NoteId = response["NoteId"] as? NSNumber
                    eView.noteID = NoteId?.integerValue ?? 0
                }
                
                weakSelf!.view.dismissLoading()
                
                }, fail: { (errorView, error) -> Void in
                    if let eView = errorView as? AIAudioMessageView {
                        eView.loadingView.stopAnimating()
                        eView.loadingView.hidden = true
                        eView.errorButton.hidden = false
                    }
                    
                    weakSelf!.view.dismissLoading()
                    AIAlertView().showInfo("AIErrorRetryView.NetError".localized, subTitle: "AIAudioMessageView.info".localized, closeButtonTitle: "AIAudioMessageView.close".localized, duration: 3)
            })
            
        } else {
            AIAlertView().showInfo("AIServiceContentViewController.record".localized, subTitle: "AIAudioMessageView.info".localized, closeButtonTitle: "AIAudioMessageView.close".localized, duration: 3)
        }
        
        if let c = currentAudioView {
            c.closeThisView()
        }
    }
    
    // 即将结束录音
    func willEndRecording() {
        
    }
    
    func cacheMessage(message: String?) {
        if let meg = message {
            self.inputMessageCache = meg
        }
    }
    
    // 录音发生错误
    func endRecordingWithError(error: String) {
        
    }
    
    func scrollViewBottom() {
        let bottomPoint = CGPointMake(0, self.scrollview.contentSize.height - self.scrollview.bounds.size.height)
        self.scrollview.setContentOffset(bottomPoint, animated: true)
    }
    
}

extension AIProductInfoViewController: AIDeleteActionDelegate {
    
    func retrySendRequestAction(cell: UIView?) {
        if let audio1 = cell as? AIAudioMessageView {
            if let m = audio1.messageCache {
                AIRemoteRequestQueue().asyncRequset(audio1, message: m, successRequst: { (subView, response) -> Void in
                    if let eView = subView as? AIAudioMessageView {
                        eView.loadingView.stopAnimating()
                        eView.loadingView.hidden = true
                        eView.errorButton.hidden = true
                        
                        let NoteId = response["NoteId"] as? NSNumber
                        eView.noteID = NoteId?.integerValue ?? 0
                    }
                    
                    }, fail: { (errorView, error) -> Void in
                        if let eView = errorView as? AIAudioMessageView {
                            eView.loadingView.stopAnimating()
                            eView.loadingView.hidden = true
                            eView.errorButton.hidden = false
                        }
                })
            }
            
        }
        
    }
    
    func deleteAnimation (cell: UIView?) {
        SpringAnimation.springWithCompletion(0.3, animations: { () -> Void in
            
            cell?.alpha = 0
            // 刷新UI
            let height = cell?.height ?? 0
            AILog("delete view: \(height)")
            let top = cell?.top
            
            let newListSubViews = self.scrollview.subviews.filter({ (subview) -> Bool in
                return subview.top > top
            })
            
            for nsubView in newListSubViews {
                nsubView.setTop(nsubView.top - height)
            }
            
            var contentSizeOld = self.scrollview.contentSize
            AILog(contentSizeOld.height)
            contentSizeOld.height -= height
            self.scrollview.contentSize = contentSizeOld
            
        }) { (complate) -> Void in
            cell?.removeFromSuperview()
        }
        
    }
    
    func deleteAction(cell: UIView?) {
        
        let noteView = cell as? AIWishMessageView
        view.userInteractionEnabled = false
        view.showLoading()
        let message = AIMessageWrapper.deleteWishNoteWithWishID((noteView?.wishID)!, noteID: (noteView?.noteID)!)
        message.url = AIApplication.AIApplicationServerURL.delWishListNote.description
        
        weak var weakSelf = self
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            AILog(response)
            weakSelf!.deleteAnimation(cell)
            weakSelf!.view.hideLoading()
            weakSelf!.view.userInteractionEnabled = true
            }, fail: { (errorType: AINetError, errorStr: String!) -> Void in
                weakSelf!.view.hideLoading()
                weakSelf!.view.userInteractionEnabled = true
                AIAlertView().showInfo("AIAudioMessageView.info".localized, subTitle: "AIServiceContentViewController.wishDeleteError".localized, closeButtonTitle: "AIAudioMessageView.close".localized, duration: 3)
                
        })
        
    }
}


extension AIProductInfoViewController: UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        if textView.text.length > 160 {
            let str = NSString(string: textView.text)
            let newStr = str.substringToIndex(160)
            textView.text = newStr
        }
        
        if let s = currentAudioView {
            
            if textView.contentSize.height < 100 {
                s.inputHeightConstraint.constant = 5 + textView.contentSize.height
            } else {
                s.inputHeightConstraint.constant = 5 + 97
            }
            textView.scrollRangeToVisible(NSRange(location: 0, length: 0))
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if "\n" == text {
            textView.resignFirstResponder()
            self.inputMessageCache = "" // 清空
            // add a new View Model
            let newText = AITextMessageView.currentView()
            newText.content.text = textView.text
            let newSize = textView.text?.sizeWithFont(AITools.myriadLightSemiCondensedWithSize(36 / 2.5), forWidth: self.view.width - 50)
            newText.setHeight(25 + newSize!.height) // 30
            
            // AddNewSubView(newText, preView: cview)
            addNewSubView(newText, preView: preCacheView!)
            newText.backgroundColor = UIColor(hex: redColor)
            scrollViewBottom()
            refereshBottomView(newText)
            newText.delegate = self
            
            if let c = currentAudioView {
                c.closeThisView()
            }
            
            // This is a big boss.
            let att: [AIAnalyticsKeys: AnyObject] = [
                .OfferingId: dataModel?.proposal_inst_id ?? "",
                .Text: newText.content.text ?? "",
            ]
            AIAnalytics.event(.LeaveMessage, attributes: att)
            
            // Add
            self.view.userInteractionEnabled = false
            view.showLoading()
            weak var weakSelf = self
            let wishID = self.dataModel?.customer_note?.wish_id ?? 0
            let message = AIMessageWrapper.addWishNoteWithWishID(wishID, type: "Text", content: newText.content.text, duration: 0)
            message.url = AIApplication.AIApplicationServerURL.addWishListNote.description
            newText.wishID = wishID
            AIRemoteRequestQueue().asyncRequset(newText, message: message, successRequst: { (subView, response) -> Void in
                if let eView = subView as? AITextMessageView {
                    weakSelf!.view.hideLoading()
                    let NoteId = response["NoteId"] as? String ?? "0"
                    eView.noteID = Int(NoteId) ?? 0
                }
                weakSelf!.view.userInteractionEnabled = true
                
                }, fail: { (errorView, error) -> Void in
                    weakSelf!.view.hideLoading()
                    AIAlertView().showInfo("AIErrorRetryView.NetError".localized, subTitle: "AIAudioMessageView.info".localized, closeButtonTitle: "AIAudioMessageView.close".localized, duration: 3)
                    weakSelf!.view.userInteractionEnabled = true
            })
            return false
        }
        
        return true
    }
    
    func serviceParamsViewHeightChanged(notification: NSNotification) {
        if let obj = notification.object as? Dictionary<String, AnyObject> {
            let view = obj["view"] as! UIView
            if let _ = scrollview.subviews.indexOf(view) {
                let offset = obj["offset"] as! CGFloat
                moveViewsBelow(view, offset: offset)
            }
        }
    }
    
    func moveViewsBelow(view: UIView, offset: CGFloat) {
        let validateViews = scrollViewSubviews
        let anchor = validateViews.indexOf(view)! + 1
        
        // move
        
        for index: Int in anchor ..< scrollViewSubviews.count {
            let sview: UIView = scrollViewSubviews[index]
            if let v = sview as? AIMusicTherapyView {
                AILog(v)
            }
            var frame = sview.frame
            frame.origin.y += offset
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                sview.frame = frame
            })
            
        }
        
        var s = scrollview.contentSize
        s.height = CGRectGetMaxY(scrollview.subviews.last!.frame)
        scrollview.contentSize = s
    }
    
}
