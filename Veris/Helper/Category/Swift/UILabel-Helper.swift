//
//  UILabel-Helper.swift
//  AIVeris
//
//  Created by zx on 6/29/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

extension UILabel {
	class func label(font: UIFont, textColor: UIColor) -> Self {
		return _label(font, textColor: textColor)
	}
	
	private class func _label<T>(font: UIFont = UIFont.systemFontOfSize(16), textColor: UIColor = UIColor.blackColor()) -> T {
		let result = UILabel()
		result.font = font
		result.textColor = textColor
		return result as! T
	}
}
