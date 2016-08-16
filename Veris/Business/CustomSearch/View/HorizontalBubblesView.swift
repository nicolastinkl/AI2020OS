//
//  FourBubbleView.swift
//  AIVeris
//
//  Created by zx on 8/9/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

// AISearchServiceModel
extension AIBuyerBubbleModel {
	class func convertFrom(serviceModels: [AISearchServiceModel]) -> [AIBuyerBubbleModel] {
		let deepColor = ["ca9e82", "936d4c", "aa6e28", "574d71", "7e3d60", "438091", "ad2063", "5f257d", "162c18", "B10000", "4a5679", "6b4a1d", "1b1a3a", "aa6e28", "6a8e5c", "", "", "", ""]
		let undertoneColor = ["5198ac", "ae9277", "cdaf13", "696a9a", "c3746a", "6c929f", "cf4e5a", "9c417c", "32542c", "F25A68", "7e6479", "aa822a", "81476a", "cdaf13", "93a44b", "", "", "", ""]
		let borderColor = ["9bd6f2", "f8b989", "fee34a", "8986c2", "f88d8e", "6db8d5", "ef6d83", "cd53e1", "528319", "F25A68", "8986c2", "e6ad44", "c474ac", "fee34a", "93bd78", "", "", "", ""]
		
		var result = [AIBuyerBubbleModel]()
		for i in 0..<serviceModels.count {
			let bubble = AIBuyerBubbleModel()
			bubble.deepColor = deepColor[i]
			bubble.undertoneColor = undertoneColor[i]
			bubble.borderColor = borderColor[i]
			
			let model = serviceModels[i]
			bubble.proposal_id = model.id
			bubble.proposal_name = model.name
			bubble.proposal_price = model.price?.price_show
			bubble.service_list = (model.sub_service_list as! [AISearchServiceModel]).map({ (service) -> AIProposalServiceModel in
				let result = AIProposalServiceModel()
				result.service_id = service.id
				result.service_thumbnail_icon = service.icon
				return result
			})
			result.append(bubble)
		}
		return result
	}
}

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
