//
//  AICommentTag.swift
//  AI2020OS
//  服务评价标签
//  Created by Rocky on 15/8/17.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIServiceCommentTagList: JSONModel {
    var service_comment_list: NSMutableArray?
}

class AIServiceComment: JSONModel {
    var service_id : Int?
    var service_name : NSString?
    var provider_portrait_url : NSString?
    var comment_tags : NSMutableArray?
    
}

class AICommentTag: JSONModel {
    var content : NSString?
}
