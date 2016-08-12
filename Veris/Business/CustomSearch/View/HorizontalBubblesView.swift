//
//  FourBubbleView.swift
//  AIVeris
//
//  Created by zx on 8/9/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

@objc protocol HorizontalBubblesViewDelegate: NSObjectProtocol {
	optional func bubblesView(bubblesView: HorizontalBubblesView, didClickBubbleViewAtIndex index: Int)
}

class HorizontalBubblesView: UIView {
	var bubbleModels: [AIBuyerBubbleModel] = []
	weak var delegate: HorizontalBubblesViewDelegate?
	
	convenience init(bubbleModels: [AIBuyerBubbleModel]) {
		self.init(frame: .zero)
		self.bubbleModels = bubbleModels
		setup()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
		let marginLeft = AITools.displaySizeFrom1242DesignSize(34)
		let space = AITools.displaySizeFrom1242DesignSize(15)
		let bubbleY = AITools.displaySizeFrom1242DesignSize(87)
		let bubbleWidth = (screenWidth - marginLeft * 2 - space * 3) / 4
		
		for i in 0..<min(4, bubbleModels.count) {
			let model: AIBuyerBubbleModel! = bubbleModels[i]
			model.bubbleSize = Int(bubbleWidth) / 2
			let bubbleView = AIBubble(center: .zero, model: model, type: model.bubbleType, index: 0)
			bubbleView.tag = i
            bubbleView.userInteractionEnabled = true
			addSubview(bubbleView)
			let tap = UITapGestureRecognizer(target: self, action: #selector(HorizontalBubblesView.tapped(_:)))
			bubbleView.addGestureRecognizer(tap)
			bubbleView.frame = CGRect(x: marginLeft + CGFloat(i) * (bubbleWidth + space), y: bubbleY, width: bubbleWidth, height: bubbleWidth)
		}
		frame = CGRect(x: 0, y: 0, width: screenWidth, height: bubbleWidth + bubbleY)
	}
	
	func tapped(tap: UITapGestureRecognizer) {
		let index = tap.view!.tag
		delegate?.bubblesView?(self, didClickBubbleViewAtIndex: index)
	}
}
