//
//  AISearchHistoryLabels.swift
//  AIVeris
//
//  Created by 王坜 on 16/6/1.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

protocol AISearchHistoryLabelsDelegate: NSObjectProtocol {
    func searchHistoryLabels(searchHistoryLabel: AISearchHistoryLabels, clickedText: String)
}

class AISearchHistoryLabels: UIView {

    weak var delegate: AISearchHistoryLabelsDelegate?

	var mainTitle: String?
	var historyLabels: [String]?
	var mainTitleLabel: UPLabel!
	var containLabels: [String] = [String]()
	var maxHeight: CGFloat = 0
	//
    
	let horizontalMargin: CGFloat = AITools.displaySizeFrom1242DesignSize(40)
	let verticalMargin: CGFloat = 25
    
	let titleFontSize: CGFloat = AITools.displaySizeFrom1242DesignSize(48)
	let labelFontSize: CGFloat = AITools.displaySizeFrom1242DesignSize(48)
    let titleFont = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(48))
    let labelFont = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(48))

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	init(frame: CGRect, title: String?, labels: [String]?) {
		super.init(frame: frame)
		mainTitle = title
		historyLabels = labels

		makeTitle()
		makeLabels()
		reHeightSelf()
	}

	func makeTitle() {

		guard mainTitle != nil else {
			return
		}

		let maxWidth = CGRectGetWidth(self.frame)
		let size = mainTitle?.sizeWithFont(titleFont, forWidth: maxWidth)
		mainTitleLabel = AIViews.wrapLabelWithFrame(CGRectMake(0, 0, (size?.width)!, (size?.height)!), text: mainTitle, fontSize: titleFontSize, color: UIColor.whiteColor())
        mainTitleLabel.font = titleFont
		addSubview(mainTitleLabel)

        maxHeight = (size?.height)!
	}

	func findSuitableLabel(suitableSize: CGFloat) -> String {

		var suitableLabel = ""
		let maxWidth = CGRectGetWidth(self.frame)
		for historyLabel in historyLabels! {
			let size = historyLabel.sizeWithFont(labelFont, forWidth: maxWidth)
			if size.width <= suitableSize && isContainLabel(historyLabel) == false {
				suitableLabel = historyLabel
				break
			}
		}

		return suitableLabel
	}

	func isContainLabel(label: String) -> Bool {

		var isContainLabel = false
		for l in containLabels {
			if l == label {
				isContainLabel = true
				break
			}
		}

		return isContainLabel
	}

	func makeLabels(startX: CGFloat, startY: CGFloat, labels: [String]) {
		var tempLabels = [String]()
		let maxWidth = CGRectGetWidth(self.frame)
		var x = startX
		var y = startY

		for historyLabel in labels {

			if isContainLabel(historyLabel) {
				continue
			}

			var labelText = historyLabel
			var size = labelText.sizeWithFont(labelFont, forWidth: maxWidth)
            size.width += 30
            size.height += 16

			if (x + horizontalMargin + size.width) > maxWidth {
				let shortLabel = findSuitableLabel(maxWidth - x - horizontalMargin)
				if shortLabel != "" {
					tempLabels.append(labelText)
					labelText = shortLabel
                    size = labelText.sizeWithFont(labelFont, forWidth: maxWidth)
                    size.width += 30
                    size.height += 16

				} else {
					x = 0
					y += verticalMargin + size.height
				}

			}

			let label = AIViews.wrapLabelWithFrame(CGRectMake(x, y, size.width, size.height), text: labelText, fontSize: labelFontSize, color: UIColor.whiteColor())
            label.font = labelFont
            label.userInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(AISearchHistoryLabels.labelTapped(_:)))
            label.addGestureRecognizer(tap)
			addSubview(label)
            label.layer.borderColor = UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2 ).CGColor
            label.layer.borderWidth = 0.5
            label.layer.masksToBounds = true
            label.layer.cornerRadius = size.height / 2
            label.textAlignment  = .Center
			x = CGRectGetMaxX(label.frame) + horizontalMargin

			containLabels.append(labelText)

            maxHeight = y + size.height
		}

		if tempLabels.count > 0 {
			makeLabels(x, startY: y, labels: tempLabels)
		}
	}

    func labelTapped(tap: UITapGestureRecognizer) {
        if let label = tap.view as? UPLabel {
            delegate?.searchHistoryLabels(self, clickedText: label.text!)
        }
    }

	func makeLabels() {

		guard historyLabels != nil else {
			return
		}

		let x: CGFloat = 0
		let y: CGFloat = (mainTitle == nil ? 0 : CGRectGetMaxY((mainTitleLabel?.frame)!)) + verticalMargin

		makeLabels(x, startY: y, labels: historyLabels!)

	}

	func reHeightSelf() {
		var frame = self.frame
		frame.size.height = maxHeight
		self.frame = frame
	}

}
