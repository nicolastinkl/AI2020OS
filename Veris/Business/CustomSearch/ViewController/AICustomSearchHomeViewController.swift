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
//import AsyncDisplayKit

class AICustomSearchHomeViewController: UIViewController {
	
	// MARK: Private
	
    @IBOutlet weak var searchText: UITextField!
	var recentlySearchTag: AISearchHistoryLabels!
	var everyOneSearchTag: AISearchHistoryLabels!
	var iconView: AISearchHistoryIconView!
	
	@IBOutlet weak var holdView: UIView!
	@IBOutlet weak var tableView: UITableView!
	
    // MARK: Private
	
	private var dataSource: [AISearchResultItemModel] = Array<AISearchResultItemModel>()
	
	// MARK: Method Init
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Make Title View
		initLayoutViews()
        
        // Register Audio Tools Notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AICustomSearchHomeViewController.listeningAudioTools), name: AIApplication.Notification.AIListeningAudioTools, object: nil)
        
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
		showTransitionStyleCrossDissolveView(AIPaymentViewController.initFromNib())
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
        showTransitionStyleCrossDissolveView(AIAudioSearchViewController.initFromNib())
    }
    
	/**
	 init with navigation bar.
	 */
	func initLayoutViews() {
        
        
		// Make Test Data View
		recentlySearchTag = AISearchHistoryLabels(frame: CGRect(x: 10, y: 20, width: screenWidth, height: 200), title: "You recently searched", labels: ["Pregnat", "Travel", "Europe", "Outdoors"])
		recentlySearchTag.delegate = self
		holdView.addSubview(recentlySearchTag)
		everyOneSearchTag = AISearchHistoryLabels(frame: CGRect(x: 10, y: 0, width: screenWidth, height: 200), title: "Everyone is searching", labels: ["Ordering", "Baby Carriage", "Children's clothing"])
		everyOneSearchTag.delegate = self
		everyOneSearchTag.setY(recentlySearchTag.bottom + 30)
		holdView.addSubview(everyOneSearchTag)
		
		iconView = AISearchHistoryIconView(items: [
			(image: "search-icon0", title: "Shangeri-La Hotel"),
			(image: "search-icon1", title: "Origus"),
			(image: "search-icon2", title: "Pregnacy"),
			(image: "search-icon3", title: "Photography classroom"),
			], width: screenWidth)
        
        iconView.setY(everyOneSearchTag.bottom + 40)
        
        holdView.addSubview(iconView)
		
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
            wishProxy.height == 32/3
            wishProxy.width == 17/3
            wishProxy.centerY == wishProxy.superview!.centerY - 1
            wishProxy.centerX == wishProxy.superview!.centerX + 60
        }
        
	}
	
	@IBAction func backButtonPressed(sender: AnyObject) {
		dismissViewControllerAnimated(true, completion: nil)
	}
    @IBAction func searchButtonPressed(sender: AnyObject) {
        
    }
	
	func searching() {
        tableView.hidden = false
        holdView.hidden = true
		if let path = NSBundle.mainBundle().pathForResource("searchJson", ofType: "json") {
			let data: NSData? = NSData(contentsOfFile: path)
			if let dataJSON = data {
				do {
					let model = try AISearchResultModel(data: dataJSON)
					
//                  model.results = model.results.map({ AISearchResultItemModel(dictionary: $0)})
					do {
						try model.results?.forEach({ (item) in
							let resultItem = try AISearchResultItemModel(dictionary: item as [NSObject: AnyObject])
							dataSource.append(resultItem)
						})
					} catch { }
					
					if dataSource.count > 0 {
						tableView.reloadData()
					}
				} catch {
					print("AIOrderPreListModel JSON Parse err.")
					
				}
			}
		}
	}
}

extension AICustomSearchHomeViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
        
		searching()
        
		textField.resignFirstResponder()
		
		return true
	}
	
}

extension AICustomSearchHomeViewController: AISearchHistoryLabelsDelegate {
	func searchHistoryLabels(searchHistoryLabel: AISearchHistoryLabels, clickedText: String) {
		print(#function + " called")
		print(clickedText)
	}
}

extension AICustomSearchHomeViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		let model: AISearchResultItemModel = dataSource[indexPath.row]
		let vc = AISuperiorityViewController.initFromNib()
		vc.serviceModel = model
		showTransitionStyleCrossDissolveView(vc)
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let model: AISearchResultItemModel = dataSource[indexPath.row]
		let cell = AICustomSearchHomeCell.initFromNib() as? AICustomSearchHomeCell
		cell?.initData(model)
		cell?.backgroundColor = UIColor.clearColor()
		return cell!
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSource.count
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 110.0
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
        AIImageRecongizeService().getImageInfo(image) { [weak self] (res, error) in
            print(res)
            self?.view.hideLoading()
            if error == nil {
                self?.searchText.text = res
                self?.searching()
            } else {
                
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
