//
//  CommentSpecTest.swift
//  AIVeris
//
//  Created by Rocky on 16/8/3.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import XCTest

class CommentSpecTest: XCTestCase {

    override func setUp() {
        super.setUp()
        
        var list = [StarDesc]()
        
        var star = StarDesc()
        star.id = "2623"
        star.name = "Excellent"
        star.value_max = "10"
        star.value_min = "8.1"
        list.append(star)
        
        star = StarDesc()
        star.id = "2625"
        star.name = "Average"
        star.value_max = "6"
        star.value_min = "4.1"
        list.append(star)
        
        star = StarDesc()
        star.id = "2624"
        star.name = "Good"
        star.value_max = "8"
        star.value_min = "6.1"
        list.append(star)
        
        star = StarDesc()
        star.id = "2627"
        star.name = "Terrible"
        star.value_max = "2"
        star.value_min = "0"
        list.append(star)
        
        star = StarDesc()
        star.id = "2626"
        star.name = "Poor"
        star.value_max = "4"
        star.value_min = "2.1"
        list.append(star)
        
        CommentUtils.setStarDesData(list)
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testConvertPercentToStarValue() {
        let value = CommentUtils.convertPercentToStarValue(0.3)
        
        XCTAssertEqual(value, 3.0)
    }

    func testGetStarValueDes() {
        var des = CommentUtils.getStarValueDes(0.1)
        XCTAssertEqual(des, "Terrible")
        
        des = CommentUtils.getStarValueDes(0.2)
        XCTAssertEqual(des, "Terrible")
        
        des = CommentUtils.getStarValueDes(0.3)
        XCTAssertEqual(des, "Poor")
        
        des = CommentUtils.getStarValueDes(0.61)
        XCTAssertEqual(des, "Good")
        
        des = CommentUtils.getStarValueDes(1)
        XCTAssertEqual(des, "Excellent")
        
        des = CommentUtils.getStarValueDes(0.0)
        XCTAssertEqual(des, "Terrible")
    }
    
    func testIsStarValueValid() {
        XCTAssert(CommentUtils.isStarValueValid("3"))
        XCTAssertFalse(CommentUtils.isStarValueValid(""))
        XCTAssertFalse(CommentUtils.isStarValueValid("0.0"))
        XCTAssertFalse(CommentUtils.isStarValueValid("0"))
    }

}
