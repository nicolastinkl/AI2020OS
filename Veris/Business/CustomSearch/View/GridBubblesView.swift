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
			bubble.proposal_id = model.sid
			bubble.proposal_name = model.name
			bubble.proposal_price = model.price?.price_show
//                               model.proposal_price = modelJSON.price?.price_show ?? "" 
			if let sub_service_list = model.sub_service_list {
				bubble.service_list = (sub_service_list as! [AISearchServiceModel]).map({ (service) -> AIProposalServiceModel in
					let result = AIProposalServiceModel()
					result.service_id = service.sid
					result.service_thumbnail_icon = service.icon
					return result
				})
			}
            let selfIcon = AIProposalServiceModel()
            selfIcon.service_id = model.sid
            selfIcon.service_thumbnail_icon = model.icon
            bubble.service_list.insert(selfIcon, atIndex: 0)
			result.append(bubble)
		}
		return result
	}
}

@objc protocol GridBubblesViewDelegate: NSObjectProtocol {
	optional func bubblesView(bubblesView: GridBubblesView, didClickBubbleViewAtIndex index: Int)
}

class GridBubblesView: UIView {
    
	var bubbleModels: [AIBuyerBubbleModel]! {
		didSet {
			updateUI()
		}
	}
	
	private var bubbles: [AIBubble] = []
	weak var delegate: GridBubblesViewDelegate?
	
	convenience init(bubbleModels: [AIBuyerBubbleModel]) {
		self.init(frame: .zero)
		self.bubbleModels = bubbleModels
		updateUI()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	let marginLeft = AITools.displaySizeFrom1242DesignSize(34)
	let space = AITools.displaySizeFrom1242DesignSize(15)
    let bubbleY: CGFloat = 0
	
	func updateUI() {
		
		bubbles.forEach { (v) in
			v.removeFromSuperview()
		}
		bubbles.removeAll()
		
		let bubbleWidth = (screenWidth - marginLeft * 2 - space * 3) / 4
		let bubbleSize = Int(bubbleWidth) / 2
		let totalCount = bubbleModels.count
		
		for i in 0..<totalCount {
			let model: AIBuyerBubbleModel! = bubbleModels[i]
			model.bubbleSize = bubbleSize
			let bubbleView = AIBubble(center: .zero, model: model, type: Int(typeToNormal.rawValue), index: 0)
			bubbleView.tag = i
			bubbleView.userInteractionEnabled = true
			addSubview(bubbleView)
			bubbles.append(bubbleView)
			let tap = UITapGestureRecognizer(target: self, action: #selector(GridBubblesView.tapped(_:)))
			bubbleView.addGestureRecognizer(tap)
			
			let column = i % 4
			let row = i / 4
			bubbleView.frame = CGRect(x: marginLeft + CGFloat(column) * (bubbleWidth + space), y: bubbleY + CGFloat(row) * (bubbleWidth + space), width: bubbleWidth, height: bubbleWidth)
		}
		
		let totalRow = (totalCount / 4) + (((totalCount % 4) > 0) ? 1 : 0)
		
		frame = CGRect(x: 0, y: 0, width: screenWidth, height: CGFloat(totalRow) * (bubbleWidth + space) + bubbleY)
        invalidateIntrinsicContentSize()
	}
	
	func tapped(tap: UITapGestureRecognizer) {
		let index = tap.view!.tag
		delegate?.bubblesView?(self, didClickBubbleViewAtIndex: index)
	}
	
	override func intrinsicContentSize() -> CGSize {
		let bubbleWidth = (screenWidth - marginLeft * 2 - space * 3) / 4
		let totalCount = bubbleModels.count
		let totalRow = (totalCount / 4) + (((totalCount % 4) > 0) ? 1 : 0)
		let result = CGSize(width: screenWidth, height: CGFloat(totalRow) * (bubbleWidth + space) + bubbleY)
		return result
	}
}
