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
    func getCommentModelFromLocal(serviceId: String) -> ServiceCommentLocalSavedModel? 
    func saveCommentModelToLocal(serviceId: String, model: ServiceCommentLocalSavedModel) -> Bool
    func deleteCommentModel(serviceIds: [String])
    // 记录上传图片，imageId:标识图片的id url:图片在本地的url
    func recordUploadImage(serviceId: String, imageId: String, url: NSURL)
    func notifyImageUploadResult(imageId: String, url: NSURL?)
    func isAllImagesUploaded() -> Bool
    func submitComments(userID: String, userType: Int, commentList: [SingleComment], success: (responseData: RequestResult) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
}

class DefaultCommentManager: CommentManager {
    
    private static let idPrefix = "CommentViewModel_"
    
    var localModelList: [ServiceCommentLocalSavedModel]?
    
    func loadCommentModelsFromLocal(serviceIds: [String]) -> [ServiceCommentLocalSavedModel]? {
        
        func deleteInvalideImages(model: ServiceCommentLocalSavedModel) -> ServiceCommentLocalSavedModel? {
            var newModel: ServiceCommentLocalSavedModel?
                
            let valideImages = model.imageInfos.filter { (info) -> Bool in
                guard let url = info.url else {
                    return false
                }
                
                return imageIsExist(url)
            }
            
            if valideImages.count != model.imageInfos.count {
                newModel = model
                newModel!.imageInfos = valideImages
            }
            
            return newModel
        }
        
        for id in serviceIds {
            if let model = getCommentModelFromLocal(id) {
                ensureLocalModelListNotNil()
                
                if let newModel = deleteInvalideImages(model) {
                    // 重写过滤无用图片后的评论数据
                    saveCommentModelToLocal(id, model: newModel)
                    localModelList?.append(newModel)
                } else {
                    localModelList?.append(model)
                }   
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
            let m = ServiceCommentLocalSavedModel()
            m.serviceId = serviceId
            return m
        }
    }
    
    private func imageIsExist(url: NSURL) -> Bool {
        
        var exist = AssetUtils.assetExists(url)
        
        if !exist {
            let fileManager = NSFileManager.defaultManager()
            exist = fileManager.fileExistsAtPath(url.absoluteString)
        }
        
        return exist
    }
    
    func saveCommentModelToLocal(serviceId: String, model: ServiceCommentLocalSavedModel) -> Bool {
        let defa = NSUserDefaults.standardUserDefaults()
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(model)
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
            
            if service == nil {
                service = ServiceCommentLocalSavedModel()
                service.serviceId = serviceId
            }
            
            let info = ImageInfoModel()
            
            info.imageId = imageId
            info.url = url
            info.uploadFinished = false
            service.imageInfos.append(info)
            
            s.saveCommentModelToLocal(serviceId, model: service)
        }
    }
    
    func notifyImageUploadResult(imageId: String, url: NSURL?) {
        Async.main {[weak self] in
            guard let s = self else {
                return
            }
            
            guard let model = s.findLocalModel(imageId) else {
                return
            }
            
            guard let imageInfo = s.findImageInfo(imageId, localModel: model) else {
                return
            }
            
                imageInfo.uploadFinished = true
                
                if url != nil {
                    imageInfo.isSuccessUploaded = true
                    // 只保存本地文件url
               //     imageInfo.url = u
                } else {
                    imageInfo.isSuccessUploaded = false
                }
            
                s.saveCommentModelToLocal(model.serviceId, model: model)
        }
        
        
    }
    
    func isAllImagesUploaded() -> Bool {
        if localModelList == nil {
            return true
        }
        
        for service in localModelList! {
            for info in service.imageInfos {
                if !info.uploadFinished {
                    return false
                }
            }
        }
        
        return true
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
            }
            
        }) { (errType, errDes) in


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
                if model.imageId == imageId {
                    model.serviceId = service.serviceId
                    return model
                }
            }
        }
        
        return nil
    }
    
    private func findImageInfo(imageId: String, localModel: ServiceCommentLocalSavedModel) -> ImageInfoModel? {
        for model in localModel.imageInfos {
            if model.imageId == imageId {
                return model
            }
        }
        
        return nil
    }
    
    private func findLocalModel(imageId: String) -> ServiceCommentLocalSavedModel? {
        guard let list = localModelList else {
            return nil
        }
        
        for service in list {
            for model in service.imageInfos {
                if model.imageId == imageId {
                    model.serviceId = service.serviceId
                    return service
                }
            }
        }
        
        return nil
    }
    
    // 将本次要提交的评价数据和以前已经编辑过，保存在本地，但还未提交的评价数据进行合并。
    // newCommentList: 本次要提交的新的评价列表
    // 返回: 合并过后的评价列表
    func mergeCommentsData(newCommentList: [ServiceComment]) -> [ServiceComment] {
        var list = [ServiceComment]()
        
//        for comment in newCommentList {
//            list.append(mergeComment(comment, local: findLocalComment(comment.service_id)?.model))
//        }
        
        return list
    }
    
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
    
//    private func mergeComment(newComment: ServiceComment, local: ServiceCommentLocalSavedModel?) -> ServiceComment {
//        if newComment.photos == nil {
//            newComment.photos = [CommentPhoto]()
//        }
//        
//        let result = ServiceComment()
//        
//        result.rating_level = newComment.rating_level
//        result.service_id = newComment.service_id
//        result.spec_id = newComment.spec_id
//        result.text = newComment.text
//        result.photos = newComment.photos
//        
//        func isInPhotos(url: String, comment: ServiceComment) -> Bool {
//            for photo in comment.photos as! [CommentPhoto] {
//                guard let u = photo.url else {
//                    continue
//                }
//                
//                if u == url {
//                    return true
//                }
//            }
//            
//            return false
//        }
//        
//        if let l = local {
//            for info in l.imageInfos {
//                guard let u = info.url else {
//                    continue
//                }
//                
//                if !isInPhotos(u.absoluteString, comment: result) {
//                    let p = CommentPhoto()
//                    p.url = u.absoluteString
//                    result.photos.append(p)
//                }
//            }
//        }
//  
//        return result
//    }
}
