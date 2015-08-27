//
//  AIServicesRequester.swift
//  AI2020OS
//
//  Created by tinkl on 22/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import  JSONJoy

/*!
*  @author tinkl, 15-04-22 17:04:51
*
*  服务列表请求类
*/
class AIServicesRequester {
    typealias ServicesRequesterCompletion = (data:[AIServiceTopicListModel]) ->()
    
    private (set) var hasMore : Bool = false
    private var page : Int = 1
    private var isLoading : Bool = false
    
    func load(page: Int = 1, completion: ServicesRequesterCompletion) {
        
        if isLoading {
            return
        }
        
        isLoading = true
        
        let params = ["page_size":"10","catalog_id": "1600","page_no": "1","user_id": "10000384"]
        AIHttpEngine.postRequestWithParameters(AIHttpEngine.ResourcePath.GetServicesTopic, parameters: params) {  [weak self] (response, error) -> () in
            if let strongSelf = self{
                strongSelf.isLoading = false                
            }
            if let responseJSON: AnyObject = response{
                let service =  AIServiceTopicListModel(JSONDecoder(responseJSON))
                completion(data: [service] )
            }else{
                completion(data: [])
            }
        }
        
    }
    
    func next(completion: (services:[AIServiceTopicListModel]) ->()) {
        if isLoading {
            return
        }
        
        ++page
        load(page: page, completion)
    }
    
    func loadServiceDetail(server_id:Int?,service_type:Int?,completion:(data:AIServiceDetailModel) ->()){
        
        AIHttpEngine.postRequestWithParameters(AIHttpEngine.ResourcePath.GetServiceDetail, parameters: ["service_id":server_id!,"service_type":service_type!]) {   (response, error) -> () in
            
            if let responseJSON: AnyObject = response{
                let service =  AIServiceDetailModel(JSONDecoder(responseJSON))
                completion(data: service)
            }else{
                completion(data: AIServiceDetailModel())
            }
        }
        
    }
}