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
    
    func submitComments(serviceId: Int, tags: [AICommentTag]?, commentText: String, success: () -> Void, fail: (errType: AINetError, errDes: String) -> Void)
}
