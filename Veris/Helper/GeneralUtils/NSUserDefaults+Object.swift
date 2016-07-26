//
//  NSUserDefaults+Object.swift
//  AIVeris
//
//  Created by zx on 7/25/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

extension JSONModel {
	func save() -> Bool {
		var allJSONStrings = self.dynamicType._allJSONStrings()
		allJSONStrings.append(toJSONString())
		let key = String(self.dynamicType)
		let defaults = NSUserDefaults.standardUserDefaults()
		defaults.setObject(allJSONStrings, forKey: key)
		return defaults.synchronize()
	}
	
	func delete() -> Bool {
		var allJSONStrings = self.dynamicType._allJSONStrings()
		let JSONString = toJSONString()!
		if let index = allJSONStrings.indexOf(JSONString) {
			allJSONStrings.removeAtIndex(index)
			let key = String(self.dynamicType)
			let defaults = NSUserDefaults.standardUserDefaults()
			defaults.setObject(allJSONStrings, forKey: key)
			return defaults.synchronize()
		} else {
			return false
		}
	}
	
	static func _allJSONStrings() -> [String] {
		let key = NSStringFromClass(self)
		
		let defaults = NSUserDefaults.standardUserDefaults()
		if let result = defaults.objectForKey(key) as? [String] {
			return result
		} else {
			let result = [String]()
			defaults.setObject(result, forKey: key)
			defaults.synchronize()
			return result
		}
	}
	
    /// 获取所有在NSUserDefaults中的对象
    /// 注意需要先传入对像类型，例如
    ///
    ///     let allStarDescs: [StarDesc] = StarDesc.allObjectsInUserDefaults()
    ///
    ///
	static func allObjectsInUserDefaults<T: JSONModel>(filter: ((T -> Bool)?) = nil) -> [T] {
		var result = [T]()
		for (_, json) in _allJSONStrings().enumerate() {
			let object = T(string: json, error: nil)
			if let filter = filter {
				if filter(object) {
					result.append(object)
				}
			} else {
				result.append(object)
			}
		}
		return result
	}
}
