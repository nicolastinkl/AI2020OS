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
	
	var allKeys: [String] {
		fatalError("subclass needs override this property")
	}
	
	var uniqueId: Int = 0
	
	class func allObjects<T: NSUserDefaultsObject>() -> [T] {
		print(T)
		return []
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
	
}

class CommentDraft: NSUserDefaultsObject {
	var localULR = ""
	var remoteULR = ""
	override var allKeys: [String] {
		return ["uniqueId", "localURL", "remoteULR"]
	}
}
