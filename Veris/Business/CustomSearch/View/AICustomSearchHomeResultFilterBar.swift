//
//  AICutomSearchHomeResultFilterBar.swift
//  AIVeris
//
//  Created by zx on 7/4/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

enum FilterType: Int {
	case None = -1
	case Sort = 100
	case Price
	case Filter
}

protocol AICustomSearchHomeResultFilterBarDelegate: NSObjectProtocol {
	func customSearchHomeResultFilterBar(filterBar: AICustomSearchHomeResultFilterBar, didSelectType type: FilterType, index: Int)
}

class AICustomSearchHomeResultFilterBar: UIView {
	
	weak var delegate: AICustomSearchHomeResultFilterBarDelegate?
	
	@IBOutlet private var filterButtons: [ImagePositionButton]!
	@IBOutlet private var mainView: UIView!
	
	private lazy var dimView: UIView = { [unowned self] in
		let result = UIView()
		result.hidden = true
		let tap = UITapGestureRecognizer(target: self, action: #selector(AICustomSearchHomeResultFilterBar.dimViewTapped))
		result.addGestureRecognizer(tap)
		return result
	}()
	
	var filterTitles: [String]? {
		didSet {
			updateMenuViews()
		}
	}
	var priceTitles: [String]? {
		didSet {
			updateMenuViews()
		}
	}
	var sortTitles: [String]? {
		didSet {
			updateMenuViews()
		}
	}
	
	var menuViewTopSpace: CGFloat = 0 {
		didSet {
			if let menuContainerView = menuContainerView {
				dimView.snp_updateConstraints(closure: { (make) in
					make.top.equalTo(menuContainerView).offset(menuViewTopSpace)
				})
			}
		}
	}
	
	var menuContainerView: UIView? {
		didSet {
			if let menuContainerView = menuContainerView {
				dimView.removeFromSuperview()
				dimView.backgroundColor = UIColor(hexString: "#120f25", alpha: 0.8)
				menuContainerView.addSubview(dimView)
				dimView.snp_makeConstraints(closure: { (make) in
					make.edges.equalTo(menuContainerView)
				})
			} else {
				// nil
				dimView.removeFromSuperview()
			}
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		mainView.backgroundColor = UIColor.clearColor()
		backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.15)
		setupFilterButtons()
		updateMenuViews()
	}
	
	func updateMenuViews() {
		updateMenuView(type: .Sort, titles: filterTitles)
		updateMenuView(type: .Price, titles: priceTitles)
		updateMenuView(type: .Filter, titles: sortTitles)
	}
	
	func updateMenuView(type type: FilterType, titles: [String]?) {
		if let titles = titles {
			let someTypeOfMenuView = menuView(type: type)
			someTypeOfMenuView.titles = titles
		}
	}
	
	func setupFilterButtons() {
		for i in 0..<filterButtons.count {
			let b = filterButtons[i]
			b.titlePosition = .Left
			b.setImage(UIImage(named: "search-down"), forState: .Normal)
			b.titleLabel?.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(42))
			b.addTarget(self, action: #selector(AICustomSearchHomeResultFilterBar.filterButtonPressed(_:)), forControlEvents: .TouchUpInside)
			b.updateImageInset()
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initSelfFromXib()
	}
	
	// MARK: - target actions
	func dimViewTapped() {
		hideMenu()
	}
	
	func filterButtonPressed(sender: UIButton) {
		let type = FilterType(rawValue: sender.tag)!
		selectFilterButtonWith(type: type)
		showMenuView(type: type)
	}
	
	// MARK: - helper
	func hideMenu() {
		dimView.hidden = true
		selectFilterButtonWith(type: .None)
	}
	
	func menuView(type type: FilterType) -> AICustomSearchHomeResultFilterBarMenuView {
		if let result = dimView.viewWithTag(type.rawValue) {
			return result as! AICustomSearchHomeResultFilterBarMenuView
		} else {
			let result = AICustomSearchHomeResultFilterBarMenuView(frame: .zero)
			result.tag = type.rawValue
			result.delegate = self
			dimView.addSubview(result)
			result.snp_makeConstraints(closure: { (make) in
				make.top.leading.trailing.equalTo(dimView)
			})
			return result
		}
	}
	
	func selectFilterButtonWith(type type: FilterType) {
		filterButtons.forEach { (b) in
			b.setImage(UIImage(named: "search-down"), forState: .Normal)
			b.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		}
		if type != .None {
			let button = filterButtons[type.rawValue - 100]
			button.setImage(UIImage(named: "search-up"), forState: .Normal)
			button.setTitleColor(UIColor(hexString: "#e7c400"), forState: .Normal)
			let type = FilterType(rawValue: button.tag)!
			showMenuView(type: type)
		}
	}
	
	func showMenuView(type type: FilterType) {
		dimView.hidden = false
		menuContainerView?.bringSubviewToFront(dimView)
		dimView.subviews.forEach { (m) in
			// hide all menu view
			m.hidden = true
		}
		menuView(type: type).hidden = false
	}
}

extension AICustomSearchHomeResultFilterBar: AICustomSearchHomeResultFilterBarMenuViewDelegate {
	func customSearchHomeResultFilterBarMenuView(menuView: AICustomSearchHomeResultFilterBarMenuView, menuButtonDidClickAtIndex index: Int) {
		let type = FilterType(rawValue: menuView.tag)!
		delegate?.customSearchHomeResultFilterBar(self, didSelectType: type, index: index)
		menuView.index = index
	}
}

// MARK: - AICustomSearchHomeResultFilterBarMenuView

protocol AICustomSearchHomeResultFilterBarMenuViewDelegate: NSObjectProtocol {
	func customSearchHomeResultFilterBarMenuView(menuView: AICustomSearchHomeResultFilterBarMenuView, menuButtonDidClickAtIndex index: Int)
}

class AICustomSearchHomeResultFilterBarMenuView: UIView {
	
	weak var delegate: AICustomSearchHomeResultFilterBarMenuViewDelegate?
	
	var menuButtons: [UIButton] = []
	
	let buttonHeight = AITools.displaySizeFrom1242DesignSize(142)
	let buttonTitleMargin = AITools.displaySizeFrom1242DesignSize(50)
	
	var titles: [String] = [] {
		didSet {
			updateUI()
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
		let bg = UIImage(named: "search-filter-bar-bg")
		let bgImageView = UIImageView(image: bg)
		addSubview(bgImageView)
		bgImageView.snp_makeConstraints { (make) in
			make.edges.equalTo(self)
		}
	}
	
	func updateUI() {
		// clear all button
		menuButtons.forEach { (b) in
			b.removeFromSuperview()
		}
		menuButtons.removeAll()
		
		// setup buttons
		for i in 0..<titles.count {
			let title = titles[i]
			setupButton(title: title, index: i)
		}
	}
	
	func setupButton(title title: String, index: Int) {
		let result = UIButton()
		result.setTitle(title, forState: .Normal)
		result.contentHorizontalAlignment = .Left
		result.titleLabel!.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(48))
		result.setTitleColor(UIColor(hexString: "#ffffff"), forState: .Normal)
		let selectedBackgroundImage = UIImage.withColor(UIColor(hexString: "#b2a5f1", alpha: 0.20))
		result.setBackgroundImage(selectedBackgroundImage, forState: .Selected)
		
		// setup seperator line
		let line = UIView()
		line.backgroundColor = UIColor(hexString: "#ffffff", alpha: 0.12)
		result.addSubview(line)
		line.snp_makeConstraints { (make) in
			make.leading.trailing.bottom.equalTo(result)
			make.height.equalTo(AITools.displaySizeFrom1242DesignSize(3))
		}
		
		result.contentEdgeInsets = UIEdgeInsets(top: 0, left: buttonTitleMargin, bottom: 0, right: 0)
		result.tag = index
		result.addTarget(self, action: #selector(AICustomSearchHomeResultFilterBarMenuView.buttonPressed(_:)), forControlEvents: .TouchUpInside)
		menuButtons.append(result)
		addSubview(result)
		result.snp_makeConstraints { (make) in
			make.leading.trailing.equalTo(self)
			make.height.equalTo(buttonHeight)
			if index == 0 {
				make.top.equalTo(self)
			} else {
				make.top.equalTo(buttonHeight * CGFloat(index))
			}
			
			if index == titles.count - 1 {
				make.bottom.equalTo(self)
			}
		}
	}
	
	func buttonPressed(sender: UIButton) {
		delegate?.customSearchHomeResultFilterBarMenuView(self, menuButtonDidClickAtIndex: sender.tag)
	}
	
	var index: Int = -1 {
		didSet {
			if 0..<menuButtons.count ~= index {
				menuButtons.forEach({ (b) in
					b.selected = false
				})
				let button = menuButtons[index]
				button.selected = true
			}
		}
	}
}
