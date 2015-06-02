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

    func queryServices(catalogId: Int, pageNum: Int, completion: (([AIServiceTopicModel], Error?)) -> Void) {
        completion((queryServices, nil))
    }
    
    func recordSearch(searchRecord: SearchHistoryRecord) {
        recordList.append(searchRecord)
    }
    
    func getSearchHistoryItems() -> [SearchHistoryRecord] {
        return recordList
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


class HttpSearchEngine : SearchEngine, SearchRecorder {

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
    
    func queryServices(catalogId: Int, pageNum: Int, completion: (([AIServiceTopicModel], Error?)) -> Void) {
        if isLoading {
            return
        }
        
        var listModel :AICatalogServicesResult?
        
        isLoading = true
        
        var responseError:Error?
        AIHttpEngine.postWithParameters(AIHttpEngine.ResourcePath.QueryServiceItemsByCatalogId, parameters: ["page_num":pageNum, "order_role":catalogId]) {  [weak self] (response, error) -> () in
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
    
    func recordSearch(searchRecord: SearchHistoryRecord) {
        recordList.append(searchRecord)
    }
    
    func getSearchHistoryItems() -> [SearchHistoryRecord] {
        return recordList
    }
    
}


