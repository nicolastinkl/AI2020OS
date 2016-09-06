//
//  CommentManagerTest.swift
//  AIVeris
//
//  Created by Rocky on 16/8/2.
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
        
        XCTAssertEqual(list?.count, 1)
        
        XCTAssertEqual(list?.first?.text, "text")
    }
    
    func testMergeSameServiceIdData() {
        
        loadData()
        
//        let newModel = ServiceComment()
//        newModel.service_id = "1"
//        
//        var photos = [CommentPhoto]()
//        var photo = CommentPhoto()
//
//        photo.url = NSURL(fileURLWithPath: "123456").absoluteString
//        photos.append(photo)
//        
//        newModel.photos = photos
//        
//        let list = commentManager.mergeCommentsData([newModel])
//        
//        XCTAssertEqual(list.count, 1)
//        
//        let m = list[0].photos as! [CommentPhoto]
//        
//        XCTAssertEqual(m[0].url, NSURL(fileURLWithPath: "123456").absoluteString)
//        XCTAssertEqual(m[1].url, NSURL(fileURLWithPath: "12345").absoluteString)
    }
    
    func testMergeDiffServiceIdData() {
        
        loadData()
        
//        let newModel = ServiceComment()
//        newModel.service_id = "2"
//        
//        var photos = [CommentPhoto]()
//        var photo = CommentPhoto()
//        photo.url = NSURL(fileURLWithPath: "12345").absoluteString
//        photos.append(photo)
//        
//        photo = CommentPhoto()
//        photo.url = NSURL(fileURLWithPath: "123456").absoluteString
//        photos.append(photo)
//        
//        newModel.photos = photos
//        
//        let list = commentManager.mergeCommentsData([newModel])
//        
//        XCTAssertEqual(list.count, 1)
//        
//        let m = list[0].photos as! [CommentPhoto]
//        
//        XCTAssertEqual(list[0].service_id, "2")
//        
//        XCTAssertEqual(m[0].url, NSURL(fileURLWithPath: "12345").absoluteString)
//        XCTAssertEqual(m[1].url, NSURL(fileURLWithPath: "123456").absoluteString)
    }
    
    func testSaveImage() {
        
        let image = ImageInfoModel()
        image.localUrl = "12345"
        image.imageId = "9"
        image.isSuccessUploaded = true
        
        let defa = NSUserDefaults.standardUserDefaults()
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(image)
        defa.setObject(data, forKey: "image")
        
        defa.synchronize()
        
        if let data = defa.objectForKey("image") as? NSData {
            let im = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! ImageInfoModel
            XCTAssertEqual(im.localUrl, "12345")
        }
    }
    
    private func saveData() {
        let image = ImageInfoModel()
        image.localUrl = "12345"
        image.imageId = "9"
        image.isSuccessUploaded = true
        
        let model = ServiceCommentLocalSavedModel()
        model.serviceId = "1"
        model.text = "text"
        model.imageInfos = [image]
        
        XCTAssertTrue(commentManager.saveCommentModelToLocal(model.serviceId, model: model))
        
    //    NSLog("%@", NSUserDefaults.standardUserDefaults().dictionaryRepresentation())
        
    }
    
    private func loadData() {
        if commentManager.localModelList == nil {
            commentManager.loadCommentModelsFromLocal(["1"])
        }
    }

}
