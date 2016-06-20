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

	var searchBar: UISearchBar?
    var recentlySearchTag: AISearchHistoryLabels!
    var everyOneSearchTag: AISearchHistoryLabels!

    @IBOutlet weak var holdView: UIView!
    @IBOutlet weak var tableView: UITableView!
    //MARK: Private

    private var dataSource: [AISearchResultItemModel] = Array<AISearchResultItemModel>()

	// MARK: Method Init

	override func viewDidLoad() {
		super.viewDidLoad()

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
		recentlySearchTag = AISearchHistoryLabels(frame: CGRect(x: 10, y: 60, width: 300, height: 200), title: "You recently searched", labels: ["Pregnat", "Travel", "Europe", "Outdoors"])
        recentlySearchTag.delegate = self
		holdView.addSubview(recentlySearchTag)
		everyOneSearchTag = AISearchHistoryLabels(frame: CGRect(x: 10, y: 60, width: 300, height: 200), title: "Everyone is searching", labels: ["Ordering", "Baby Carriage", "Children's clothing"])
        everyOneSearchTag.delegate = self
        everyOneSearchTag.setY(recentlySearchTag.bottom + 30)
        holdView.addSubview(everyOneSearchTag)


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

    @IBAction func backButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func searching() {
        if let path = NSBundle.mainBundle().pathForResource("searchJson", ofType: "json") {
            let data: NSData? = NSData(contentsOfFile: path)
            if let dataJSON = data {
                do {
                    let model = try AISearchResultModel(data: dataJSON)

//                  model.results = model.results.map({ AISearchResultItemModel(dictionary: $0)})
                    do {
                        try model.results?.forEach({ (item) in
                            let resultItem = try AISearchResultItemModel(dictionary: item as [NSObject : AnyObject])
                            dataSource.append(resultItem)
                        })
                    } catch {}

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
        holdView.hidden = true
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
