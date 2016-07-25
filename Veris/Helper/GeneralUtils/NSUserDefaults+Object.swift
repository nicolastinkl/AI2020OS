//
//  NSUserDefaults+Object.swift
//  AIVeris
//
//  Created by zx on 7/25/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

protocol NSUserDefaultsObjectConvertible: NSCoding {
	func save()
	var allKeys: [String] { get }
}

extension NSUserDefaultsObjectConvertible where Self: NSObject {
	func save() {
		NSUserDefaults.standardUserDefaults().synchronize()
	}
}

class NSUserDefaultsObject: NSObject, NSCoding, NSUserDefaultsObjectConvertible {
	
	func allObjectForClassName<T: NSUserDefaultsObject>(className: T) -> [T] {
		let result = NSUserDefaults.standardUserDefaults().valueForKey(NSStringFromClass(className.dynamicType))
		if result == nil {
            
		} else {
			return
		}
	}
	
	func encodeWithCoder(aCoder: NSCoder) {
		for key in allKeys {
			aCoder.encodeObject(valueForKey(key), forKey: key)
		}
	}
	required init?(coder aDecoder: NSCoder) {
		super.init()
		for key in allKeys {
			setValue(aDecoder.decodeObjectForKey(key), forKey: key)
		}
	}
	var allKeys: [String] {
		fatalError("subclass needs override this property")
	}
}

class CommentDraft: NSUserDefaultsObject {
	var uniqueId = 0
	var localULR = ""
	var remoteULR = ""
	
	override var allKeys: [String] {
		return ["uniqueId", "localURL", "remoteULR"]
	}
}
