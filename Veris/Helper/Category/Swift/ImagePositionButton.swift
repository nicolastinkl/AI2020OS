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
        var result = super.intrinsicContentSize()
        switch titlePosition {
        case .Top: fallthrough
        case .Bottom:
            result.height += spacing
        case .Left: fallthrough
        case .Right:
            result.width += spacing
        default:
            break
        }

        
        return result
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
		updateImageInset()
	}
	
	override func setTitle(title: String?, forState state: UIControlState) {
		super.setTitle(title, forState: state)
		updateImageInset()
	}
	
	private func positionLabelRespectToImage(title: String, position: UIViewContentMode, spacing: CGFloat) {
		let imageSize = imageRectForContentRect(frame)
		let titleFont = titleLabel?.font!
		let titleSize = title.sizeWithAttributes([NSFontAttributeName: titleFont!])
		
		var titleEdgeInsets: UIEdgeInsets
		var imageEdgeInsets: UIEdgeInsets
		
		switch position {
		case .Top:
			titleEdgeInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing), left: -(imageSize.width), bottom: 0, right: 0)
			imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
		case .Bottom:
			titleEdgeInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing), left: -(imageSize.width), bottom: 0, right: 0)
			imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
		case .Left:
			titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
			imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize.width * 2 + spacing))
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
