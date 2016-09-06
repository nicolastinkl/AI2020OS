//
//  ExcuteManagerTest.swift
//  AIVeris
//
//  Created by Rocky on 16/8/31.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import XCTest

class ExcuteManagerTest: XCTestCase {
    
    var manager: ExcuteManager!

    override func setUp() {
        super.setUp()
        manager = BDKExcuteManager()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSubmitServiceNodeResult() {
        let readyExpectation = expectationWithDescription("done")
        
        let node = NodeResultContent()
        node.note_type = "Text"
        node.note_content = "Test"
       
        manager.submitServiceNodeResult(602, procedureId: 1, resultList: [node], success: { (responseData) in
            
            let re = responseData
            print("submitServiceNodeResult success:\(re)")
        
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
