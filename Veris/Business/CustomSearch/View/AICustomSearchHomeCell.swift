//
//  AICustomSearchHomeCell.swift
//  AIVeris
//
// Copyright (c) 2016 ___ASIAINFO___
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

class AICustomSearchHomeCell: UITableViewCell {
	
	@IBOutlet weak var imageview: AIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var desLabel: UILabel!
	@IBOutlet weak var nameTwiceLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var likeButton: UIButton!
	@IBOutlet weak var hotButton: UIButton!
	@IBOutlet weak var rateView: StarRateView!
	@IBOutlet weak var wavyLineView: UIView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		nameLabel.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(48))
		nameLabel.textColor = UIColor.whiteColor()
		
		priceLabel.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(48))
		desLabel.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(48))
		desLabel.textColor = UIColor(hexString: "#d4d5ef", alpha: 0.7)
		nameTwiceLabel.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(48))
		nameTwiceLabel.textColor = UIColor(hexString: "#aba8b5")
		
		let buttonFont = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(36))
		likeButton.titleLabel?.font = buttonFont
		hotButton.titleLabel?.font = buttonFont
		likeButton.setTitleColor(UIColor(hexString: "#ffffff", alpha: 0.5), forState: .Normal)
		hotButton.setTitleColor(UIColor(hexString: "#ffffff", alpha: 0.5), forState: .Normal)
		
		desLabel.textColor = UIColor(hexString: "#FFFFFF", alpha: 0.7)
		priceLabel.font = AITools.myriadSemiboldSemiCnWithSize(AITools.displaySizeFrom1242DesignSize(60))
		priceLabel.textColor = UIColor(hexString: "#e7c400")
		let wavyImage = UIImage(named: "wavy_lines")?.stretchableImageWithLeftCapWidth(1, topCapHeight: 0)
		let wavyColor = UIColor(patternImage: wavyImage!)
		wavyLineView.backgroundColor = wavyColor
		
	}
	
	func initData(model: AISearchResultItemModel) {
		imageview.setURL(NSURL(string: ""), placeholderImage: smallPlace())
		nameLabel.text = model.service_name as String
		nameTwiceLabel.text = String(format: " - %@", model.service_second_name)
		desLabel.text = model.service_description as String
		let priceString = String(format: "€%@", model.service_price as String)
		priceLabel.text = priceString
		let likeString = String(format: " %d", model.service_likes)
		let hotString = String(format: " %d", model.service_browse)
		likeButton.setTitle(likeString, forState: .Normal)
		hotButton.setTitle(hotString, forState: .Normal)
		
	}
}
