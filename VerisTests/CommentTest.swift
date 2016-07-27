//
//  CommentTest.swift
//  AIVeris
//
//  Created by admin on 16/7/12.
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
    
    func testCommentImageSave() {
        let pl = ImageInfoPList(firstImages: nil, appendImages: nil)
        
        let image = ImageInfo()
        
        image.url = NSURL(fileURLWithPath: "12345")
        var infos = [image]
        
        pl.firstImages = infos
        
        XCTAssert(CommentUtils.saveCommentImageInfo("1", info: pl))
        

        var npl = CommentUtils.getCommentImageInfo("1")
        
        XCTAssertTrue(npl?.firstImages?.count == 1)
        XCTAssertEqual(npl?.firstImages?[0].url?.path, "/12345")

        
        
    }

}
