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
	
	func testExample() {
		let singleComments: [SingleComment] = SingleComment.allObjectsInUserDefaults({ t in
			return t.service_name == "zx"
		})
		if let singleComment = singleComments.first {
			singleComment.delete()
		}
		print(singleComments)
		
		let newOne = SingleComment()
		newOne.service_name = "zx"
		newOne.save()
	}
	
	func testCompare() {
        
		let model1 = StarDesc()
		model1.name = "zx"
		model1.id = "233"
		model1.save()
        
		let allStarDescs: [StarDesc] = StarDesc.allObjectsInUserDefaults()
		print(allStarDescs)
		
		if allStarDescs.count > 0 {
			print(allStarDescs.first!)
		}
        
        let firstModel = allStarDescs.first!
        
        assert(model1.toJSONString() != firstModel.toJSONString())
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
