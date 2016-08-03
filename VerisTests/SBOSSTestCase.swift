//
//  SBOSSTestCase.swift
//  AIVeris
//
//  Created by Rocky on 16/7/21.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import XCTest

class SBOSSTestCase: XCTestCase {
	
	override func setUp() {
		super.setUp()
		initNetEngine()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	private func initNetEngine() {
		let timeStamp: Int = 0
		let token = "0"
		let RSA = "0"
		
		let userID = (NSUserDefaults.standardUserDefaults().objectForKey("Default_UserID") ?? "100000002410") as! String
		
		if userID == "100000002410" {
			NSUserDefaults.standardUserDefaults().setObject(userID, forKey: "Default_UserID")
			NSUserDefaults.standardUserDefaults().synchronize()
		}
		
		let splitedarray = ["\(timeStamp)", token, userID, RSA] as [String]
		
		var headerContent: String = ""
		
		for i in 0 ..< splitedarray.count {
			let str = splitedarray[i]
			headerContent += str
			
			if i != 3 {
				headerContent += "&"
			}
			
		}
		
		let header = ["HttpQuery": headerContent]
		AINetEngine.defaultEngine().configureCommonHeaders(header)
	}
}
