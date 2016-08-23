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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupTableView()
		setupFilterView()
        setupWishButton()
		fetchData()
		
        if let audioView = audioView as? AIAudioSearchButtonView {
            view.addSubview(audioView)
            audioView.snp_makeConstraints(closure: { (make) in
                make.trailing.leading.equalTo(view)
                make.height.equalTo(42)
                make.bottomMargin.equalTo(42)
            })
            audioView.button.addTarget(self, action: #selector(AICustomSearchHomeViewController.audioAction), forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        // Register Audio Tools Notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AICustomSearchHomeViewController.listeningAudioTools), name: AIApplication.Notification.AIListeningAudioTools, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AICustomSearchHomeViewController.popToRootView), name: AIApplication.Notification.dissMissPresentViewController, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AICustomSearchHomeViewController.popToAllView), name: AIApplication.Notification.WishVowViewControllerNOTIFY, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardDidHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
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
            self?.recentlySearchTexts = recentlySearchTexts
            self?.everyOneSearchTexts = everyOneSearchTexts
            self?.browseHistory = browseHistory
            self?.setupRecentlySearchView()
        }) {[weak self] (errType, errDes) in
            self?.view.hideLoading()
		}
	}
	
	func popToRootView() {
		self.dismissViewControllerAnimated(false, completion: nil)
	}
	
	func popToAllView() {
		self.dismissViewControllerAnimated(false, completion: nil)
		self.dismissViewControllerAnimated(false, completion: nil)
	}
    
    func keyboardDidShow(notification: NSNotification?) {
        
        // change keyboard height
        
        if let userInfo = notification?.userInfo {
            
            // step 1: get keyboard height
            let keyboardRectValue: NSValue = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
            let keyboardRect: CGRect = keyboardRectValue.CGRectValue()
            let keyboardHeight: CGFloat = min(CGRectGetHeight(keyboardRect), CGRectGetWidth(keyboardRect))
            print(keyboardHeight)
            if keyboardHeight > 0 {
                if let audioView = audioView {
                    SpringAnimation.spring(0.3, animations: { 
                        audioView.setTop(self.view.height - keyboardHeight-42)
                    })
                    
                }
            }
        }
    }
    
    func keyboardDidHide(notification: NSNotification?) {
        if let _ = notification {
            if let audioView = audioView {
                audioView.setTop(view.height+42)
            }
            
        }
    }
    
    func audioAction() {
        showTransitionStyleCrossDissolveView(AIAudioSearchViewController.initFromNib())
    }


    
    /**
     处理语音识别数据搜索
     */
	func listeningAudioTools(notify: NSNotification) {
		if let result = notify.userInfo {
			let string = result["Results"] as? String
			Async.main({
				self.searchText.text = string ?? ""
				self.searching()
				self.tableView.hidden = false
				self.holdView.hidden = true
			})
			
		}
	}
	
	// MARK: Action
	
	func makeAWishAction() {
		showTransitionStyleCrossDissolveView(AIWishVowViewController.initFromNib())
	}
	
	@IBAction func choosePhotoAction(any: AnyObject) {
		let vc = AIAssetsPickerController.initFromNib()
		vc.delegate = self
		vc.maximumNumberOfSelection = 10
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
		wishButton.setTitle("   Make a Wish", forState: UIControlState.Normal)
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
		recentlySearchTag = AISearchHistoryLabels(frame: CGRect(x: 10, y: 20, width: screenWidth, height: 200), title: "You recently searched", labels: recentlySearchTexts)
		recentlySearchTag.delegate = self
		holdView.addSubview(recentlySearchTag)
		everyOneSearchTag = AISearchHistoryLabels(frame: CGRect(x: 10, y: 0, width: screenWidth, height: 200), title: "Everyone is searching", labels: everyOneSearchTexts)
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
		let vc = AISuperiorityViewController.initFromNib()
		vc.serviceModel = model
		showTransitionStyleCrossDissolveView(vc)
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
				AILog(res)
				self?.searchText.text = res
				self?.searching()
			} else {
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
		service.filterServices(searchText.text ?? "", page_size: 1000, page_number: 1, filterModel: resultFilterBar.requestParams, success: { [weak self] (res) in
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
		let vc = AISuperiorityViewController.initFromNib()
		vc.serviceModel = browseHistory![index]
		showTransitionStyleCrossDissolveView(vc)
	}
}

extension AICustomSearchHomeViewController: GridBubblesViewDelegate {
	func bubblesView(bubblesView: GridBubblesView, didClickBubbleViewAtIndex index: Int) {
		let model = bubblesView.bubbleModels[index]
		let vc = AIWishPreviewController.initFromNib()
		vc.model = model
		showTransitionStyleCrossDissolveView(vc)
	}
}
