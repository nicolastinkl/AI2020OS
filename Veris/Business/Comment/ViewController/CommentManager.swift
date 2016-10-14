//
//  CommentManager.swift
//  AIVeris
//
//  Created by Rocky on 16/8/1.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

protocol CommentManager {
    
    func loadCommentModelsFromLocal(serviceIds: [String]) -> [ServiceCommentLocalSavedModel]?
    func saveCommentModelToLocal(serviceId: String, model: ServiceCommentLocalSavedModel) -> Bool
    func deleteCommentModel(serviceIds: [String])
    // 记录上传图片，imageId:标识图片的id url:图片在本地的url
    func recordUploadImage(serviceId: String, imageId: String, url: NSURL)
    func notifyImageUploadResult(serviceId: String, imageId: String, url: NSURL?)
    func submitComments(userID: String, userType: Int, commentList: [SingleComment], success: (responseData: RequestResult) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
}

class FileCommentManager: DefaultCommentManager {
    private static let fileName = "commentLocalModel"
    
    var modelMap: [String: ServiceCommentLocalSavedModel]!
    
    override func saveCommentModelToLocal(serviceId: String, model: ServiceCommentLocalSavedModel) -> Bool {

        modelMap = loadModelMap()
        
        if modelMap == nil {
           modelMap = [String: ServiceCommentLocalSavedModel]()
        }
        
        modelMap[serviceId] = model
        
        return saveModelMap()
    }
    
    override func getCommentModelFromLocal(serviceId: String) -> ServiceCommentLocalSavedModel? {
        if modelMap == nil { // first load data
            modelMap = loadModelMap()
        }
        
        if modelMap == nil {
            return nil
        }

        return modelMap[serviceId]
    }
    
    override func deleteCommentModel(serviceIds: [String]) {
        if modelMap == nil { // first load data
            modelMap = loadModelMap()
        }
        
        if modelMap == nil {
            return
        }
        
        for id in serviceIds {
            modelMap[id] = nil
        }
        
        saveModelMap()
    }
    
    override func clearLocalModels() {
        guard let fileFilePath = getModelFilePath() else {
            return
        }
        
        do {
            try NSFileManager.defaultManager().removeItemAtPath(fileFilePath.path!)       
        } catch {
            
        }
    }
    
    private func getModelFilePath() -> NSURL? {
        guard let docUrl = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last else {
            return nil
        }
        
        return docUrl.URLByAppendingPathComponent(FileCommentManager.fileName)
    }
    
    private func loadModelMap() -> [String: ServiceCommentLocalSavedModel]? {
        guard let fileFilePath = getModelFilePath() else {
            return nil
        }
        
        if !NSFileManager.defaultManager().fileExistsAtPath(fileFilePath.path!) {
            return nil
        }
        
        guard let data = NSFileManager.defaultManager().contentsAtPath(fileFilePath.path!) else {
            return nil
        }
        
        guard let dic = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSDictionary else {
            return nil
        }
        
        if modelMap == nil {
            modelMap = [String: ServiceCommentLocalSavedModel]()
        }
        
        for (key, value) in dic {
            modelMap[key as! String] = value as? ServiceCommentLocalSavedModel
        }
        
        return modelMap
    }
    
    private func saveModelMap() -> Bool {
        
        guard let fileFilePath = getModelFilePath() else {
            return false
        }
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(modelMap)
        
        do {
            
            try data.writeToURL(fileFilePath, options: NSDataWritingOptions.AtomicWrite)
            return true
            
        } catch {
            return false
        }
    }
}

class CommentLocalMapModel {
    var modelMap: [String: ServiceCommentLocalSavedModel]!
}

class DefaultCommentManager: CommentManager {
    
    static let commentVersion = 1
    
    private static let idPrefix = "CommentViewModel_"
    
    var localModelList: [ServiceCommentLocalSavedModel]?
    
