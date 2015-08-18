//
//  AITimeLineServices.swift
//  AI2020OS
//
//  Created by admin on 8/17/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation 
import JSONJoy


class AITimeLineServices {
    
    private (set) var hasMore : Bool = false
    private var page : Int = 1
    private var isLoading : Bool = false
    
    typealias TimelineRequesterCompletion = (data:[AITimeLineModel]) ->()
    
    func queryAllTimeData(customerId: String, completion: TimelineRequesterCompletion){
        let paras = ["customerId":customerId]
        AIHttpEngine.postRequestWithParameters(AIHttpEngine.ResourcePath.QueryTimeLineServices, parameters: paras) {  [weak self] (response, error) -> () in
            
            if let strongSelf = self{
                strongSelf.isLoading = false
            }
            if let responseJSON: AnyObject = response{
                if let addrs = JSONDecoder(responseJSON).array {
                var catalogArray = Array<AITimeLineModel>()
                for subDecoder in addrs {
                    catalogArray.append(AITimeLineModel(subDecoder))
                }
                    completion(data: catalogArray)
                }
            }else{
                completion(data: [])
            }
            
        }
        

    }
}

