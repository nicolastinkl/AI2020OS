//
//  SearchEngineImp.swift
//  AI2020OS
//
//  Created by liliang on 15/5/23.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import JSONJoy

// 模拟的SearchEngine，用于Demo
class MockSearchEngine : SearchEngine, SearchRecorder {

    private var recordList = [SearchHistoryRecord]()
    private var hotServiceList = [AICatalogItemModel]()
    private var allCatalogList = [AICatalogItemModel]()
    private var queryServices = [AIServiceTopicModel]()
    
    init() {
        initServiceData()
    }
    
    func searchServiceByText(serviceName: String) -> [ServiceModel] {
        return [ServiceModel]()
    }
    
    func queryHotSearchedServices() -> ([AICatalogItemModel], Error?) {
        return (hotServiceList, nil)
    }
    
    func queryHotSearchedServices(completion: (([AICatalogItemModel], Error?)) -> Void) {
        completion((hotServiceList, nil))
    }
    
    func getAllServiceCatalog(completion: (([AICatalogItemModel], Error?)) -> Void) {
        completion((allCatalogList, nil))
    }

    func queryServices(catalogId: Int, pageNum: Int, pageSize: Int, completion: (([AIServiceTopicModel], Error?)) -> Void) {
        completion((queryServices, nil))
    }
    
    func recordSearch(searchRecord: SearchHistoryRecord) {
        recordList.append(searchRecord)
    }
    
    func getSearchHistoryItems() -> [SearchHistoryRecord] {
        return recordList
    }
    
    func getFavorServices(pageNum: Int, pageSize: Int, completion: (([AIServiceTopicModel], Error?)) -> Void) {
        var list = [AIServiceTopicModel]()
        var service = AIServiceTopicModel()
        service.service_name = "去上海出差"
        service.service_intro_url = "http://www.czgu.com/uploads/allimg/140904/0644594560-0.jpg"
        service.contents.append("机票")
        service.contents.append("住宿")
        service.contents.append("接机")
        service.contents.append("宠物寄养")
        service.isFavor = true
        service.tags.append("工作")
        
        list.append(service)
        
        service = AIServiceTopicModel()
        service.service_name = "做个柔软的胖子"
        service.service_intro_url = "http://brand.gzmama.com/attachments/gzmama/2012/09/8111699_2012091611055819bgd.jpg"
        service.contents.append("场地")
        service.contents.append("瑜伽教练")
        service.isFavor = false
        service.tags.append("健身")
        list.append(service)
        
        service = AIServiceTopicModel()
        service.service_name = "周末打羽毛球"
        service.service_intro_url = "http://photocdn.sohu.com/20110809/Img315878985.jpg"
        service.contents.append("场地")
        service.contents.append("教练")
        service.isFavor = true
        service.tags.append("健身")
        list.append(service)
        
        service = AIServiceTopicModel()
        service.service_name = "家宴"
        service.service_intro_url = "http://hunjia.shangdu.com/file/upload/201403/20/16-39-25-78-972.jpg"
        service.contents.append("大厨")
        service.contents.append("食物代购")
        service.isFavor = false
        service.tags.append("生活")
        list.append(service)
        
        service = AIServiceTopicModel()
        service.service_name = "同学聚会"
        service.service_intro_url = "http://photocdn.sohu.com/20150603/mp17561615_1433325849459_1.jpeg"
        service.contents.append("场地")
        service.contents.append("食物代购")
        service.contents.append("代驾")
        service.contents.append("专车")
        service.isFavor = true
        service.tags.append("生活")
        list.append(service)
        completion((list, nil))
    }
    
    private func initServiceData() {
        var service = AICatalogItemModel()
        service.catalog_name = "美容"
        hotServiceList.append(service)
        
        service = AICatalogItemModel()
        service.catalog_name = "理财"
        hotServiceList.append(service)
        
        service = AICatalogItemModel()
        service.catalog_name = "租房"
        hotServiceList.append(service)
        
        service = AICatalogItemModel()
        service.catalog_name = "服饰搭配"
        hotServiceList.append(service)
        
        service = AICatalogItemModel()
        service.catalog_name = "保洁"
        hotServiceList.append(service)
    }
    
//    private func initHistoryData() {
//        var record = SearchHistoryRecord(searchName: "")
//    }
}


