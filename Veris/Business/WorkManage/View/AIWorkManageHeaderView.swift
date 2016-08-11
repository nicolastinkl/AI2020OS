//
//  AIWorkManageHeaderView.swift
//  AIVeris
//
//  Created by zx on 8/3/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIWorkManageHeaderView: UIView {
	
	var closeWidth: CGFloat = 100
	var openWidth: CGFloat = 202
    
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
	
	private func setup() {
		backgroundColor = UIColor.clearColor()
		for i in 0...4 {
			let card = AIWorkManageHeaderCardView.initFromNib() as! AIWorkManageHeaderCardView
			card.filterColor = filterColors[i]
			let tap = UITapGestureRecognizer(target: self, action: #selector(AIWorkManageHeaderView.cardViewTapped(_:)))
			card.addGestureRecognizer(tap)
			card.tag = i
			addSubview(card)
			cardViews.append(card)
		}
	}
	
	func setIndex(index: Int, animated: Bool = false) {
		self.index = index
		if animated {
			updateConstraints()
			setNeedsLayout()
			UIView.animateWithDuration(0.25, animations: {
				self.layoutIfNeeded()
			})
		} else {
			updateConstraints()
			setNeedsLayout()
			layoutIfNeeded()
		}
	}
	
	func cardViewTapped(tap: UITapGestureRecognizer) {
		let i = tap.view!.tag
		setIndex(i, animated: true)
	}
	
	override func updateConstraints() {
		super.updateConstraints()
		cardViews.forEach { (card) in
			let i = card.tag
			card.snp_updateConstraints(closure: { (make) in
				make.width.equalTo(cardWidth(cardIndex: i))
				make.left.equalTo(cardLeft(cardIndex: i))
				make.top.bottom.equalTo(self)
			})
		}
	}
	
	// MARK: - helper
	func cardLeft(cardIndex i: Int) -> CGFloat {
		if i <= index {
			return CGFloat(i) * closeWidth
		} else {
			return openWidth + CGFloat(index) * closeWidth
		}
	}
	
	func cardWidth(cardIndex i: Int) -> CGFloat {
		if i == index {
			return openWidth
		} else {
			return closeWidth
		}
	}
}

class AIWorkManageHeaderCardView: UIView {
    
    @IBOutlet weak var filterView: UIView!
    
	var filterColor: UIColor? {
		didSet {
			filterView?.backgroundColor = filterColor
		}
	}
	var leftText: String? {
		didSet {
			
		}
	}
	var titleText: String? {
		didSet {
			
		}
	}
	var subTitle: String? {
		didSet {
			
		}
	}
	var imageView: UIImageView! {
		didSet {
			
		}
	}
}
