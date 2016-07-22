// AIVeris
//
//  Created by zx on 7/18/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIRecommondForYouViewController: UIViewController {
	var tableView: UITableView!
	private var dataSource: [AISearchResultItemModel] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupData()
		setupTableView()
		setupNavigationItems()
	}
	
	func setupNavigationItems() {
		setupNavigationBarLikeQA(title: "为您推荐")
	}
	
	func setupData() {
		if let path = NSBundle.mainBundle().pathForResource("searchJson", ofType: "json") {
			let data: NSData? = NSData(contentsOfFile: path)
			if let dataJSON = data {
				do {
					let model = try AISearchResultModel(data: dataJSON)
					
					do {
						try model.results?.forEach({ (item) in
							let resultItem = try AISearchResultItemModel(dictionary: item as [NSObject: AnyObject])
							dataSource.append(resultItem)
						})
					} catch { }
				} catch {
					AILog("AIOrderPreListModel JSON Parse err.")
				}
			}
		}
	}
	
	func setupTableView() {
		tableView = UITableView(frame: .zero, style: .Plain)
		tableView.tableFooterView = UIView()
		tableView.backgroundColor = UIColor.clearColor()
		tableView.delegate = self
		tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
		view.addSubview(tableView)
		tableView.registerNib(UINib(nibName: "AIRecommondForYouCell", bundle: nil), forCellReuseIdentifier: "cell")
		tableView.snp_makeConstraints { (make) in
			make.edges.equalTo(view).offset(UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0))
		}
		tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
	}
}

// MARK: - UITableViewDataSource
extension AIRecommondForYouViewController: UITableViewDataSource {
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSource.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let model: AISearchResultItemModel = dataSource[indexPath.row]
		let cell = AICustomSearchHomeCell.initFromNib() as? AICustomSearchHomeCell
		cell?.initData(model)
		cell?.backgroundColor = UIColor.clearColor()
		return cell!
	}
}

// MARK: - UITableViewDelegate
extension AIRecommondForYouViewController: UITableViewDelegate {
	
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let model: AISearchResultItemModel = dataSource[indexPath.row]
        let vc = AISuperiorityViewController.initFromNib()
        vc.serviceModel = model
        showTransitionStyleCrossDissolveView(vc)
    }
}
