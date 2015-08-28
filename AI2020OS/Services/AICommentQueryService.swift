//
//  AICommentQueryService.swift
//  AI2020OS
//
//  Created by admin on 8/28/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Alamofire
import JSONJoy



class AICommentQueryService {
    
    func queryServiceList(serviceID:Int){
        
        let url  = "http://171.221.254.231:9000/c=queryCommentTags&WEB_HUB_PARAMS=%7B%22data%22:%7B%22objectId%22:"+"\(serviceID)"+",%22objectType%22:%22Product%22%7D,%22header%22:%7B%22Content-Type%22:%22application/json%22%7D%7D"
        Alamofire.request(.GET, url).responseJSON { (request, response, JSON, error) -> Void in
            println(JSON)
        }
        
    }
}