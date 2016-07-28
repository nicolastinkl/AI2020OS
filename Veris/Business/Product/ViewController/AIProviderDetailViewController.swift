//
//  AIProviderDetailViewController.swift
//  AIVeris
//
//  Created by zx on 7/21/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIProviderDetailViewController: UIViewController {
	
	@IBOutlet var clearViews: [UIView]!
	@IBOutlet var halfWhiteClearViews: [UIView]!
	@IBOutlet var whiteLabels: [UILabel]!
	@IBOutlet var halfWhiteLabels: [UILabel]!
	@IBOutlet var bubbleContainerView: UIView!
	
	var bubbleModels = [AIBuyerBubbleModel]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		setupNavigationItems()
		setupBubbleView()
	}
	
	func fakeBubbleModels() {
//        let rootVC =
	}
	
	func setupBubbleView() {
		fakeBubbleModels()
		for i in 0..<min(4, bubbleModels.count) {
			let model: AIBuyerBubbleModel! = bubbleModels[i]
			let marginLeft = AITools.displaySizeFrom1242DesignSize(34)
			let space = AITools.displaySizeFrom1242DesignSize(15)
			let bubbleWidth = (screenWidth - marginLeft * 2 - space * 3) / 4
			model.bubbleSize = Int(bubbleWidth) / 2
			let bubbleView = AIBubble(center: .zero, model: model, type: model.bubbleType, index: 0)
			bubbleView.tag = i
			bubbleContainerView.addSubview(bubbleView)
			
			let bubbleY = AITools.displaySizeFrom1242DesignSize(87)
			bubbleView.frame = CGRect(x: marginLeft + CGFloat(i) * (bubbleWidth + space), y: bubbleY, width: bubbleWidth, height: bubbleWidth)
		}
	}
	func setupUI() {
		clearViews.forEach { (v) in
			v.backgroundColor = UIColor.clearColor()
		}
		
		halfWhiteClearViews.forEach { (v) in
			v.backgroundColor = UIColor(hexString: "#ecedf9", alpha: 0.2)
		}
		
		whiteLabels.forEach { (l) in
			l.textColor = UIColor.whiteColor()
		}
		
		halfWhiteLabels.forEach { (l) in
			l.textColor = UIColor(hexString: "#ffffff", alpha: 0.6)
		}
	}
	
	func setupNavigationItems() {
		extendedLayoutIncludesOpaqueBars = true
		
		let backButton = UIButton()
		backButton.setImage(UIImage(named: "comment-back"), forState: .Normal)
		backButton.addTarget(self, action: #selector(UIViewController.dismiss), forControlEvents: .TouchUpInside)
		
		let followButton = UIButton()
		followButton.setTitle("+ 关注", forState: .Normal)
		followButton.titleLabel?.font = UIFont.systemFontOfSize(42.displaySizeFrom1242DesignSize())
		followButton.setTitleColor(UIColor(hexString: "#ffffff", alpha: 0.6), forState: .Normal)
		followButton.backgroundColor = UIColor.clearColor()
		followButton.layer.cornerRadius = 12.displaySizeFrom1242DesignSize()
		followButton.layer.borderColor = UIColor(hexString: "#6b6a6d").CGColor
		followButton.layer.borderWidth = 2.displaySizeFrom1242DesignSize()
		followButton.setSize(CGSize(width: 196.displaySizeFrom1242DesignSize(), height: 80.displaySizeFrom1242DesignSize()))
		
		let appearance = UINavigationBarAppearance()
		appearance.leftBarButtonItems = [backButton]
		appearance.rightBarButtonItems = [followButton]
		appearance.itemPositionForIndexAtPosition = { index, position in
			if position == .Left {
				return (47.displaySizeFrom1242DesignSize(), 55.displaySizeFrom1242DesignSize())
			} else {
				return (47.displaySizeFrom1242DesignSize(), 40.displaySizeFrom1242DesignSize())
			}
		}
		appearance.barOption = UINavigationBarAppearance.BarOption(backgroundColor: UIColor.clearColor(), backgroundImage: nil, removeShadowImage: true, height: AITools.displaySizeFrom1242DesignSize(192))
		setNavigationBarAppearance(navigationBarAppearance: appearance)
	}
}
