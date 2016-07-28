//
//  ProposalServiceTest.swift
//  AIVeris
//
//  Created by admin on 16/7/28.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import XCTest

class ProposalServiceTest: XCTestCase {
    
    var service: ProposalService!

    override func setUp() {
        super.setUp()
        service = BDKProposalService()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testGetProposalList() {
        let readyExpectation = expectationWithDescription("done")
        
        service.getProposalList({ (responseData) -> Void in
                let re = responseData
                print("getProposalList success:\(re)")
                XCTAssert(true)
                readyExpectation.fulfill()  
            }, fail: { (errType, errDes) -> Void in
                XCTAssert(false)
                readyExpectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(5, handler: { error in
            XCTAssertNil(error, "Error")
        })

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
