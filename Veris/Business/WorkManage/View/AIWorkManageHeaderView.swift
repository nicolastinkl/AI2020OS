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
	
	var cardViews = [UIView]()
	
	func setup() {
        backgroundColor = UIColor.clearColor()
		for i in 0...4 {
			let card = UIView()
			card.backgroundColor = filterColors[i]
			addSubview(card)
			
			card.snp_makeConstraints(closure: { (make) in
				make.leading.equalTo(CGFloat(i) * closeWidth)
				make.top.bottom.equalTo(self)
				make.width.equalTo(openWidth)
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
