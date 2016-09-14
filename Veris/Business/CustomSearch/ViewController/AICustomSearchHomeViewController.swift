//
//  AICustomSearchHomeViewController.swift
//  AIVeris
//
//  Created by 王坜 on 16/6/1.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Spring
import Cartography
import AIAlertView
import SnapKit
import IQKeyboardManagerSwift

class AICustomSearchHomeViewController: UIViewController {
	
	// MARK: Private
	
	@IBOutlet weak var searchText: UITextField!
	var recentlySearchTag: AISearchHistoryLabels!
	var everyOneSearchTag: AISearchHistoryLabels!
	var browseHistoryView: AISearchHistoryIconView!
	
	@IBOutlet weak var holdView: UIView!
	@IBOutlet weak var resultFilterBar: AICustomSearchHomeResultFilterBar!
	@IBOutlet weak var resultHoldView: UIView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var bubbleContainerView: UIView!
    
    var recentlySearchTexts: [String]?
    var everyOneSearchTexts: [String]?
    var browseHistory: [AISearchServiceModel]?
	
    private var audioView = AIAudioSearchButtonView.initFromNib()
	// MARK: Private
	
	private var dataSource: [AISearchServiceModel] = []
	
	var bubbleModels = [AIBuyerBubbleModel]()
	
