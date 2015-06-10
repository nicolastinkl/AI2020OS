//
//  AIFavorServicesManager.swift
//  AI2020OS
//  收藏服务接口
//
//  Created by liliang on 15/6/9.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation

protocol AIFavorServicesManager {
    // 获取收藏服务列表
    func getFavoriteServices(pageNum: Int, pageSize: Int, completion: (([AIServiceTopicModel], Error?)) -> Void)
    // 按标签查询服务
    func queryFavoriteServices(tags: [String], completion: (([AIServiceTopicModel], Error?)) -> Void)
    // 改变收藏服务的状态。 状态：是否是我喜欢的
    func changeFavoriteServiceState(isFavor: Bool, completion: (Error?) -> Void)
    // 获取收藏服务标签
    func getServiceTags(completion: (([String], Error?)) -> Void)
}

class AIMockFavorServicesManager : AIFavorServicesManager {
    
    private var favorServices = [AIServiceTopicModel]()
    private var tags = NSMutableSet()
    
    init() {
        var service = AIServiceTopicModel()
        service.service_name = "去上海出差"
        service.service_intro_url = "http://www.czgu.com/uploads/allimg/140904/0644594560-0.jpg"
        service.contents.append("机票")
        service.contents.append("住宿")
        service.contents.append("接机")
        service.contents.append("宠物寄养")
        service.isFavor = true
        service.tags.append("工作")
        
        favorServices.append(service)
        tags.addObject(service.tags[0])
        
        service = AIServiceTopicModel()
        service.service_name = "做个柔软的胖子"
        service.service_intro_url = "http://brand.gzmama.com/attachments/gzmama/2012/09/8111699_2012091611055819bgd.jpg"
        service.contents.append("场地")
        service.contents.append("瑜伽教练")
        service.isFavor = false
        service.tags.append("健身")
        favorServices.append(service)
        tags.addObject(service.tags[0])
        
        service = AIServiceTopicModel()
        service.service_name = "周末打羽毛球"
        service.service_intro_url = "http://photocdn.sohu.com/20110809/Img315878985.jpg"
        service.contents.append("场地")
        service.contents.append("教练")
        service.isFavor = true
        service.tags.append("健身")
        favorServices.append(service)
        tags.addObject(service.tags[0])
        
        service = AIServiceTopicModel()
        service.service_name = "家宴"
        service.service_intro_url = "http://hunjia.shangdu.com/file/upload/201403/20/16-39-25-78-972.jpg"
        service.contents.append("大厨")
        service.contents.append("食物代购")
        service.isFavor = false
        service.tags.append("生活")
        favorServices.append(service)
        tags.addObject(service.tags[0])
        
        service = AIServiceTopicModel()
        service.service_name = "同学聚会"
        service.service_intro_url = "http://photocdn.sohu.com/20150603/mp17561615_1433325849459_1.jpeg"
        service.contents.append("场地")
        service.contents.append("食物代购")
        service.contents.append("代驾")
        service.contents.append("专车")
        service.isFavor = true
        service.tags.append("生活")
        favorServices.append(service)
        tags.addObject(service.tags[0])
    }
    
    func getFavoriteServices(pageNum: Int, pageSize: Int, completion: (([AIServiceTopicModel], Error?)) -> Void) {
        completion((favorServices, nil))
    }
    
    func queryFavoriteServices(tags: [String], completion: (([AIServiceTopicModel], Error?)) -> Void) {
        
        var tempList = [AIServiceTopicModel]()
        
        for service in favorServices {
                
            for tag in service.tags {
                
                func isInTags(srcTag: String, desTags: [String]) -> Bool {
                    if desTags.count == 0 {
                        return false
                    } else {
                        for tag in desTags {
                            if tag == srcTag {
                                return true
                            }
                        }
                        
                        return false
                    }
                }
                
                if isInTags(tag, tags) {
                    tempList.append(service)
                    break
                }
            }
        }
        
        completion((tempList, nil))
        
    }
    
    func changeFavoriteServiceState(isFavor: Bool, completion: (Error?) -> Void) {
        
    }
    
    func getServiceTags(completion: (([String], Error?)) -> Void) {
        
        var tagList = [String]()
        
        for obj in tags.allObjects {
            tagList.append(obj as String)
        }
        
        completion((tagList, nil))
    }
    
}