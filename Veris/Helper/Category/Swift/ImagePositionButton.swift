//
//  ImagePositionButton.swift
//
//
//  Created by zx on 7/4/16.
//  Copyright © 2016 zx. All rights reserved.
//

import UIKit

@IBDesignable
class ImagePositionButton: UIButton {
	
	override func intrinsicContentSize() -> CGSize {
		let intrinsicContentSize = super.intrinsicContentSize()
		
		switch titlePosition {
		case .Top: fallthrough
		case .Bottom:
			let adjustedWidth = intrinsicContentSize.width + titleEdgeInsets.left + titleEdgeInsets.right + imageEdgeInsets.left + imageEdgeInsets.right
			let adjustedHeight = intrinsicContentSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom + imageEdgeInsets.top + imageEdgeInsets.bottom
			
			return CGSize(width: adjustedWidth, height: adjustedHeight)
		case .Left: fallthrough
		case .Right: fallthrough
		default:
			let adjustedWidth = intrinsicContentSize.width + titleEdgeInsets.left + titleEdgeInsets.right + imageEdgeInsets.left + imageEdgeInsets.right
			let adjustedHeight = intrinsicContentSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom + imageEdgeInsets.top + imageEdgeInsets.bottom
			
			return CGSize(width: adjustedWidth, height: adjustedHeight)
		}
		
	}
	
	@IBInspectable
	var titlePositionString: String = "right" {
		didSet {
			switch titlePositionString {
			case "right":
				titlePosition = .Right
			case "left":
				titlePosition = .Left
			case "top":
				titlePosition = .Top
			case "bottom":
				titlePosition = .Bottom
			default: break
			}
		}
	}
	
	var titlePosition: UIViewContentMode = .Right {
		didSet {
			updateImageInset()
		}
	}
	
	@IBInspectable var spacing: CGFloat = 0 {
		didSet {
			updateImageInset()
		}
	}
	
	func updateImageInset() {
		if let title = currentTitle {
			positionLabelRespectToImage(title, position: titlePosition, spacing: spacing)
		}
	}
	
	override func setImage(image: UIImage?, forState state: UIControlState) {
		super.setImage(image, forState: state)
//		updateImageInset()
	}
	
	override func setTitle(title: String?, forState state: UIControlState) {
		super.setTitle(title, forState: state)
		updateImageInset()
	}
	
	private func positionLabelRespectToImage(title: String, position: UIViewContentMode, spacing: CGFloat) {
		let imageFrame = imageRectForContentRect(frame)
		let titleFont = titleLabel?.font!
		let titleFrame = title.sizeWithAttributes([NSFontAttributeName: titleFont!])
		
		var titleEdgeInsets: UIEdgeInsets
		var imageEdgeInsets: UIEdgeInsets
		
		switch position {
		case .Top:
			titleEdgeInsets = UIEdgeInsets(top: -(imageFrame.height + titleFrame.height + spacing), left: -(imageFrame.width), bottom: 0, right: 0)
			imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleFrame.width)
		case .Bottom:
			titleEdgeInsets = UIEdgeInsets(top: (imageFrame.height + titleFrame.height + spacing), left: -(imageFrame.width), bottom: 0, right: 0)
			imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleFrame.width)
		case .Left:
			titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageFrame.width * 2), bottom: 0, right: 0)
			imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleFrame.width * 2 + spacing))
		case .Right:
			titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
			imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		default:
			titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
			imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		}
		
		self.titleEdgeInsets = titleEdgeInsets
		self.imageEdgeInsets = imageEdgeInsets
		invalidateIntrinsicContentSize()
	}
}