class HttpSearchEngine : SearchEngine {

    var isLoading : Bool = false
    
    private var recordList = [SearchHistoryRecord]()
    private var hotServiceList = [AICatalogItemModel]()
    
    func searchServiceByText(serviceName: String) -> [ServiceModel] {
        return [ServiceModel]()
    }
    
    func queryHotSearchedServices() -> ([AICatalogItemModel], Error?) {
        if isLoading {
        //    return (hotServiceList, nil)
        }
        
        var listModel :AICatalogListModel?
        
        isLoading = true
        
        var responseError:Error?
        AIHttpEngine.postWithParameters(AIHttpEngine.ResourcePath.QueryHotSearch, parameters: nil) {  [weak self] (response, error) -> () in
            responseError = error
            if let strongSelf = self{
                strongSelf.isLoading = false
            }
            if let responseJSON: AnyObject = response {
                listModel =  AICatalogListModel(JSONDecoder(responseJSON))
                
                if let strongSelf = self {
                    strongSelf.hotServiceList = listModel!.catalogArray
                }
                
            }else{

            }
        }
        
        return (hotServiceList, responseError)
    }
    
    func queryHotSearchedServices(completion: (([AICatalogItemModel], Error?)) -> Void) {
        if isLoading {
            return
        }
        
        var listModel: AICatalogListModel?
        
        isLoading = true
        
        var responseError:Error?
        AIHttpEngine.postWithParameters(AIHttpEngine.ResourcePath.QueryHotSearch, parameters: nil) {  [weak self] (response, error) -> () in
            responseError = error
            if let strongSelf = self{
                strongSelf.isLoading = false
            }
            if let responseJSON: AnyObject = response {
                listModel =  AICatalogListModel(JSONDecoder(responseJSON))
            }
            
            if listModel == nil {
                listModel = AICatalogListModel()
            }
            
            completion((listModel!.catalogArray, error))
        }
        
    }
    
    func getAllServiceCatalog(completion: (([AICatalogItemModel], Error?)) -> ()) {
        if isLoading {
            return
        }
        
        var listModel :AICatalogListModel?
        
        isLoading = true
        
        var responseError:Error?
        AIHttpEngine.postWithParameters(AIHttpEngine.ResourcePath.GetAllServiceCatalog, parameters: nil) {  [weak self] (response, error) -> () in
            responseError = error
            if let strongSelf = self{
                strongSelf.isLoading = false
            }
            if let responseJSON: AnyObject = response {
                listModel =  AICatalogListModel(JSONDecoder(responseJSON))
            }
            
            if listModel == nil {
                listModel = AICatalogListModel()
            }
            
            completion((listModel!.catalogArray, error))
        }

    }
    
    func queryServices(catalogId: Int, pageNum: Int, pageSize: Int = 1, completion: (([AIServiceTopicModel], Error?)) -> Void) {
        if isLoading {
            return
        }
        
        var listModel :AICatalogServicesResult?
        
        isLoading = true
        
        var responseError:Error?
        AIHttpEngine.postWithParameters(AIHttpEngine.ResourcePath.QueryServiceItemsByCatalogId, parameters: ["page_num":pageNum, "catalog_id":catalogId, "page_size": pageSize]) {  [weak self] (response, error) -> () in
            responseError = error
            if let strongSelf = self{
                strongSelf.isLoading = false
            }
            if let responseJSON: AnyObject = response {
                listModel =  AICatalogServicesResult(JSONDecoder(responseJSON))
            }
            
            if listModel == nil {
                listModel = AICatalogServicesResult()
            }
            
            completion((listModel!.services, error))
        }

    }
    
    func getFavorServices(pageNum: Int, pageSize: Int, completion: (([AIServiceTopicModel], Error?)) -> Void) {
        let list = [AIServiceTopicModel]()
        var service = AIServiceTopicModel()
        
    //    list.
        completion((list, nil))
    }
    
}


