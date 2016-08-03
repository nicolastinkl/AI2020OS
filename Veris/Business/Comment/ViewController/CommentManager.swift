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
    // 记录上传图片，imageId:标识图片的id url:图片在本地的url
    func recordUploadImage(serviceId: String, imageId: String, url: NSURL)
    func notifyImageUploadResult(imageId: String, url: NSURL?)
    func isAllImagesUploaded() -> Bool
    func submitComments(userID: String, userType: Int, commentList: [ServiceComment], success: (responseData: RequestResult) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
}

class DefaultCommentManager: CommentManager {
    
    private static let idPrefix = "CommentViewModel_"
    
    var localModelList: [ServiceCommentLocalSavedModel]?
    
    func loadCommentModelsFromLocal(serviceIds: [String]) -> [ServiceCommentLocalSavedModel]? {
        for id in serviceIds {
            if let model = getCommentModelFromLocal(id) {
                ensureLocalModelListNotNil()
                
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
        }
        
        return nil
    }
    
    func saveCommentModelToLocal(serviceId: String, model: ServiceCommentLocalSavedModel) -> Bool {
        let defa = NSUserDefaults.standardUserDefaults()
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(model)
        
        defa.setObject(data, forKey: createSearchKey(serviceId))
        return defa.synchronize()
    }
    
    // 记录上传图片，imageId:标识图片的id url:图片在本地的url
    func recordUploadImage(serviceId: String, imageId: String, url: NSURL) {
        ensureLocalModelListNotNil()
        
        var service: ServiceCommentLocalSavedModel!
        
        for s in localModelList! {
            if s.serviceId == serviceId {
                service = s
            }
        }
        
        if service == nil {
            service = ServiceCommentLocalSavedModel()
        }
        
        let info = ImageInfoModel()
        
        info.imageId = imageId
        info.url = url
        info.uploadFinished = false
        service.imageInfos.append(info)
    }
    
    func notifyImageUploadResult(imageId: String, url: NSURL?) {
        if let model = findImageInfo(imageId) {
            
            model.uploadFinished = true
            
            if let u = url {
                model.isSuccessUploaded = true
                model.url = u
            } else {
                model.isSuccessUploaded = false
            }
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
    
    func submitComments(userID: String, userType: Int, commentList: [ServiceComment], success: (responseData: RequestResult) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        let list = mergeCommentsData(commentList)
        
        let service = HttpCommentService()
        
        service.submitComments(userID, userType: userType, commentList: list, success: success, fail: fail)
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
                    return model
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
        
//        if let localList = localModelList {
//            for localComment in localList {
//                if findNewComment(localComment.serviceId) == nil {
//                    let c = ServiceComment()
//                    c.service_id = localComment.
//                    list.append(<#T##newElement: Element##Element#>)
//                }
//            }
//        }
        
        
        for comment in newCommentList {
            list.append(mergeComment(comment, local: findLocalComment(comment.service_id)))
        }
        
        return list
    }
    
    private func findLocalComment(serviceId: String) -> ServiceCommentLocalSavedModel? {
        guard let list = localModelList else {
            return nil
        }
        
        for comment in list {
            if comment.serviceId == serviceId {
                return comment
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
    
    private func mergeComment(newComment: ServiceComment, local: ServiceCommentLocalSavedModel?) -> ServiceComment {
        if newComment.photos == nil {
            newComment.photos = [CommentPhoto]()
        }
        
        let result = ServiceComment()
        
        result.rating_level = newComment.rating_level
        result.service_id = newComment.service_id
        result.spec_id = newComment.spec_id
        result.text = newComment.text
        result.photos = newComment.photos
        
        func isInPhotos(url: String, comment: ServiceComment) -> Bool {
            for photo in comment.photos as! [CommentPhoto] {
                guard let u = photo.url else {
                    continue
                }
                
                if u == url {
                    return true
                }
            }
            
            return false
        }
        
        if let l = local {
            for info in l.imageInfos {
                guard let u = info.url else {
                    continue
                }
                
                if !isInPhotos(u.absoluteString, comment: result) {
                    let p = CommentPhoto()
                    p.url = u.absoluteString
                    result.photos.append(p)
                }
            }
        }
  
        return result
    }
}
