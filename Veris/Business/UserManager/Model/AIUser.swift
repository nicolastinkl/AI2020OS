//
//  User.swift
//  AIVeris
//
//  Created by zx on 8/18/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

@objc enum AIUserType: Int {
	// 根据后端定义
	case Customer = 1
	case Provider = 2
}

class AIUser: NSObject {
	var type: AIUserType = .Customer
	var userId: Int = 0
    var customerId: Int = 0
    var providerId: Int = 0
    var headURL = ""
	
	class func currentUser() -> AIUser {
		let result = AIUser()
        let defaults = NSUserDefaults.standardUserDefaults()
		if let userId = defaults.objectForKey(kDefault_UserID) as? Int {
			result.userId = userId
		}
		if let userType = defaults.objectForKey(kDefault_UserType) as? Int {
			result.type = AIUserType(rawValue: userType)!
		}
        if let userHeadURL = defaults.objectForKey(kDefault_UserHeadURL) as? String {
            result.headURL = userHeadURL
        }
		return result
	}
	
	func save() {
		let defaults = NSUserDefaults.standardUserDefaults()
        let stringID = userId.toString()
		defaults.setObject(stringID, forKey: kDefault_UserID) // UserID的类型是String,与上面的函数冲突
		defaults.setObject(type.rawValue, forKey: kDefault_UserType)
		defaults.synchronize()
	}
}