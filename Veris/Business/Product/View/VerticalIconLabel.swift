//
// VerticalIconLabel.swift
// AIVeris
//
// Created by admin on 1/5/16.
// Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit
import SnapKit

class VerticalIconLabel: UIView {
	
	var imageSpaceToLabel: CGFloat = 4 {
		didSet {
			setNeedsLayout()
			layoutIfNeeded()
		}
	}
	
	var textColor = UIColor.whiteColor() {
		didSet {
			label.textColor = textColor
		}
	}
	
	var image: UIImage? {
		set {
			self.imageView.image = newValue
		}
		get {
			return self.imageView.image
		}
	}
	
	var text: String? {
		set {
			self.label.text = newValue
			setNeedsLayout()
			layoutIfNeeded()
		}
		get {
			return self.label.text
		}
	}
	var imageWidth: CGFloat = AITools.displaySizeFrom1080DesignSize(54) {
		didSet {
			setNeedsLayout()
			layoutIfNeeded()
		}
	}
    
    var font: UIFont = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(42)) {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
	
    
	lazy var imageView: UIImageView = { [unowned self] in
		let result = UIImageView()
		self.addSubview(result)
		return result
	}()
	
	lazy var label: UILabel = { [unowned self] in
		let result = UILabel()
		result.font = self.font
		result.textColor = self.textColor
		result.textAlignment = .Center
		self.addSubview(result)
		return result
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	override var frame: CGRect {
		didSet {
			setNeedsLayout()
			layoutIfNeeded()
		}
	}
	
	override func layoutSubviews() {
		label.sizeToFit()
        label.setHeight(label.height + 3) // label 字母被切掉了一部分
		let imageViewX = width / 2 - imageWidth / 2
		let imageViewY = height / 2 - imageWidth / 2 - imageSpaceToLabel / 2 - label.height / 2
        let labelY = imageViewY + imageWidth + imageSpaceToLabel
		
		imageView.frame = CGRectMake(imageViewX, imageViewY, imageWidth, imageWidth)
		label.frame = CGRectMake(0, labelY, width, label.height)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
