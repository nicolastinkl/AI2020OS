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
    func searchServiceByText(serviceName: String) -> [ServiceModel]
    func queryHotSearchedServices() -> ([AICatalogItemModel], Error?)
    func queryHotSearchedServices(completion: (([AICatalogItemModel], Error?)) -> Void)
}

protocol SearchRecorder {
    func recordSearch(historyRecord: SearchHistoryRecord)
    func getSearchHistoryItems() -> [SearchHistoryRecord]
}
