//
//  FileCommentManagerTest.swift
//  AIVeris
//
//  Created by Rocky on 16/9/6.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import XCTest

class FileCommentManagerTest: DefaultCommentManagerTest {
    
    override func setUp() {
        
        commentManager = FileCommentManager()
        saveData()
    }
    
    override func testLoadCommentModels() {
        
        super.testLoadCommentModels()
    }
    
    override func testDeleteData() {
        super.testDeleteData()
    }
    
}
