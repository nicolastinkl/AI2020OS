//
//  AICommentInfoModel.swift
//  AIVeris
//
//  Created by asiainfo on 7/21/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import SwiftyJSON

//评论
/*
 "good_rate":"100.00",
 "customer_icon":"http://7xq9bx.com1.z0.glb.clouddn.com/fileAmy.png",
 "customer_name":"王红",
 "date":1472105243498,
 "desc":"非常贴心",
 "images":[
 ],
 "thumbs":1,
 "stars":5
 */
struct AICommentInfoModel: JSONJoy {
    
    var time: Double?
    
    var providename: String?
    
    var provideurl: String?
    
    var descripation: String?
    
    var images: [[String: String]]?
    
    var level: Int = 0
    
    var commentid: Int = 345
    
    var like: Int = 2523
    
    var commentcount: Int = 778
    
    init(_ decoder: JSONDecoder) {
        time = decoder["date"].double ?? 0
        providename = decoder["customer_name"].string ?? ""
        provideurl = decoder["customer_icon"].string ?? ""
        descripation = decoder["desc"].string ?? ""
        level = (decoder["good_rate"].string ?? "0").toInt() ?? 0
        
        like = decoder["stars"].integer ?? 0
        commentcount = decoder["thumbs"].integer ?? 0
        decoder["images"].getArray(&images)
    }
    
    init() {
        
    }
    
}
