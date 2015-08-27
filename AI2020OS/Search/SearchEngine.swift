//
//  SearchEngine.swift
//  AI2020OS
//
//  Created by liliang on 15/5/23.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation

/*
*/


protocol SearchEngine {
    func searchServicesAndCatalogs(keyword: String, pageNum: Int, pageSize: Int, successRes: (responseData: AISearchServicesAndCatalogsResultModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
    func queryHotSearchedServices(completion: (([AICatalogItemModel], Error?)) -> Void)
    func getAllServiceCatalog(completion: (([AICatalogItemModel], Error?)) -> Void)
    func queryServices(catalogId: Int, pageNum: Int, pageSize: Int, completion: (([AIServiceTopicModel], Error?)) -> Void)
    func getFavorServices(pageNum: Int, pageSize: Int, completion: (([AIServiceTopicModel], Error?)) -> Void)
    func queryHotSearchedServices(successRes: (responseData: [AIServiceCatalogModel]) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
}

protocol SearchRecorder {
    func recordSearch(historyRecord: SearchHistoryRecord)
    func getSearchHistoryItems() -> [SearchHistoryRecord]
    func clearHistory()
}

