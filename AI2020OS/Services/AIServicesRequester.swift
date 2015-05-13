//
//  AIServicesRequester.swift
//  AI2020OS
//
//  Created by tinkl on 22/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

/*!
*  @author tinkl, 15-04-22 17:04:51
*
*  服务列表请求类
*/
class AIServicesRequester {
    typealias ServicesRequesterCompletion = (data:[Movie]) ->()
    
    private (set) var hasMore : Bool = false
    private var page : Int = 1
    private var isLoading : Bool = false
    
    func load(page: Int = 1, completion: ServicesRequesterCompletion) {
        
        if isLoading {
            return
        }
        
        isLoading = true
        AIHttpEngine.moviesForSection {  [weak self] movies  in
            if let strongSelf = self {
                strongSelf.isLoading = false
                completion(data: movies)
            }
        }
        
    }
    
    func next(completion: (stories:[Movie]) ->()) {
        if isLoading {
            return
        }
        
        ++page
        load(page: page, completion)
    }
}