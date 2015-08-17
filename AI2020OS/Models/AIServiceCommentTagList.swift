//
//  AICommentTag.swift
//  AI2020OS
//  服务评价标签
//  Created by Rocky on 15/8/17.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIServiceCommentTagList :JSONModel {
    var content : String?
    var service_comment_list : [AIServiceComment]?
}

class AIServiceComment :JSONModel {
    var service_id : Int?
    var service_name : String?
    var provider_portrait_url : String?
    var comment_tags : [AICommentTag]?
    
}

class AICommentTag :JSONModel {
    var content : String?
}
