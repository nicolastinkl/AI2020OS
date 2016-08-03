//
//  AIProviderDetailServiceTest.swift
//  AIVeris
//
//  Created by zx on 8/1/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import XCTest

class AIProviderDetailServiceTest: SBOSSTestCase {
	var service: AIProviderDetailService!
	
	override func setUp() {
		super.setUp()
		service = AIProviderDetailService()
	}
	
	func testQueryProvider() {
		let readyExpectation = expectationWithDescription("done")
		
		service.queryProvider("1", success: { responseData in
			let re = responseData
			print("queryProvider success:\(re)")
			XCTAssert(true)
			readyExpectation.fulfill()
		}) { (errType, errDes) in
			
			XCTAssert(false)
			readyExpectation.fulfill()
		}
		
		waitForExpectationsWithTimeout(5, handler: { error in
			XCTAssertNil(error, "Error")
		})
		
	}
}
