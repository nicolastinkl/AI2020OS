//
//  AIWorkManageHeaderView.swift
//  AIVeris
//
//  Created by zx on 8/3/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

protocol AIWorkManageHeaderViewDelegate: NSObjectProtocol {
	func headerView(headerView: AIWorkManageHeaderView, didClickAtIndex index: Int)
}

class AIWorkManageHeaderView: UIView {
	
	var openWidth: CGFloat = 135
	weak var delegate: AIWorkManageHeaderViewDelegate?
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	private var filterColors = [
		UIColor(hexString: "#7b3990", alpha: 0.7),
		UIColor(hexString: "#1c789f", alpha: 0.7),
		UIColor(hexString: "#619505", alpha: 0.7),
		UIColor(hexString: "#f79a00", alpha: 0.7),
		UIColor(hexString: "#b32b1d", alpha: 0.7),
	]
	
	private var index = 0
	private var cardViews: [AIWorkManageHeaderCardView] = []
	private var cardSpaceViews: [UIView] = []
	
	private func setup() {
		backgroundColor = UIColor.clearColor()
		for i in 0...4 {
			let card = AIWorkManageHeaderCardView.initFromNib() as! AIWorkManageHeaderCardView
			card.filterColor = filterColors[i]
			card.leftText = "\(i + 1)"
			if i == 0 {
				card.imageView.contentMode = .Left
			}
			
			let tap = UITapGestureRecognizer(target: self, action: #selector(AIWorkManageHeaderView.cardViewTapped(_:)))
			card.addGestureRecognizer(tap)
			card.tag = i
			addSubview(card)
			cardViews.append(card)
			
		}
		
		for i in 0...5 {
			let space = UIView()
			space.tag = i
			addSubview(space)
			cardSpaceViews.append(space)
		}
		
		setIndex(0)
	}
	
	func setIndex(index: Int, animated: Bool = false) {
		self.index = index
		func updateLastTwoCard() {
			if index < 3 {
				cardViews[3].smallLabelsVisible = false
				cardViews[4].smallLabelsVisible = false
			} else {
				cardViews[3].smallLabelsVisible = index == 3
				cardViews[4].smallLabelsVisible = index == 4
			}
		}
		if animated {
			updateConstraints()
			setNeedsLayout()
			UIView.animateWithDuration(0.25, animations: {
				updateLastTwoCard()
				self.layoutIfNeeded()
			})
		} else {
			updateLastTwoCard()
			updateConstraints()
			setNeedsLayout()
			layoutIfNeeded()
		}
	}
	
	func cardViewTapped(tap: UITapGestureRecognizer) {
		let i = tap.view!.tag
		if index == i {
			delegate?.headerView(self, didClickAtIndex: i)
		} else {
			setIndex(i, animated: true)
		}
	}
	
	override func updateConstraints() {
		super.updateConstraints()
		cardViews.forEach { (card) in
			let i = card.tag
			card.snp_updateConstraints(closure: { (make) in
				make.left.equalTo(cardSpaceViews[i])
				make.right.equalTo(cardSpaceViews[i + 1])
				make.top.bottom.equalTo(self)
			})
		}
		
		cardSpaceViews.forEach { (space) in
			let i = space.tag
			space.snp_updateConstraints(closure: { (make) in
				make.width.equalTo(0)
				make.left.equalTo(cardSpaceViewPosition(i))
				make.top.bottom.equalTo(self)
			})
		}
	}
	
	// MARK: - helper
	func cardSpaceViewPosition(i: Int) -> CGFloat {
		var defaultPositions: [CGFloat] = [
			0,
			405,
			705,
			951,
			1120,
			1242,
		].map { $0.displaySizeFrom1242DesignSize() }
		
		var result: CGFloat = 0
		
		if i <= index {
			result = defaultPositions[i + 1] - openWidth
		} else {
			result = defaultPositions[i]
		}
		
		return result
	}
}

class AIWorkManageHeaderCardView: UIView {
	
	@IBOutlet weak var leftLabelPinLeftConstraint: NSLayoutConstraint!
	@IBOutlet weak var leftLabelCenterConstraint: NSLayoutConstraint!
	@IBOutlet weak var filterView: UIView!
	@IBOutlet weak var leftLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subTitleLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	var filterColor: UIColor? {
		didSet {
			filterView?.backgroundColor = filterColor
		}
	}
	
	var leftText: String? {
		didSet {
			leftLabel?.text = leftText
		}
	}
	
	var titleText: String? {
		didSet {
			titleLabel?.text = titleText
		}
	}
	
	var subTitle: String? {
		didSet {
			subTitleLabel?.text = subTitle
		}
	}
	
	var smallLabelsVisible: Bool = true {
		didSet {
			titleLabel?.alpha = smallLabelsVisible ? 1 : 0
			subTitleLabel?.alpha = smallLabelsVisible ? 1 : 0
            leftLabelPinLeftConstraint?.active = smallLabelsVisible
            leftLabelCenterConstraint?.active = !smallLabelsVisible
		}
	}
}
