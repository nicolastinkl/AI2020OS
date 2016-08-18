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

/// 商品详情视图
class AIProductInfoViewController: UIViewController {
	
    // MARK: - Propites
	private let defaultTableViewHeaderMargin: CGFloat = 413.0
    
	private let imageScalingFactor: CGFloat = 413.0
	
	@IBOutlet weak var scrollview: UIScrollView!
	
	private var preCacheView: UIView?
	
	private var navi = AINavigationBar.initFromNib()
	
	private let topImage = AIImageView()
    
    private var dataModel: AIProdcutinfoModel?
	
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
		
		// Make UIScrollView.
		Async.main(after: 0.1) {
            self.requestData()			
		}
		
	}
    
    
    func requestData() {
        view.showLoading()
        AIProdcutinfoService.requestServiceInfo("12") { (response, error) in
            self.view.hideLoading()
            if let model = response as? AIProdcutinfoModel{
                self.dataModel = model
                self.initScrollViewData()
            }else{
                AIAlertView().showError("获取数据失败", subTitle: "")
            }
        }
    }
    
    /**
     定制按钮和Top按钮
     */
    func configButtons() {
        
        let topButton = UIButton()
        view.addSubview(topButton)
        
        let editButton = UIButton()
        view.addSubview(editButton)
        
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
		//animateImageView(scrollOffset, draggingPoint: scrollViewDragPoint, alpha: 1.0)
		
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
		
        self.scrollview.contentInset = UIEdgeInsetsMake(0, 0, 200, 0)
		/// Title.
		if let navi = navi as? AINavigationBar {
			view.addSubview(navi)
			navi.holderViewController = self
			constrain(navi, block: { (layout) in
				layout.left == layout.superview!.left
				layout.top == layout.superview!.top
				layout.right == layout.superview!.right
				layout.height == 44.0 + 10.0
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
        view.showLoading()
        
        
        AIProdcutinfoService.addFavoriteServiceInfo("11") { (obj, error) in
            self.view.hideLoading()
            if let res = obj as? String {
                // MARK: Loading Data Views
                if res == "1" {
                    if let navi = self.navi as? AINavigationBar {
                        navi.setRightIcon1Action(UIImage(named: "AINavigationBar_faviator")!)
                    }
                } else {
                    AIAlertView().showError("收藏失败", subTitle: "")
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

   // MARK: - Init ScrollData
	func initScrollViewData() {
        
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
			titleLabel.frame = CGRectMake(0, 0, 140, heightLabel)
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
		topImage.setImgURL(NSURL(string: dataModel?.image ?? ""), placeholderImage: smallPlace())
		topImage.setHeight(imageScalingFactor)
		topImage.contentMode = UIViewContentMode.ScaleAspectFill
		addNewSubView(topImage, preView: UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)))
		
		// Setup 2: title Info View.
		let titleLabel = getTitleLabelView(dataModel?.name ?? "", desctiption: "", showRight: false)
		addNewSubView(titleLabel, preView: topImage)
		titleLabel.backgroundColor = UIColor(hexString: "#000000", alpha: 0.3)
		
		let desLabel = AILabel()
		desLabel.text = dataModel?.desc ?? ""
		desLabel.setHeight(60)
		desLabel.numberOfLines = 0
		desLabel.lineBreakMode = .ByCharWrapping
		desLabel.font = UIFont.systemFontOfSize(42 / 3)
		desLabel.textColor = UIColor(hexString: "#b4b4ca", alpha: 0.7)
		addNewSubView(desLabel, preView: titleLabel)
		
		let priceLabel = AILabel()
		priceLabel.text = "\(dataModel?.price?.price_show ?? "")"
		priceLabel.setHeight(112 / 3)
		priceLabel.font = AITools.myriadBoldWithSize(52 / 3)
		priceLabel.textColor = UIColor(hexString: "#e7c400")
		addNewSubView(priceLabel, preView: desLabel)
		priceLabel.addBottomWholeSSBorderLineLeftMapping(AIApplication.AIColor.AIVIEWLINEColor, leftMapping: 40 / 3)
		
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
            let widthButton: CGFloat = 223 / 3
            tag.frame = CGRectMake(CGFloat(index) * (widthButton + 10), 14, widthButton, 80 / 3)
            tag.layer.masksToBounds = true
            tag.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            tag.setBackgroundImage(UIColor(hexString: "#0f86e8").imageWithColor(), forState: UIControlState.Highlighted)
            if let arr = dataModel?.package {
                let modelp: AIProductInfoPackageModel = arr[index]
                tag.setTitle(modelp.name, forState: UIControlState.Normal)
                tag.tag = modelp.pid ?? 0
                tag.addTarget(self, action: #selector(AIProductInfoViewController.showDetailView(_:)), forControlEvents: UIControlEvents.TouchDown)
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
            tag.addTarget(self, action: #selector(AIProductInfoViewController.showDetailView(_:)), forControlEvents: UIControlEvents.TouchDown)
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
		
		// Setup 3:
		let commond = getTitleLabelView("商品评价", desctiption: "好评率50%")
		addNewSubView(commond, preView: lineView1)
		commond.backgroundColor = UIColor(hexString: "#000000", alpha: 0.3)
		commond.userInteractionEnabled = true
        commond.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AIProductInfoViewController.showCommentView)))
        
        
        var commentModel = AICommentInfoModel()
        commentModel.commentid = 2
        commentModel.descripation = ""
        commentModel.images =  ["http://7q5dv2.com1.z0.glb.clouddn.com/Kelvin%20-%20Bootstrap%203%20Resume%20Theme.png",
                                "http://7q5dv2.com1.z0.glb.clouddn.com/tinkl1.pic.jpg",
                                "http://7q5dv2.com1.z0.glb.clouddn.com/tinkl2D57E5A9-8BCE-4A3E-8C9C-E84C40825D89.png",
                                "http://7q5dv2.com1.z0.glb.clouddn.com/tinkl2H%7BC17WUNL%2503%291%605ANKYL6.jpg",
                                "http://7q5dv2.com1.z0.glb.clouddn.com/tinkl7711C941-BD7C-47A3-97EA-192AD2B63B87.png",
                                "http://7q5dv2.com1.z0.glb.clouddn.com/tinklSamsung-Galaxy-Gear-Smartwatch%20%E5%89%AF%E6%9C%AC.PNG",
                                "http://7q5dv2.com1.z0.glb.clouddn.com/tinklUpload_4.pic.jpg",
                                "http://7q5dv2.com1.z0.glb.clouddn.com/tinklUpload_64ADD30A-2F22-4E39-8FF0-DCE5ADFCC9B9.png",
                                "http://7q5dv2.com1.z0.glb.clouddn.com/tinklUpload_9.pic.jpg",
                                "http://7q5dv2.com1.z0.glb.clouddn.com/tinklUpload_EC78563D-64FF-4F15-B1C5-2495931006C3.png",
                                "http://7q5dv2.com1.z0.glb.clouddn.com/tinklUpload_Placehold@2x.png"]
        commentModel.level = 3
        commentModel.providename = "xxxxxxxxxx"
        commentModel.descripation = "Using automatic tunneling, sends IPv6 packets encapsulated inIPv4 to IPv6 destinations with IPv4-compatible addresses thatare located off-link"
        commentModel.time = 12313
		let commentView = AICommentInfoView.initFromNib() as? AICommentInfoView
		addNewSubView(commentView!, preView: commond)
        commentView?.initSubviews()
        commentView?.setWidth(UIScreen.mainScreen().bounds.width)
		commentView?.fillDataWithModel(commentModel)
		commentView?.setHeight(commentView?.getheight() ?? 0)
        commentView?.bgView.hidden = true
		// Add Normal Answer Button
        commentView?.addBottomWholeSSBorderLineLeftMapping(AIApplication.AIColor.AIVIEWLINEColor, leftMapping: 40 / 3)
		
		let answerView = UIView()
		addNewSubView(answerView, preView: commentView!)
		answerView.setHeight(245 / 3)
		
		let aButton = DesignableButton()
		answerView.addSubview(aButton)
		
		aButton.borderColor = UIColor(hexString: "#FFFFFF", alpha: 0.5)
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
            if remodel.count > 0 {
                var i = 0
                remodel.forEach({ (modelJSON) in
                    let model: AIBuyerBubbleModel! = AIBuyerBubbleModel()
                    model.proposal_name = modelJSON.name ?? ""
                    model.proposal_id = modelJSON.rid ?? 0
                    model.proposal_price = modelJSON.price?.price_show ?? ""
                    let marginLeft = AITools.displaySizeFrom1242DesignSize(34)
                    let space = AITools.displaySizeFrom1242DesignSize(15)
                    let bubbleWidth = (screenWidth - marginLeft * 2 - space * 3) / 4
                    model.bubbleSize = Int(bubbleWidth)/2
                    let bubbleView = AIBubble(center: .zero, model: model, type: model.bubbleType, index: 0)
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
        addNewSubView(pLabel, preView: bubbleViewContain)
        pLabel.backgroundColor = UIColor(hexString: "#000000", alpha: 0.3)
        let hView4 = AIServerProviderView.initFromNib() as? AIServerProviderView
        addNewSubView(hView4!, preView: pLabel)
        hView4?.fillDataWithModel(dataModel?.provider)
        let lineView3 = addSplitView()
        hView4?.image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AIProductInfoViewController.targetProInfoAction(_:))))
        
        // Setup 6:
        let pcLabel = getTitleLabelView("商品介绍")
        addNewSubView(pcLabel, preView: lineView3)
        pcLabel.backgroundColor = UIColor(hexString: "#000000", alpha: 0.3)
        let holdSpaceView = UIView()
        addNewSubView(holdSpaceView, preView: pcLabel)
        holdSpaceView.setHeight(44/3)
        let bottomImage = AIImageView()
        bottomImage.setImgURL(NSURL(string:dataModel?.desc_image ?? ""), placeholderImage: smallPlace())
        bottomImage.setHeight(675)
        bottomImage.backgroundColor = UIColor(hexString: "#6AB92E", alpha: 0.7)
        bottomImage.contentMode = UIViewContentMode.ScaleAspectFill
        bottomImage.clipsToBounds = true
        addNewSubView(bottomImage, preView: holdSpaceView)

        // Setup 7: Provider Info
        
        let provideView = addCustomView(bottomImage)
        
        // Setup 8: Audio
        let audioView = AICustomAudioNotesView.currentView()
        addNewSubView(audioView, preView: provideView!)
        audioView.delegateShowAudio = self
        
    }
    
    func showCommentView() {
        let vc = AIProductCommentsViewController()
        let nav = UINavigationController(rootViewController: vc)
        presentBlurViewController(nav, animated: true, completion: nil)
    
    }
    
    
    @IBAction func targetProInfoAction(any: AnyObject) {
        showTransitionStyleCrossDissolveView(AIProductProviderViewControler.initFromNib())
    }
    

    private func addCustomView(preView: UIView) -> UIView? {
        
        var viw: UIView = preView
        
        if let customNot = dataModel?.customer_note {
            
            let wish = AIProposalServiceDetail_WishModel()
            var array1 = Array<AIProposalServiceDetailLabelModel>()
            var array2 = Array<AIProposalServiceDetailHopeModel>()
            if let taglist = customNot.tag_list {
                taglist.forEach({ (model) in
                    let labelModel_1 = AIProposalServiceDetailLabelModel()
                    labelModel_1.content = model.name ?? ""
                    labelModel_1.label_id = model.tag_id ?? 0
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
                    custView.wish_id = 1
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
    
    // MARK: - DIY ACTION
    func showDetailView(sender: AnyObject) {
        let model = AIBuyerBubbleModel()
        model.proposal_id = 3525
        model.proposal_name = "Pregnancy Care"
        let viewsss = createBuyerDetailViewController(model)
        showTransitionStyleCrossDissolveView(viewsss)
    }
    
    func  createBuyerDetailViewController(model: AIBuyerBubbleModel) -> UIViewController {
        
        let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIBuyerStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIBuyerDetailViewController) as! AIBuyerDetailViewController
        viewController.bubbleModel = model
        viewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        viewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        
        return viewController
    }
    
    func configOrderAction() {
        let model = AIProposalInstModel()
        model.proposal_id = 3525
        model.proposal_name = "Pregnancy Care"
        
        if let vc = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIBuyerStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIConfirmOrderViewController) as? AIConfirmOrderViewController {
            vc.dataSource  = model
            showTransitionStyleCrossDissolveView(vc)
        }
        
    }
   
    // MARK: - Action Event Touch Up Inside
    @IBAction func showOrderAction(sender: AnyObject) {
        configOrderAction()
    }
    
    func providerDetailPressed() {
        let vc = AIProviderDetailViewController.initFromNib()
        let nav = UINavigationController(rootViewController: vc)
        presentBlurViewController(nav, animated: true, completion: nil)
    }
    
    func recommondForYouPressed() {
        // 为您推荐
        let vc = AIRecommondForYouViewController()
        let nav = UINavigationController(rootViewController: vc)
        presentBlurViewController(nav, animated: true, completion: nil)
    }
    
	func qaButtonPressed() {
        let vc = AIProductQAViewController()
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
extension AIProductInfoViewController: UIScrollViewDelegate {
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
        
	}
	
}


extension AIProductInfoViewController: AICustomAudioNotesViewShowAudioDelegate {
    
    func showAudioView(type: Int) {
        
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
