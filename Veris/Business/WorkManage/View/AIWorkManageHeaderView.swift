//
//  AIWorkManageHeaderView.swift
//  AIVeris
//
//  Created by zx on 8/3/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIWorkManageHeaderView: UIView {
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	var filterColors = [
		UIColor(hexString: "#7b3990", alpha: 0.7),
		UIColor(hexString: "#1c789f", alpha: 0.7),
		UIColor(hexString: "#619505", alpha: 0.7),
		UIColor(hexString: "#f79a00", alpha: 0.7),
		UIColor(hexString: "#b32b1d", alpha: 0.7),
	]
	
	var closeWidth: CGFloat = 100
	var openWidth: CGFloat = 200
	var index = 0 {
		didSet {
			updateConstraints()
			layoutIfNeeded()
		}
	}
	
	var cardViews: [AIWorkManageHeaderCardView] = []
	
	func setup() {
		backgroundColor = UIColor.clearColor()
		for i in 0...4 {
			let card = AIWorkManageHeaderCardView.initFromNib() as! AIWorkManageHeaderCardView
			card.color = filterColors[i]
			card.tag = i
			addSubview(card)
			cardViews.append(card)
			
			card.snp_makeConstraints(closure: { (make) in
				make.leading.equalTo(CGFloat(i) * closeWidth)
				make.top.bottom.equalTo(self)
				make.width.equalTo(openWidth)
			})
		}
	}
	
	override func updateConstraints() {
		super.updateConstraints()
        cardViews.forEach { (card) in
            let i = card.tag
            card.snp_updateConstraints(closure: { (make) in
                make.
            })
        }
	}
}

class AIWorkManageHeaderCardView: UIView {
	var color: UIColor? {
		didSet {
			
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
