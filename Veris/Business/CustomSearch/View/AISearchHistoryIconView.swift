//
//  AISearchHistoryIconView.swift
//  AIVeris
//
//  Created by zx on 6/22/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

protocol AISearchHistoryIconViewDelegate: NSObjectProtocol {
	func searchHistoryIconView(iconView: AISearchHistoryIconView, didClickAtIndex index: Int)
}

class AISearchHistoryIconView: UIView {
	weak var delegate: AISearchHistoryIconViewDelegate?
    var items: [AISearchServiceModel]! {
        didSet {
            updateUI()
        }
    }
	
	private var titleLabel: UILabel!
	private var iconContainerView: UIView!
	private var iconLabels = [VerticalIconLabel]()
	private var _width: CGFloat!
	
	struct Constants {
		static let height: CGFloat = AITools.displaySizeFrom1242DesignSize(476)
		static let titleLabelSpace: CGFloat = AITools.displaySizeFrom1242DesignSize(28)
		static let titleLabelHeight: CGFloat = AITools.displaySizeFrom1242DesignSize(28 + Constants.titleLabelFontSize)
		static let titleLabelFontSize: CGFloat = AITools.displaySizeFrom1242DesignSize(48)
		static let titleLabelFont: UIFont = AITools.myriadSemiCondensedWithSize(Constants.titleLabelFontSize)
	}
	
	convenience init(items: [AISearchServiceModel], width: CGFloat) {
		self.init(frame: .zero)
		self.frame = CGRect(x: 0, y: 0, width: width, height: Constants.height)
		self._width = width
		self.items = items
        setup()
		updateUI()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    private func setup() {
		// setup title label
		titleLabel = UILabel()
		titleLabel.text = "Recently browsed"
		titleLabel.textColor = UIColor.whiteColor()
		titleLabel.font = Constants.titleLabelFont
		titleLabel.sizeToFit()
		titleLabel.setLeft(10)
		addSubview(titleLabel)
        
		// setup icon container view
		let _height = Constants.height
		iconContainerView = UIView()
		iconContainerView.backgroundColor = UIColor (red: 1.0, green: 1.0, blue: 1.0, alpha: 0.15)
		iconContainerView.frame = CGRect(x: 0, y: titleLabel.bottom + Constants.titleLabelSpace, width: _width, height: _height - titleLabel.height - Constants.titleLabelSpace)
		addSubview(iconContainerView)
    }
	
	private func updateUI() {
        // clean all icon labels
        iconLabels.forEach { (l) in
            l.removeFromSuperview()
        }
        iconLabels.removeAll()
        
		let _height = Constants.height
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
			iconLabel.text = item.name
			let tap = UITapGestureRecognizer(target: self, action: #selector(AISearchHistoryIconView.iconLabelTapped(_:)))
			iconLabel.addGestureRecognizer(tap)
			if let imageURL = NSURL(string: item.icon) {
				iconLabel.imageView.asyncLoadImage(imageURL.absoluteString)
			}
			iconContainerView.addSubview(iconLabel)
		}
	}
	
	func iconLabelTapped(sender: UITapGestureRecognizer) {
		delegate?.searchHistoryIconView(self, didClickAtIndex: sender.view!.tag)
	}
	
}