    init() {
        let defa = NSUserDefaults.standardUserDefaults()
        
        if let data = defa.objectForKey("CommentVersion") as? NSData {
            if let oldVersion = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Int {
                if oldVersion != DefaultCommentManager.commentVersion {
                    clearLocalModels()
                    
                    let data = NSKeyedArchiver.archivedDataWithRootObject(DefaultCommentManager.commentVersion)
                    defa.setObject(data, forKey: "CommentVersion")
                }
            }
        } else {
            let data = NSKeyedArchiver.archivedDataWithRootObject(DefaultCommentManager.commentVersion)
            defa.setObject(data, forKey: "CommentVersion")
        }
    }
    
    func clearLocalModels() {
        let defa = NSUserDefaults.standardUserDefaults()
        
        let keys = defa.dictionaryRepresentation().keys
        
        for key in keys {
            if key.hasPrefix(DefaultCommentManager.idPrefix) {
                defa.removeObjectForKey(key)
            }
        }
        
        defa.synchronize()
    }
    
    func loadCommentModelsFromLocal(serviceIds: [String]) -> [ServiceCommentLocalSavedModel]? {
        
        func deleteInvalideImages(model: ServiceCommentLocalSavedModel) -> ServiceCommentLocalSavedModel? {
            var newModel: ServiceCommentLocalSavedModel?
                
            let valideImages = model.imageInfos.filter { (info) -> Bool in
                guard let url = info.localUrl else {
                    return false
                }
                
                if !info.isSuccessUploaded {
                    return false
                }
                
                return imageIsExist(NSURL(string: url)!)
            }
            
            newModel = model
            newModel!.imageInfos = NSMutableArray(array: valideImages)
            
            return newModel
        }
        
        ensureLocalModelListNotNil()
        localModelList?.removeAll()
        
        for id in serviceIds {
            if let model = getCommentModelFromLocal(id) {
                
                if let newModel = deleteInvalideImages(model) {
                    if newModel.imageInfos.count != model.imageInfos.count {
                        // 重写过滤无用图片后的评论数据
                        saveCommentModelToLocal(id, model: newModel)
                    } 
                    localModelList?.append(newModel)
                } else {
                    localModelList?.append(model)
                }   
            } else {
                let model = ServiceCommentLocalSavedModel()
                model.serviceId = id
                localModelList?.append(model)
            }
        }
        
        return localModelList
    }
    
    func getCommentModelFromLocal(serviceId: String) -> ServiceCommentLocalSavedModel? {
        let defa = NSUserDefaults.standardUserDefaults()
        
        let key = createSearchKey(serviceId)
        
        if let data = defa.objectForKey(key) as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? ServiceCommentLocalSavedModel
        } else {
            return nil
        }
    }
    
    private func imageIsExist(url: NSURL) -> Bool {
        
        var exist = AssetUtils.assetExists(url)
        
        if !exist {
            let fileManager = NSFileManager.defaultManager()
            exist = fileManager.fileExistsAtPath(url.absoluteString!)
        }
        
        return exist
    }
    
    func saveCommentModelToLocal(serviceId: String, model: ServiceCommentLocalSavedModel) -> Bool {
        let defa = NSUserDefaults.standardUserDefaults()
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(model)
    //    let m = NSKeyedUnarchiver.unarchiveObjectWithData(data)
        defa.setObject(data, forKey: createSearchKey(serviceId))
        return defa.synchronize()
    }
    
    func deleteCommentModel(serviceIds: [String]) {
        let defa = NSUserDefaults.standardUserDefaults()
        
        for id in serviceIds {
            defa.removeObjectForKey(createSearchKey(id))
            if let m = findLocalComment(id) {
                localModelList?.removeAtIndex(m.index)
            }
        }
        
        defa.synchronize()
    }
    
