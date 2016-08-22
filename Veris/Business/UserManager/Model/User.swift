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
	var id: Int = 100000002410
    var headURL = ""
	
	class func currentUser() -> AIUser {
		let result = AIUser()
        let defaults = NSUserDefaults.standardUserDefaults()
		if let userId = defaults.objectForKey(kDefault_UserID) as? Int {
			result.id = userId
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
		defaults.setObject(id, forKey: kDefault_UserID)
		defaults.setObject(type.rawValue, forKey: kDefault_UserType)
		defaults.synchronize()
	}
}