	// MARK: Method Init
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = true
    }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupTableView()
		setupFilterView()
        setupWishButton()
		fetchData()
		
        if let audioView = audioView as? AIAudioSearchButtonView {
            audioView.setHeight(42)
            audioView.button.addTarget(self, action: #selector(AICustomSearchHomeViewController.audioAction), forControlEvents: UIControlEvents.TouchDown)
            searchText.inputAccessoryView = audioView
        }
        
        // Register Audio Tools Notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AICustomSearchHomeViewController.listeningAudioTools), name: AIApplication.Notification.AIListeningAudioTools, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AICustomSearchHomeViewController.popToAllView), name: AIApplication.Notification.dissMissPresentViewController, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AICustomSearchHomeViewController.popToAllView), name: AIApplication.Notification.WishVowViewControllerNOTIFY, object: nil)
	}
	
	func fetchData() {
		let service = AISearchHomeService()
		
		service.getRecommendedServices({ [weak self](models) in
			self?.bubbleModels = AIBuyerBubbleModel.convertFrom(models)
			self?.setupBubbleView()
		}) { (errType, errDes) in
		}
		
        self.view.showLoading()
        service.recentlySearch({ [weak self] (recentlySearchTexts: [String], everyOneSearchTexts: [String], browseHistory: [AISearchServiceModel]) in
            self?.view.hideLoading()
           
            if recentlySearchTexts.count > 10 {
                self?.recentlySearchTexts = Array(recentlySearchTexts[0..<9])
            } else {
                self?.recentlySearchTexts = recentlySearchTexts
            }
            self?.everyOneSearchTexts = everyOneSearchTexts
            self?.browseHistory = browseHistory
            self?.setupRecentlySearchView()
        }) {[weak self] (errType, errDes) in
            self?.view.hideLoading()
		}
	}	 
	
	func popToAllView() {
		self.dismissViewControllerAnimated(false, completion: nil)
		self.dismissViewControllerAnimated(false, completion: nil)
	}
    
    func audioAction() {
        showTransitionStyleCrossDissolveView(AIAudioSearchViewController.initFromNib())
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    /**
     处理语音识别数据搜索
     */
	func listeningAudioTools(notify: NSNotification) {
		if let result = notify.userInfo {
			let string = result["Results"] as? String
            if let strings = string {
                var newStr: NSString = NSString(string: "\(strings)")
                newStr = newStr.stringByReplacingOccurrencesOfString("。", withString: "")
                newStr = newStr.stringByReplacingOccurrencesOfString("，", withString: "")
                Async.main({
                    self.searchText.text = newStr as String
                    self.searching()
                    self.tableView.hidden = false
                    self.holdView.hidden = true
                })
            }
			
		}
	}
	
	// MARK: Action
	
	func makeAWishAction() {
		showTransitionStyleCrossDissolveView(AIWishVowViewController.initFromNib())
	}
	
	@IBAction func choosePhotoAction(any: AnyObject) {
		let vc = AIAssetsPickerController.initFromNib()
		vc.delegate = self
		vc.maximumNumberOfSelection = 1
		let navi = UINavigationController(rootViewController: vc)
		navi.navigationBarHidden = true
		self.presentViewController(navi, animated: true, completion: nil)
	}
	
	@IBAction func showListAction(any: AnyObject) {
		
	}
	
	func setupTableView() {
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 100
	}
	
	func setupFilterView() {
		resultFilterBar.menuContainerView = view
		resultFilterBar.menuViewTopSpace = AITools.displaySizeFrom1242DesignSize(198 + 122)
		resultFilterBar.delegate = self
	}
	
	func setupBubbleView() {
		let bubblesView = GridBubblesView(bubbleModels: bubbleModels)
		bubblesView.delegate = self
		bubblesView.setY(AITools.displaySizeFrom1242DesignSize(87))
		bubbleContainerView.addSubview(bubblesView)
	}
    
    func setupWishButton() {
		// Make Wish Button
		let wishButton = UIButton(type: UIButtonType.Custom)
		wishButton.setTitle("AICustomSearchHomeViewController.makeWish".localized, forState: UIControlState.Normal)
		wishButton.setImage(UIImage(named: "AI_Search_Home_WIsh"), forState: UIControlState.Normal)
		view.addSubview(wishButton)
		wishButton.backgroundColor = UIColor.clearColor()
		wishButton.titleLabel?.font = AITools.myriadLightSemiCondensedWithSize(16)
		wishButton.titleLabel?.textColor = UIColor(hexString: "#d4d5ef", alpha: 0.70)
		constrain(wishButton) { (wishProxy) in
			wishProxy.height == 30
			wishProxy.left == wishProxy.superview!.left + 10
			wishProxy.right == wishProxy.superview!.right + 10
			wishProxy.bottom == wishProxy.superview!.bottom - 5
		}
		wishButton.addTarget(self, action: #selector(makeAWishAction), forControlEvents: UIControlEvents.TouchUpInside)
		
		let imageview = UIImageView(image: UIImage(named: "AI_Search_Home_right"))
		wishButton.addSubview(imageview)
		
		constrain(imageview) { (wishProxy) in
			wishProxy.height == 32 / 3
			wishProxy.width == 17 / 3
			wishProxy.centerY == wishProxy.superview!.centerY - 1
			wishProxy.centerX == wishProxy.superview!.centerX + 60
		}
    }
	func setupRecentlySearchView() {
		
		// Make Test Data View
		recentlySearchTag = AISearchHistoryLabels(frame: CGRect(x: 13, y: 20, width: screenWidth - 20, height: 200), title: "You recently searched", labels: recentlySearchTexts)
		recentlySearchTag.delegate = self
		holdView.addSubview(recentlySearchTag)
		everyOneSearchTag = AISearchHistoryLabels(frame: CGRect(x: 13, y: 0, width: screenWidth - 20, height: 200), title: "Everyone is searching", labels: everyOneSearchTexts)
		everyOneSearchTag.delegate = self
		everyOneSearchTag.setY(recentlySearchTag.bottom + AITools.displaySizeFrom1242DesignSize(83))
		holdView.addSubview(everyOneSearchTag)
		
        if let browseHistory = browseHistory {
            browseHistoryView = AISearchHistoryIconView(items: browseHistory, width: screenWidth)
            browseHistoryView.delegate = self
            browseHistoryView.setY(everyOneSearchTag.bottom + AITools.displaySizeFrom1242DesignSize(109))
            holdView.addSubview(browseHistoryView)
        }
	}
	
	@IBAction func backButtonPressed(sender: AnyObject) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	@IBAction func searchButtonPressed(sender: AnyObject) {
		
	}
	
	func searching() {
		view.endEditing(true)
		view.showLoading()
        AIAnalytics.event(.SearchService, attributes: [.Keyword:searchText.text ?? ""])
		let service = AISearchHomeService()
		service.searchServiceCondition(searchText.text ?? "", page_size: 10, page_number: 1, success: { [weak self](model) in
			
            self?.view.hideLoading()
			self?.resultHoldView.hidden = false
			self?.holdView.hidden = true            
            self?.resultFilterBar.filterModel = model
            
            if model.service_list != nil {
                self?.dataSource = model.service_list as! [AISearchServiceModel]
                self?.tableView.reloadData()
            }
            
		}) { [weak self](errType, errDes) in
			self?.view.hideLoading()
		}
	}
	
	func endSearching() {
		resultHoldView.hidden = true
		holdView.hidden = false
	}
}

extension AICustomSearchHomeViewController: UITextFieldDelegate {
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		searching()
		return true
	}
	
	func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
		if let text = textField.text {
			let textFieldRange = NSMakeRange(0, text.characters.count)
			if (NSEqualRanges(range, textFieldRange) && string.characters.count == 0) {
				endSearching()
			}
		}
		return true
	}
	
	func textFieldShouldClear(textField: UITextField) -> Bool {
		endSearching()
		return true
	}
}

