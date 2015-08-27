//
//  AIServiceCommentManagerImp.swift
//  AI2020OS
//  服务评论实现类
//  Created by Rocky on 15/8/17.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIServiceCommentMockManager :AIServiceCommentManager {

    func getCommentTags(serviceId: Int, success: (responseData: AIServiceCommentListModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        var list = AIServiceCommentListModel()
        list.service_comment_list = NSMutableArray()
        
        var comment = AIServiceComment()
        comment.service_id = 2356
        comment.service_name = "Massa的家庭保洁"
        comment.provider_portrait_url = "http://www.czgu.com/uploads/allimg/140904/0644594560-0.jpg"
        list.service_comment_list!.addObject(comment)
        
        comment.comment_tags = NSMutableArray()
        
        var tag = AICommentTag()
        tag.content = "准时"
        comment.comment_tags!.addObject(tag)
        
        tag = AICommentTag()
        tag.content = "态度好"
        comment.comment_tags!.addObject(tag)
        
        tag = AICommentTag()
        tag.content = "工具专业"
        comment.comment_tags!.addObject(tag)
        
        tag = AICommentTag()
        tag.content = "打扫得干净"
        comment.comment_tags!.addObject(tag)
        
        tag = AICommentTag()
        tag.content = "一般般"
        comment.comment_tags!.addObject(tag)

        success(responseData: list)

    }
    
    func submitComments(serviceId: Int, comments: [AICommentTag], success: () -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        success()
    }
}

class AIHttpServiceCommentManager: AIServiceCommentMockManager {
    override func submitComments(serviceId: Int, comments: [AICommentTag], success: () -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        success()
        
        var url: String = ""
    }
}
