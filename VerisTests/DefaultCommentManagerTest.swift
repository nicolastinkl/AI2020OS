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
        
        let images = list!.first!.imageInfos
        let firstImage = images.firstObject as! ImageInfoModel
        
        XCTAssertEqual(firstImage.localUrl, "assets-library://asset/asset.JPG?id=2539C955-9ED6-43D6-B067-4F5E6B9730DB&ext=JPG")
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
    
    func testDeleteData() {
        commentManager.deleteCommentModel(["1"])
        
        let models = commentManager.loadCommentModelsFromLocal(["1"])
        
        XCTAssertTrue(models == nil)
    }
    
    func saveData() {
        let image = ImageInfoModel()
        image.localUrl = "assets-library://asset/asset.JPG?id=2539C955-9ED6-43D6-B067-4F5E6B9730DB&ext=JPG"
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
