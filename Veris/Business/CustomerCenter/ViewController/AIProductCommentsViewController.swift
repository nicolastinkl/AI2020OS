//
//  AIProductCommentsViewController.swift
//  AIVeris
//
//  Created by zx on 6/29/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIProductCommentsViewController: UIViewController {
	var service_id: Int!
	
	var comments: [AIProductComment] = []
	var tableView: UITableView!
	var filterBar: AIFilterBar!
	var commentsNumbers = [
		"0",
		"0",
		"0",
		"0",
		"0",
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		edgesForExtendedLayout = .None
		view.backgroundColor = UIColor.clearColor()
		setupNavigtionItems()
		fetchNumbers()
	}
	
	func setupNavigtionItems() {
		setupNavigationBarLikeQA(title: "Comments")
	}
	
	func fetchNumbers() {
		AIProductAllCommentsService().queryRatingStatistics(service_id, success: { [weak self](res) in
			self?.commentsNumbers = res
			self?.setupFilterBar()
			self?.setupTableView()
			self?.fetchComments()
		}) { (errType, errDes) in
		}
	}
	
	func fetchComments() {
		let service = AIProductAllCommentsService()
		service.queryAllComments(service_id, filter_type: filterBar.selectedIndex + 1, page_size: 20, page_number: 1, success: { [weak self](res) in
			self?.comments = res
			self?.tableView.reloadData()
		}) { (errType, errDes) in
		}
	}
	
	func setupFilterBar() {
		let titles = [
			"全部",
			"好评",
			"中评",
			"差评",
			"晒图"
		]
		
		filterBar = AIFilterBar(titles: titles, subtitles: commentsNumbers)
		filterBar.selectedIndex = 0
		filterBar.delegate = self
		view.addSubview(filterBar)
		filterBar.snp_makeConstraints { (make) in
			make.top.leading.trailing.equalTo(view)
			make.height.equalTo(AITools.displaySizeFrom1242DesignSize(143))
		}
	}
	
	func setupTableView() {
		tableView = UITableView(frame: .zero, style: .Plain)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.backgroundColor = UIColor.clearColor()
		tableView.tableFooterView = UIView()
		tableView.separatorStyle = UITableViewCellSeparatorStyle.None
		view.addSubview(tableView)
		
		tableView.registerClass(AIProductCommentCell.self, forCellReuseIdentifier: "cell")
		tableView.snp_makeConstraints { (make) in
			make.top.equalTo(filterBar.snp_bottom)
			make.bottom.leading.trailing.equalTo(view)
		}
	}
}

// MARK: - UITableViewDataSource
extension AIProductCommentsViewController: UITableViewDataSource {
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return comments.count
	}
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cells = tableView.dequeueReusableCellWithIdentifier("cell") as? AIProductCommentCell
		
		guard (cells) != nil else {
			cells = AIProductCommentCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
			return cells!
		}
		cells?.setup(comments[indexPath.row])
		return cells ?? UITableViewCell()
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return AIProductCommentCell.getheight(comments[indexPath.row])
	}
}

// MARK: - UITableViewDelegate
extension AIProductCommentsViewController: UITableViewDelegate {
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
	}
}

extension AIProductCommentsViewController: AIFilterBarDelegate {
	func filterBar(filterBar: AIFilterBar, didSelectIndex: Int) {
		fetchComments()
	}
}

protocol AIFilterBarDelegate: NSObjectProtocol {
	func filterBar(filterBar: AIFilterBar, didSelectIndex: Int)
}

class AIFilterBar: UIView {
	var titles: [String] {
		didSet {
			updateUI()
		}
	}
	var subtitles: [String] {
		didSet {
			updateUI()
		}
	}
	private var buttons: [FilterBarButton] = []
	weak var delegate: AIFilterBarDelegate?
	var selectedIndex = 0 {
		didSet {
			updateUI()
		}
	}
	
	func updateUI() {
		buttons.forEach { (button) in
			if button.tag == selectedIndex {
				button.selected = true
			} else {
				button.selected = false
			}
		}
	}
	
	init(titles: [String], subtitles: [String]) {
		self.titles = titles
		self.subtitles = subtitles
		super.init(frame: .zero)
		setup()
	}
	
