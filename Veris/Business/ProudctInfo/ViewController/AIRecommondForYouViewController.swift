// AIVeris
//
//  Created by zx on 7/18/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIRecommondForYouViewController: UIViewController {
	var tableView: UITableView!
	var data = [String]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupData()
		setupTableView()
		setupNavigationItems()
	}
	
	func setupNavigationItems() {
		let rightButton1 = UIButton()
		rightButton1.setImage(UIImage(named: "ai_audio_button_change"), forState: .Normal)
		let rightButton2 = UIButton()
		rightButton2.setImage(UIImage(named: "ai_audio_button_change"), forState: .Normal)
		let rightButton3 = UIButton()
		rightButton3.setImage(UIImage(named: "ai_audio_button_change"), forState: .Normal)
		
		let appearance = UINavigationBarAppearance()
		let barOption = UINavigationBarAppearance.BarOption(backgroundColor: UIColor.clearColor(), backgroundImage: nil, height: 64)
		let titleOption = UINavigationBarAppearance.TitleOption(bottomPadding: 0, font: AITools.myriadSemiboldSemiCnWithSize(20), textColor: UIColor.whiteColor(), text: "测试")
		
		appearance.barOption = barOption
		appearance.titleOption = titleOption
		appearance.rightBarButtonItems = [rightButton1, rightButton2, rightButton3]
		appearance.itemPositionForIndexAtPosition = { index, position in
			if position == .Left {
				return (10.0, CGFloat(index) * 20.0)
			} else {
				return (10.0, CGFloat(index) * 20.0)
			}
		}
		
		setNavigationBarAppearance(navigationBarAppearance: appearance)
	}
	
	func backButtonPressed() {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func setupData() {
		data = [
			"",
			"",
			"",
			"",
			"",
			""
		]
		
	}
	
	func setupTableView() {
		tableView = UITableView(frame: .zero, style: .Plain)
		tableView.tableFooterView = UIView()
		tableView.backgroundColor = UIColor.clearColor()
		tableView.delegate = self
		tableView.dataSource = self
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
		return data.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
		return cell
	}
}

// MARK: - UITableViewDelegate
extension AIRecommondForYouViewController: UITableViewDelegate {
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return AIRecommondForYouCell.cellHeight
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let vc = AIRecommondForYouViewController()
		navigationController?.pushViewController(vc, animated: true)
	}
}
