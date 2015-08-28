//
//  AIServiceCommentManager.swift
//  AI2020OS
//  服务评论
//  Created by Rocky on 15/8/17.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation

protocol AIServiceCommentManager {
    func getCommentTags(serviceId: Int, success: (responseData: AIServiceCommentListModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
    
    // 提交评价
    // tags:选中的标签
    // commentText:文字评价
    // rate:评级,字符串表示的浮点型，范围0.0-1.0
    func submitComments(serviceId: Int, tags: [AICommentTag]?, commentText: String, rate: String?, success: () -> Void, fail: (errType: AINetError, errDes: String) -> Void)
}