extension AICustomSearchHomeViewController: AISearchHistoryLabelsDelegate {
	func searchHistoryLabels(searchHistoryLabel: AISearchHistoryLabels, clickedText: String) {
		AILog(#function + " called")
		AILog(clickedText)
		searchText.text = clickedText
		searching()
	}
}

extension AICustomSearchHomeViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		let model: AISearchServiceModel = dataSource[indexPath.row]
		
        if AILocalStore.isCacheVisited(model.sid ?? 0) {            
            // 进入服务详情
            let pvc  = AIProductInfoViewController.initFromNib()
            pvc.sid = model.sid ?? 0
            showTransitionStyleCrossDissolveView(pvc)
        } else {
            // 进入服务首页
            let vc = AISuperiorityViewController.initFromNib()
            vc.serviceModel = model
            showTransitionStyleCrossDissolveView(vc)
        }
        
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let model: AISearchServiceModel = dataSource[indexPath.row]
		let cell = AICustomSearchHomeCell.initFromNib() as? AICustomSearchHomeCell
		cell?.initData(model)
		cell?.backgroundColor = UIColor.clearColor()
		return cell!
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSource.count
	}
}

extension AICustomSearchHomeViewController: AIAssetsPickerControllerDelegate {
	
	/**
	 完成选择

	 1. 缩略图： UIImage(CGImage: assetSuper.thumbnail().takeUnretainedValue())
	 2. 完整图： UIImage(CGImage: assetSuper.fullResolutionImage().takeUnretainedValue())
	 */
	func assetsPickerController(picker: AIAssetsPickerController, didFinishPickingAssets assets: NSArray) {
		let assetSuper = assets.firstObject as! ALAsset
		let image = UIImage(CGImage: assetSuper.defaultRepresentation().fullResolutionImage().takeUnretainedValue())
		view.showLoading()
		AIImageRecongizeService().getImageInfo(image) { [weak self](res, error) in
			self?.view.hideLoading()
			if error == nil {
				self?.searchText.text = res
				self?.searching()
			} else {
                AIAlertView().showError("error", subTitle: "图片解析失败")
				// handle error
			}
		}
	}
	
	/**
	 取消选择
	 */
	func assetsPickerControllerDidCancel() {
		
	}
	
	/**
	 选中某张照片
	 */
	func assetsPickerController(picker: AIAssetsPickerController, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		
	}
	/**
	 取消选中某张照片
	 */
	func assetsPickerController(picker: AIAssetsPickerController, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
		
	}
}

extension AICustomSearchHomeViewController: AICustomSearchHomeResultFilterBarDelegate {
	func customSearchHomeResultFilterBar(filterBar: AICustomSearchHomeResultFilterBar, didSelectType type: FilterType, index: Int) {
		filterBar.hideMenu()
        view.showLoading()
		let service = AISearchHomeService()
//        var att = resultFilterBar.requestParams
//        att.addEntriesFromDictionary([: searchText.text ?? ""])
        AIAnalytics.event(.FilterSearch, attributes:[.Keyword: searchText.text ?? ""])
		service.filterServices(searchText.text ?? "", page_size: 10, page_number: 1, filterModel: resultFilterBar.requestParams, success: { [weak self] (res) in
            self?.view.hideLoading()
            self?.dataSource = res
            self?.tableView.reloadData()
		}) {[weak self] (errType, errDes) in
            self?.view.hideLoading()
		}
	}
}

extension AICustomSearchHomeViewController: AISearchHistoryIconViewDelegate {
	func searchHistoryIconView(iconView: AISearchHistoryIconView, didClickAtIndex index: Int) {
		
        if let browseHistoryPre = browseHistory {
            let model = browseHistoryPre[index]
            if AILocalStore.isCacheVisited(model.sid ?? 0) {
                // 进入服务详情
                let pvc  = AIProductInfoViewController.initFromNib()
                pvc.sid = model.sid ?? 0
                showTransitionStyleCrossDissolveView(pvc)
            } else {
                // 进入服务首页
                let vc = AISuperiorityViewController.initFromNib()
                vc.serviceModel = model
                AIAnalytics.event(.HistoryIconClick, attributes: [.PartyID: vc.serviceModel!.sid.toString()])
                showTransitionStyleCrossDissolveView(vc)
            }
            
        }
        
	}
}

extension AICustomSearchHomeViewController: GridBubblesViewDelegate {
	func bubblesView(bubblesView: GridBubblesView, didClickBubbleViewAtIndex index: Int) {
		let model = bubblesView.bubbleModels[index]
        AIAnalytics.event(.RecommendIconClick, attributes: [.PartyID: model.proposal_id.toString()])
		let vc = AIProductInfoViewController.initFromNib()
		vc.sid = model.proposal_id
		showTransitionStyleCrossDissolveView(vc)
	}
}
