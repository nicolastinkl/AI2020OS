//
//  AISearchHistoryIconView.swift
//  AIVeris
//
//  Created by zx on 6/22/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AISearchHistoryIconView: UIView {
	var items: [(image: String, title: String)]!
	
	private var titleLabel: UILabel!
	private var iconContainerView: UIView!
	private var iconLabels = [VerticalIconLabel]()
	private var _width: CGFloat!
	
	struct Constants {
		static let height: CGFloat = AITools.displaySizeFrom1242DesignSize(476)
		static let titleLabelSpace: CGFloat = AITools.displaySizeFrom1242DesignSize(28)
		static let titleLabelHeight: CGFloat = AITools.displaySizeFrom1242DesignSize(28 + Constants.titleLabelFontSize)
		static let titleLabelFontSize: CGFloat = AITools.displaySizeFrom1242DesignSize(48)
		static let titleLabelFont: UIFont = AITools.myriadSemiboldSemiCnWithSize(Constants.titleLabelFontSize)
	}
	
	convenience init(items: [(image: String, title: String)], width: CGFloat) {
		self.init(frame: .zero)
		self.frame = CGRect(x: 0, y: 0, width: width, height: Constants.height)
		self._width = width
		self.items = items
		setup()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		let _height = Constants.height
		
		// setup title label
		titleLabel = UILabel()
		titleLabel.text = "You recently searched"
		titleLabel.textColor = UIColor.whiteColor()
		titleLabel.font = Constants.titleLabelFont
		titleLabel.sizeToFit()
		titleLabel.setLeft(10)
		addSubview(titleLabel)
		
		// setup icon container view
		iconContainerView = UIView()
		iconContainerView.backgroundColor = UIColor (red: 1.0, green: 1.0, blue: 1.0, alpha: 0.15)
		iconContainerView.frame = CGRect(x: 0, y: titleLabel.bottom + Constants.titleLabelSpace, width: _width, height: _height - titleLabel.height - Constants.titleLabelSpace)
		addSubview(iconContainerView)
		
		// setup icon labels
		let labelWidth = _width / 4
		let labelHeight = _height - Constants.titleLabelFontSize
		
		for (i, item) in items.enumerate() {
			let frame = CGRect(x: labelWidth * CGFloat(i), y: 0, width: labelWidth, height: labelHeight)
			let iconLabel = VerticalIconLabel(frame: frame)
			iconLabel.imageWidth = AITools.displaySizeFrom1242DesignSize(194)
			iconLabel.label.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(28))
			iconLabel.imageSpaceToLabel = AITools.displaySizeFrom1242DesignSize(34)
			iconLabel.tag = i
			iconLabel.text = item.title
			if let image = UIImage(named: item.image) {
				iconLabel.image = image
			} else if let imageURL = NSURL(string: item.image) {
				iconLabel.imageView.asyncLoadImage(imageURL.absoluteString)
			}
			iconContainerView.addSubview(iconLabel)
		}
	}
	
}
