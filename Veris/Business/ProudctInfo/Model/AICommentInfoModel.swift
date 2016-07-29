//
//  AICommentInfoModel.swift
//  AIVeris
//
//  Created by asiainfo on 7/21/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import SwiftyJSON

struct AICommentInfoModel: JSONJoy {
    
    var time: Double?
    
    var providename: String?
    
    var descripation: String?
    
    var images: [String]?
    
    var level: Int = 0
    
    var commentid: Int = 345
    
    var like: Int = 2523
    
    var commentcount: Int = 778
    
    init(_ decoder: JSONDecoder) {
        
    }
    
    init() {
        
    }
    
}
