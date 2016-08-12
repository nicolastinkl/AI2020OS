//
//  AIAssignUtils.swift
//  AI2020OS
//
//  Created by tinkl on 10/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func sha1() -> String {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        var digest = [UInt8](count: Int(CC_SHA1_DIGEST_LENGTH), repeatedValue:0)
        CC_SHA1(data.bytes, CC_LONG(data.length), &digest)
        
        let output = NSMutableString(capacity: Int(CC_SHA1_DIGEST_LENGTH))
        for byte in digest {
            output.appendFormat("%02x", byte)
        }
        return output as String
    }
    
    /// MD5 处理
    func md5() -> String {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue:0)
        CC_MD5(data.bytes, CC_LONG(data.length), &digest)
        
        let output = NSMutableString(capacity: Int(CC_MD5_DIGEST_LENGTH))
        for byte in digest {
            output.appendFormat("%02x", byte)
        }
        return output as String
    }
	
	/*!
	 Auto get XXXViewController's idtifiter
	 */
	func viewControllerClassName() -> String {
		// NSStringFromClass(AINetworkLoadingViewController)
		let classNameSS = self.componentsSeparatedByString(".").last! as String
		return classNameSS
	}
	
//    var localized: String {
//        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
//    }
	
	public func toInt() -> Int? {
		if self != "" && self.length > 0 {
			return Int(self)
		}
		return 0
	}
	
	func stringHeightWith(fontSize: CGFloat, width: CGFloat) -> CGFloat {
		let font = UIFont.systemFontOfSize(fontSize)
		let size = CGSizeMake(width, CGFloat.max)
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineBreakMode = .ByWordWrapping
		let attributes = [NSFontAttributeName: font,
			NSParagraphStyleAttributeName: paragraphStyle.copy()]
		
		let text = self as NSString
		let rect = text.boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: attributes, context: nil)
		return rect.size.height
	}
	
	func dateStringFromTimestamp(timeStamp: NSString) -> String {
		let ts = timeStamp.doubleValue
		let formatter = NSDateFormatter()
		formatter.dateFormat = "yyyy年MM月dd日 HH:MM:ss"
		let date = NSDate(timeIntervalSince1970: ts)
		return formatter.stringFromDate(date)
	}
	
	// add by liux at 20151117 根据字体大小计算占用空间
	func sizeWithFontSize(fontSize: CGFloat, forWidth width: CGFloat) -> CGSize {
		let size = CGSizeMake(width, 2000)
		let text = self as NSString
		let contentRect = text.boundingRectWithSize(size, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(fontSize)], context: nil)
		return contentRect.size
	}
	
	// add by liux at 20151117 根据字体计算占用空间
	func sizeWithFont(font: UIFont, forWidth width: CGFloat) -> CGSize {
		let size = CGSizeMake(width, 2000)
		let text = self as NSString
		let contentRect = text.boundingRectWithSize(size, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
		return contentRect.size
	}
}

extension Int {
    func displaySizeFrom1242DesignSize() -> CGFloat {
        let result = AITools.displaySizeFrom1242DesignSize(CGFloat(self))
        return result
    }
}

extension CGFloat {
    func displaySizeFrom1242DesignSize() -> CGFloat {
        let result = AITools.displaySizeFrom1242DesignSize(self)
        return result
    }
}

extension Double {
    func displaySizeFrom1242DesignSize() -> CGFloat {
        let result = AITools.displaySizeFrom1242DesignSize(CGFloat(self))
        return result
    }
}

extension Dictionary {
	
	func valuesForKeysMap(keys: [Key]) -> [Value?] {
		return keys.map { self[$0] }
	}
	
	func valuesForKeys(keys: [Key]) -> [Value?] {
		var result = [Value?]()
		result.reserveCapacity(keys.count)
		for key in keys {
			result.append(self[key])
		}
		return result
	}
	
	func valuesForKeys(keys: [Key], notFoundMarker: Value) -> [Value] {
		
		return self.valuesForKeys(keys).map { $0 ?? notFoundMarker }
		
	}
}