	func setup() {
		let count = titles.count
		for i in 0..<count {
			let title = titles[i]
			let subtitle = subtitles[i]
			let button = FilterBarButton(title: title, subtitle: subtitle)
			let tap = UITapGestureRecognizer(target: self, action: #selector(AIFilterBar.buttonPressed(_:)))
			button.addGestureRecognizer(tap)
			button.tag = i
			addSubview(button)
			buttons.append(button)
		}
		
		var previousButton: FilterBarButton!
        
        for (i, button) in buttons.enumerate() {
			button.snp_makeConstraints(closure: { (make) in
				if i == 0 {
					make.leading.top.bottom.equalTo(self)
				} else if i < buttons.count - 1 {
					make.leading.equalTo(previousButton.snp_trailing)
					make.width.equalTo(previousButton)
					make.height.equalTo(previousButton)
				} else {
					make.trailing.equalTo(self)
					make.leading.equalTo(previousButton.snp_trailing)
					make.width.equalTo(previousButton)
					make.height.equalTo(previousButton)
				}
			})
			previousButton = button
		}
		
	}
	
	func buttonPressed(tap: UITapGestureRecognizer) {
		let index = tap.view!.tag
		selectedIndex = index
		delegate?.filterBar(self, didSelectIndex: index)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override class func requiresConstraintBasedLayout() -> Bool {
		return true
	}
	
	class FilterBarButton: UIView {
		var title: String
		var subtitle: String
		var normalBackgroundColor = UIColor(hexString: "#d6d8fd", alpha: 0.15)
		var selectedBackgroundColor = UIColor(hexString: "#d6d8fd", alpha: 0.3)
		var selected = false {
			didSet {
				backgroundColor = selected ? selectedBackgroundColor : normalBackgroundColor
			}
		}
		
		override class func requiresConstraintBasedLayout() -> Bool {
			return true
		}
		
		private var titleLabel: UILabel!
		private var subtitleLabel: UILabel!
		
		struct Constants {
			static let titleFont = AITools.myriadSemiboldSemiCnWithSize(AITools.displaySizeFrom1242DesignSize(48))
			static let subtitleFont = AITools.myriadSemiboldSemiCnWithSize(AITools.displaySizeFrom1242DesignSize(42))
			static let titleColor = UIColor.whiteColor()
			static let subtitleColor = UIColor (red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
		}
		
		init(title: String, subtitle: String) {
			self.title = title
			self.subtitle = subtitle
			super.init(frame: .zero)
			setup()
		}
		
		func setup() {
			backgroundColor = normalBackgroundColor
			titleLabel = UILabel.label(Constants.titleFont, textColor: Constants.titleColor)
			titleLabel.text = title
			
			subtitleLabel = UILabel.label(Constants.subtitleFont, textColor: Constants.subtitleColor)
			subtitleLabel.text = subtitle
			
			addSubview(titleLabel)
			addSubview(subtitleLabel)
			
			titleLabel.snp_makeConstraints { (make) in
				make.bottom.equalTo(self.snp_centerY).offset(-4)
				make.centerX.equalTo(self)
			}
			
			subtitleLabel.snp_makeConstraints { (make) in
				make.top.equalTo(self.snp_centerY).offset(4)
				make.centerX.equalTo(self)
			}
		}
		
		required init?(coder aDecoder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
	}
}

class AIProductCommentCell: UITableViewCell {
	
	var commentInfoView: AICommentInfoView!
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		selectionStyle = .None
		backgroundColor = UIColor.clearColor()
		commentInfoView = AICommentInfoView.initFromNib() as! AICommentInfoView
		contentView.addSubview(commentInfoView)
		commentInfoView.initSubviews()
		commentInfoView.snp_makeConstraints { (make) in
			make.edges.equalTo(contentView)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	internal override class func requiresConstraintBasedLayout() -> Bool {
		return true
	}
	
	class func getheight(model: AIProductComment) -> CGFloat {
		
		let offSetWidth: CGFloat = 5
		var selfHeight: CGFloat = 34.0
		let imageViewWidth: CGFloat = 70
		
		// count text
		selfHeight +=
			model.comment?.sizeWithFont(AITools.myriadBoldWithSize(15), forWidth: UIScreen.mainScreen().bounds.width).height ?? 0
		
		if let urls = model.photos {
			
			let intPers = Int(UIScreen.mainScreen().bounds.width / imageViewWidth)
			let pers = CGFloat(urls.count) / CGFloat(intPers)
			let persInt = Int(urls.count) / intPers
			if pers > CGFloat(persInt) {
				selfHeight += (imageViewWidth + offSetWidth) * (CGFloat)(persInt + 1)
			} else {
				selfHeight += (imageViewWidth + offSetWidth) * (CGFloat)(persInt)
			}
		} else {
			selfHeight += 0
		}
		
		selfHeight += 40
		return selfHeight
	}
	
	func setup(model: AIProductComment) {
        var newModel = AICommentInfoModel()
        newModel.images = model.photos as? [[String: String]]
        newModel.commentcount = model.replying_count
        newModel.commentid = model.customer_id
        newModel.descripation = model.comment
        newModel.providename = model.customer.name
        newModel.provideurl = model.customer.portrait_icon
        newModel.like = model.supporting_count
        if model.rating_level != nil {
            newModel.level = model.rating_level.toInt() ?? 0
        } else {
            newModel.level = 0
        }
		commentInfoView.fillDataWithModel(newModel)
	}
}
