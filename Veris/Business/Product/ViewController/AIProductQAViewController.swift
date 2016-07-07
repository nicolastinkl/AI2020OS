//
//  AIProductQAViewController.swift
//  AIVeris
//
//  Created by zx on 6/27/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIProductQAViewController: UIViewController {
	
	var tableView: UITableView!
	var items: [String] = []
	var navigationBar: UIView!
	struct Constants {
		static let barHeight: CGFloat = AITools.displaySizeFrom1242DesignSize(159)
		static let cellSpace: CGFloat = AITools.displaySizeFrom1242DesignSize(27)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTopBar()
		setupData()
		setupTableView()
	}
	
	func setupTopBar() {
		navigationBar = UIView()
		navigationBar.backgroundColor = UIColor ( red: 0.0471, green: 0.0235, blue: 0.1098, alpha: 1.0 )
		view.addSubview(navigationBar)
		
		let backButton = UIButton()
		backButton.setImage(UIImage(named: "scan_back"), forState: .Normal)
		backButton.addTarget(self, action: #selector(AIProductQAViewController.backButtonPressed), forControlEvents: .TouchUpInside)
		navigationBar.addSubview(backButton)
		
		let rightButton = UIButton()
		rightButton.setTitle("Message", forState: .Normal)
		navigationBar.addSubview(rightButton)
		
		navigationBar.snp_makeConstraints { (make) in
			make.top.leading.trailing.equalTo(view)
			make.height.equalTo(Constants.barHeight)
		}
		
		let titleLabel = UILabel()
		titleLabel.textColor = UIColor.whiteColor()
		titleLabel.text = "常见问题"
		navigationBar.addSubview(titleLabel)
		
		backButton.snp_makeConstraints { (make) in
			make.centerY.equalTo(navigationBar)
			make.leading.equalTo(navigationBar).offset(AITools.displaySizeFrom1242DesignSize(55))
		}
		
		titleLabel.snp_makeConstraints { (make) in
			make.center.equalTo(navigationBar)
		}
		
		rightButton.snp_makeConstraints { (make) in
			make.trailing.equalTo(navigationBar).offset(-20)
			make.centerY.equalTo(navigationBar)
		}
	}
	func setupBlurView() {
		let lightEffect = UIBlurEffect(style: .Light)
		let lightView = UIVisualEffectView(effect: lightEffect)
		view.addSubview(lightView)
		lightView.snp_makeConstraints { (make) in
			make.edges.equalTo(view)
		}
		
		let darkEffect = UIBlurEffect(style: .Dark)
		let darkView = UIVisualEffectView(effect: darkEffect)
		view.addSubview(darkView)
		darkView.snp_makeConstraints { (make) in
			make.edges.equalTo(view)
		}
	}
    
	func setupData() {
		for i in 0...6 {
			var string = "这里是提问内容，这里是提问内容。"
			for _ in 0...i {
				string += string
				items.append(string)
			}
		}
	}
	
	func setupTableView() {
		tableView = UITableView(frame: .zero, style: .Grouped)
		tableView.backgroundColor = UIColor.clearColor()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
		tableView.sectionFooterHeight = 20
		tableView.sectionHeaderHeight = 0
		view.addSubview(tableView)
		tableView.snp_makeConstraints { (make) in
			make.top.equalTo(navigationBar.snp_bottom)
			make.leading.trailing.bottom.equalTo(view)
		}
		tableView.estimatedRowHeight = 44
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.registerClass(AIProductQuestionCell.self, forCellReuseIdentifier: "q")
		tableView.registerClass(AIProductAnswerCell.self, forCellReuseIdentifier: "a")
	}
	
	// MARK: - target action
	func backButtonPressed() {
		dismissViewControllerAnimated(true, completion: nil)
	}
}

// MARK: - UITableViewDelegate
extension AIProductQAViewController: UITableViewDelegate {
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
	}
	
}

// MARK: - UITableViewDataSource
extension AIProductQAViewController: UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return items.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let section = indexPath.section
		let item = items[section]
		let row = indexPath.row
		if row == 0 {
			let cell = tableView.dequeueReusableCellWithIdentifier("q") as! AIProductQuestionCell
			cell.contentLabel.text = item
			return cell
		} else {
			let cell = tableView.dequeueReusableCellWithIdentifier("a") as! AIProductAnswerCell
			cell.contentLabel.text = item
			return cell
		}
	}
	
}

class AIProductQACell: UITableViewCell {
	
	var iconView: UIImageView!
	var contentLabel: UILabel!
	var constraintsIsLoaded = false
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
		selectionStyle = .None
		backgroundColor = UIColor (red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1)
		iconView = UIImageView()
		contentView.addSubview(iconView)
		
		contentLabel = UILabel()
		contentLabel.numberOfLines = 0
		contentView.addSubview(contentLabel)
	}
	
	override func updateConstraints() {
		super.updateConstraints()
		if constraintsIsLoaded == false {
			constraintsIsLoaded = true
			iconView.snp_makeConstraints(closure: { (make) in
				make.top.leading.equalTo(8)
			})
			contentLabel.snp_makeConstraints(closure: { (make) in
				make.leading.equalTo(iconView.snp_trailing).offset(8)
				make.top.equalTo(contentView).offset(8)
				make.trailing.bottom.equalTo(contentView).offset(-8)
			})
		}
	}
	
	override class func requiresConstraintBasedLayout() -> Bool {
		return true
	}
	
}
class AIProductQuestionCell: AIProductQACell {
	override func setup() {
		super.setup()
		iconView.image = UIImage(named: "q-icon")
		contentLabel.textColor = UIColor.whiteColor()
		contentLabel.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(48))
	}
}
class AIProductAnswerCell: AIProductQACell {
	override func setup() {
		super.setup()
		iconView.image = UIImage(named: "a-icon")
		contentLabel.textColor = UIColor (red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
		contentLabel.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(42))
	}
}
