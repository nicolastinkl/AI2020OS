//
//  CommentTest.swift
//  AIVeris
//
//  Created by Rocky on 16/7/12.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import XCTest

class CommentTest: SBOSSTestCase {
    
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
        
        service.getSingleComment("1", userType: 1, serviceId: "1", success: { (responseData) in
            
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
        
        service.getCompondComment("10012", userType: 1, serviceId: "900001001008", success: { (responseData) in
            
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
    
    func testQueryCommentSpecification() {
        let readyExpectation = expectationWithDescription("done")
        
        service.queryCommentSpecification({ (responseData) in
            let re = responseData
            print("queryCommentSpecification success:\(re)")
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
    
    func testSubmitComments() {
        let readyExpectation = expectationWithDescription("done")
        
        let serviceComment = SingleComment()
        serviceComment.service_id = "1"
        serviceComment.spec_id = "2623"
        serviceComment.rating_level = 9
//        serviceComment.text = "Good."
        
        service.submitComments("1", userType: 1, commentList: [serviceComment], success: { (responseData) in
                let re = responseData
                print("queryCommentSpecification success:\(re)")
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
    
    func testNumberSort() {
        var numbers = [NSNumber]()
        
        numbers.append(NSNumber(int: 2))
        numbers.append(NSNumber(int: 1))
        
        let newNumbers = numbers.sort { (firstNumber, secondNumber) -> Bool in
            let result = firstNumber.compare(secondNumber)
            
            return result == NSComparisonResult.OrderedDescending
        }
        
        XCTAssertTrue(newNumbers[0].intValue == 2)
    }
}
