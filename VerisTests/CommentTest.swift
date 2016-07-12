//
//  CommentTest.swift
//  AIVeris
//
//  Created by admin on 16/7/12.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import XCTest

class CommentTest: XCTestCase {
    
    var service: CommentService!
    
    override func setUp() {
        super.setUp()
       
        service = HttpCommentService()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testGetSingleComment() {
        let readyExpectation = expectationWithDescription("done")
        
        service.getSingleComment("1", success: { (responseData) in
            
            let re = responseData
            print("getSingleComment success:\(re)")
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
    
    func testGetCompondComment() {
        let readyExpectation = expectationWithDescription("done")
        
        service.getCompondComment("1", success: { (responseData) in
            
            let re = responseData
            print("getCompondComment success:\(re)")
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
