//
//  AICustomSearchHomeViewController.swift
//  AIVeris
//
//  Created by 王坜 on 16/6/1.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

import UIKit
import Spring
import Cartography
import AIAlertView
import SnapKit

class AICustomSearchHomeViewController: UIViewController {
	
	// MARK: Private
	
	var searchBar: UISearchBar?
    var recentlySearchTag: AISearchHistoryLabels!
    var everyOneSearchTag: AISearchHistoryLabels!

    //MARK: Private
 

    //MARK: Method Init
    func makeButton(){
        let wishButton = UIButton(type: UIButtonType.Custom)
        wishButton.setTitle("Make a wish", forState: UIControlState.Normal)
        view.addSubview(wishButton)
        wishButton.backgroundColor = UIColor.clearColor()
        wishButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        wishButton.titleLabel?.textColor = UIColor.whiteColor()
        constrain(wishButton) { (wishProxy) in
            wishProxy.height == 30
            wishProxy.left == wishProxy.superview!.left + 10
            wishProxy.right == wishProxy.superview!.right + 10
            wishProxy.bottom == wishProxy.superview!.bottom - 5
        }
        wishButton.addTarget(self, action: #selector(makeAWishAction), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
	// MARK: Method Init
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		addKeyboardNotifications()
		
		// Make Title View
		initLayoutViews()
		
		
	}
	
	// MARK: Action
	
	func makeAWishAction() {
		showTransitionStyleCrossDissolveView(AIProductInfoViewController.initFromNib())
	}
	
	/**
	 init with navigation bar.
	 */
	func initLayoutViews() {
		// Make Test Data View
		recentlySearchTag = AISearchHistoryLabels(frame: CGRectMake(10, 60, 300, 200), title: "You recently searched", labels: ["Pregnat", "Travel", "Europe", "Outdoors"])
        recentlySearchTag.delegate = self
		view.addSubview(recentlySearchTag)
		everyOneSearchTag = AISearchHistoryLabels(frame: CGRectMake(10, 60, 300, 200), title: "Everyone is searching", labels: ["Ordering", "Baby Carriage", "Children's clothing"])
        everyOneSearchTag.delegate = self
        everyOneSearchTag.setY(recentlySearchTag.bottom + 30)
        view.addSubview(everyOneSearchTag)
        
		
		// Make Wish Button
		let wishButton = UIButton(type: UIButtonType.Custom)
		wishButton.setTitle("Make a wish", forState: UIControlState.Normal)
		view.addSubview(wishButton)
		wishButton.backgroundColor = UIColor.clearColor()
		wishButton.titleLabel?.font = UIFont.systemFontOfSize(14)
		wishButton.titleLabel?.textColor = UIColor.whiteColor()
		constrain(wishButton) { (wishProxy) in
			wishProxy.height == 30
			wishProxy.left == wishProxy.superview!.left + 10
			wishProxy.right == wishProxy.superview!.right + 10
			wishProxy.bottom == wishProxy.superview!.bottom - 5
		}
		wishButton.addTarget(self, action: #selector(makeAWishAction), forControlEvents: UIControlEvents.TouchUpInside)
	}

	// MARK: Keyboard Notification
	func addKeyboardNotifications() {
		
	}
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

extension AICustomSearchHomeViewController: UITextViewDelegate {
	func textViewShouldBeginEditing(textView: UITextView) -> Bool {
		return true
	}
	
	func textViewDidEndEditing(textView: UITextView) {
		
	}
	
	func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
		return true
	}
	
}

extension AICustomSearchHomeViewController: AISearchHistoryLabelsDelegate {
    func searchHistoryLabels(searchHistoryLabel: AISearchHistoryLabels, clickedText: String) {
		print(#function + " called")
        print(clickedText)
    }
}