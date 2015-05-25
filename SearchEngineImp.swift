//
//  SearchEngineImp.swift
//  AI2020OS
//
//  Created by liliang on 15/5/23.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation

// 模拟的SearchEngine，用于Demo
class MockSearchEngine : SearchEngine, SearchRecorder {
    
    var recordList = [SearchHistoryRecord]()
    var hotServiceList = [ServiceModel]()
    
    init() {
        var service = ServiceModel()
        service.name = "美容"
        hotServiceList.append(service)
        
        service = ServiceModel()
        service.name = "理财"
        hotServiceList.append(service)
        
        service = ServiceModel()
        service.name = "租房"
        hotServiceList.append(service)
        
        service = ServiceModel()
        service.name = "服饰搭配"
        hotServiceList.append(service)
        
        service = ServiceModel()
        service.name = "保洁"
        hotServiceList.append(service)
    }
    
    func searchServiceByText(serviceName: String) -> [ServiceModel]? {
        return [ServiceModel]()
    }
    
    func queryHotSearchedServices() -> [ServiceModel] {
        return hotServiceList
    }
    
    func recordSearch(searchRecord: SearchHistoryRecord) {
        recordList.append(searchRecord)
    }
    
    func getSearchHistoryItems() -> [SearchHistoryRecord]? {
        return recordList
    }
    
}