    // 记录上传图片，imageId:标识图片的id url:图片在本地的url
    func recordUploadImage(serviceId: String, imageId: String, url: NSURL) {
        Async.main {[weak self] in
            guard let s = self else {
                return
            }
            
            s.ensureLocalModelListNotNil()
            
            var service: ServiceCommentLocalSavedModel!
            
            for se in s.localModelList! {
                if se.serviceId == serviceId {
                    service = se
                }
            }
            
            var needAppendLocalList = false
            if service == nil {
                service = ServiceCommentLocalSavedModel()
                service.serviceId = serviceId
                needAppendLocalList = true
            }
            
            let info = ImageInfoModel()
            
            info.imageId = imageId
            info.localUrl = url.absoluteString
            info.uploadFinished = false
            info.isCurrentCreate = true
            service.imageInfos.addObject(info)
            
            if needAppendLocalList {
                s.localModelList?.append(service)
            }
            
            s.saveCommentModelToLocal(serviceId, model: service)
        }
    }
    
    func notifyImageUploadResult(serviceId: String, imageId: String, url: NSURL?) {
        Async.main {[weak self] in
            guard let s = self else {
                return
            }
            
            guard let modelTuple = s.findLocalComment(serviceId) else {
                return
            }
            
            guard let imageInfo = s.findImageInfo(imageId, localModel: modelTuple.model) else {
                return
            }
            
                imageInfo.uploadFinished = true
                
                if url != nil {
                    imageInfo.isSuccessUploaded = true
                    imageInfo.webUrl = url?.absoluteString
                } else {
                    imageInfo.isSuccessUploaded = false
                }
            
                s.saveCommentModelToLocal(serviceId, model: modelTuple.model)
        }
        
        
    }

    func submitComments(userID: String, userType: Int, commentList: [SingleComment], success: (responseData: RequestResult) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        let service = HttpCommentService()
        service.submitComments(userID, userType: userType, commentList: commentList, success: { (responseData) in
            let re = responseData
 
            if re.result {
                var serviceIds = [String]()
                
                for comment in commentList {
                    serviceIds.append(comment.service_id)
                }
                
                self.deleteCommentModel(serviceIds)
                
                success(responseData: re)
            }
            
        }) { (errType, errDes) in
            fail(errType: errType, errDes: errDes)

        }
    }
    
    private func createSearchKey(serviceId: String) -> String {
        return DefaultCommentManager.idPrefix + serviceId
    }
    
    private func ensureLocalModelListNotNil() {
        if localModelList == nil {
            localModelList = [ServiceCommentLocalSavedModel]()
        }
    }
    
    private func findImageInfo(imageId: String) -> ImageInfoModel? {
        guard let list = localModelList else {
            return nil
        }
        
        for service in list {
            for model in service.imageInfos {
                let m = model as! ImageInfoModel
                if m.imageId == imageId {
                    m.serviceId = service.serviceId
                    return m
                }
            }
        }
        
        return nil
    }
    
    private func findImageInfo(imageId: String, localModel: ServiceCommentLocalSavedModel) -> ImageInfoModel? {
        for model in localModel.imageInfos {
            if model.imageId == imageId {
                return model as? ImageInfoModel
            }
        }
        
        return nil
    }
    
//    private func findLocalModel(imageId: String) -> ServiceCommentLocalSavedModel? {
//        guard let list = localModelList else {
//            return nil
//        }
//        
//        for service in list {
//            for model in service.imageInfos {
//                let m = model as! ImageInfoModel
//                if m.imageId == imageId {
//                    m.serviceId = service.serviceId
//                    return service
//                }
//            }
//        }
//        
//        return nil
//    }
    
    private func findLocalComment(serviceId: String) -> (index: Int, model: ServiceCommentLocalSavedModel)? {
        guard let list = localModelList else {
            return nil
        }
        
        for i in 0..<list.count {
            let comment = list[i]
            if comment.serviceId == serviceId {
                return (i, comment)
            }
        }
        
        return nil
    }
    
    private func findNewComment(serviceId: String, newCommentList: [ServiceComment]) -> ServiceComment? {
        for comment in newCommentList {
            if comment.service_id == serviceId {
                return comment
            }
        }
        
        return nil
    }
}
