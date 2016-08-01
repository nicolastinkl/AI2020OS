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
        
        let serviceComment = ServiceComment()
        serviceComment.service_id = "1"
        serviceComment.spec_id = "2623"
        serviceComment.rating_level = "9"
        serviceComment.text = "Good."
        
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
    
    func testCommentViewModelLocalSave() {
        let image = ImageInfo()
        image.url = NSURL(fileURLWithPath: "12345")
        
        let model = ServiceCommentLocalSavedModel()
        model.serviceId = "1"
        model.images = [image]
        
        XCTAssertTrue(CommentUtils.saveCommentModelToLocal(model.serviceId, model: model))
        
        let m = CommentUtils.getCommentModelFromLocal(model.serviceId)
        
        XCTAssertEqual(m?.images[0].url?.path, "/12345")
        XCTAssertEqual(m?.serviceId, model.serviceId)
    }

}
