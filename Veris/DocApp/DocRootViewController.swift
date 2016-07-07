//
//  DocRootViewController.swift
//  AIVeris
//
//  Created by zx on 7/6/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

struct DocAction {
	var title: String
	var subtitle: String
	var viewControllerClassName: String
}

extension DocAction {
	var vc: UIViewController {
		let className = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String + "." + viewControllerClassName
		let myClass = NSClassFromString(className) as! UIViewController.Type
		return myClass.init()
	}
}

class DocRootViewController: UIViewController {
	var tableView: UITableView!
	var actions: [DocAction]!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.whiteColor()
        title = "文档"
		setupDataSource()
		setupTableView()
	}
	
	func setupDataSource() {
		actions = [
			DocAction(title: "模糊present", subtitle: "通用模糊presentVC", viewControllerClassName: "DocBlurPresentViewController"),
			
			DocAction(title: "button 修改image位置", subtitle: "", viewControllerClassName: "DocButtonImagePositionViewController"),
		]
	}
	
	func setupTableView() {
		tableView = UITableView(frame: .zero, style: .Plain)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		view.addSubview(tableView)
		tableView.snp_makeConstraints { (make) in
			make.edges.equalTo(view)
		}
	}
}

// MARK: - UITableViewDelegate
extension DocRootViewController: UITableViewDelegate {
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let action = actions[indexPath.row]
        navigationController?.pushViewController(action.vc, animated: true)
	}
}

// MARK: - UITableViewDataSource
extension DocRootViewController: UITableViewDataSource {
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return actions.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCellWithIdentifier("cell")
		if cell == nil {
			cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cell")
		}
		let action = actions[indexPath.row]
		cell?.textLabel?.text = action.title
		cell?.detailTextLabel?.text = action.subtitle
		return cell!
	}
}
