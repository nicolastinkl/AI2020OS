//
//  CommentManagerTest.swift
//  AIVeris
//
//  Created by Rocky on 16/8/2.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import XCTest

class DefaultCommentManagerTest: XCTestCase {
    
    private static let imageUrl = "assets-library://asset/asset.JPG?id=B84E8479-475C-4727-A4A4-B77AA9980897&ext=JPG"
    
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
        
        XCTAssertEqual(firstImage.localUrl, DefaultCommentManagerTest.imageUrl)
        XCTAssertEqual(firstImage.isSuccessUploaded, true)
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
        image.localUrl = DefaultCommentManagerTest.imageUrl
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
