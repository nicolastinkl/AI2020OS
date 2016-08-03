//
//  CommentManagerTest.swift
//  AIVeris
//
//  Created by admin on 16/8/2.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import XCTest

class DefaultCommentManagerTest: XCTestCase {
    
    var commentManager: DefaultCommentManager!

    override func setUp() {
        super.setUp()
        
        commentManager = DefaultCommentManager()
        saveData()
    }
    
    func testLoadCommentModels() {
        
        loadData()
        let list = commentManager.localModelList
        XCTAssertNotNil(list)
        
        let comment = list![0].imageInfos[0]
        
        XCTAssertEqual(comment.url!.path, "/12345")
        XCTAssertEqual(comment.isSuccessUploaded, true)
        XCTAssertEqual(comment.imageId, "9")
    }
    
    func testMergeSameServiceIdData() {
        
        loadData()
        
        let newModel = ServiceComment()
        newModel.service_id = "1"
        
        var photos = [CommentPhoto]()
        var photo = CommentPhoto()

        photo.url = NSURL(fileURLWithPath: "123456").absoluteString
        photos.append(photo)
        
        newModel.photos = photos
        
        let list = commentManager.mergeCommentsData([newModel])
        
        XCTAssertEqual(list.count, 1)
        
        let m = list[0].photos as! [CommentPhoto]
        
        XCTAssertEqual(m[0].url, NSURL(fileURLWithPath: "123456").absoluteString)
        XCTAssertEqual(m[1].url, NSURL(fileURLWithPath: "12345").absoluteString)
    }
    
    func testMergeDiffServiceIdData() {
        
        loadData()
        
        let newModel = ServiceComment()
        newModel.service_id = "2"
        
        var photos = [CommentPhoto]()
        var photo = CommentPhoto()
        photo.url = NSURL(fileURLWithPath: "12345").absoluteString
        photos.append(photo)
        
        photo = CommentPhoto()
        photo.url = NSURL(fileURLWithPath: "123456").absoluteString
        photos.append(photo)
        
        newModel.photos = photos
        
        let list = commentManager.mergeCommentsData([newModel])
        
        XCTAssertEqual(list.count, 1)
        
        let m = list[0].photos as! [CommentPhoto]
        
        XCTAssertEqual(list[0].service_id, "2")
        
        XCTAssertEqual(m[0].url, NSURL(fileURLWithPath: "12345").absoluteString)
        XCTAssertEqual(m[1].url, NSURL(fileURLWithPath: "123456").absoluteString)
    }
    
    private func saveData() {
        let image = ImageInfoModel()
        image.url = NSURL(fileURLWithPath: "12345")
        image.imageId = "9"
        image.isSuccessUploaded = true
        
        let model = ServiceCommentLocalSavedModel()
        model.serviceId = "1"
        model.imageInfos = [image]
        
        XCTAssertTrue(commentManager.saveCommentModelToLocal(model.serviceId, model: model))
    }
    
    private func loadData() {
        if commentManager.localModelList == nil {
            commentManager.loadCommentModelsFromLocal(["1"])
        }
    }

}
