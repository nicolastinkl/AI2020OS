//
//  AIServiceCommentManagerImp.swift
//  AI2020OS
//  服务评论实现类
//  Created by Rocky on 15/8/17.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Alamofire

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
    
    func submitComments(serviceId: Int, tags: [AICommentTag]?, commentText: String, rate: String?, success: () -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        success()
    }
}

class AIHttpServiceCommentManager: AIServiceCommentMockManager {
    override func submitComments(serviceId: Int, tags: [AICommentTag]?, commentText: String, rate: String?, success: () -> Void, fail: (errType: AINetError, errDes: String) -> Void) {

/*Offering,
Product
*/
/*

"http://171.221.254.231:9000/c=addComments&WEB_HUB_PARAMS={\"data\":{\"commentParameter\":{\"targetObjectType\":\(targetObjectType),\"objectId\":\(serviceId),\"comments\":[{\"partyRoleId\":\(kUser_ID),\"contextComment\":{\"context\":\(commentText)},\"grades\":[{\"gradeValue\":5}]}]}},\"header\":{\"Content-Type\":\"application/json\"}}"
*/
        
        /*
        http://10.5.1.247:5095/HubCrmServlet?servicecode=addComments&WEB_HUB_PARAMS={%22data%22:{%22commentParameter%22:{%22targetObjectType%22:%22ProductTemplate%22,%22objectId%22:1440135524953,%22comments%22:[{%22partyRoleId%22:10012,%22contextComment%22:{%22context%22:%22PeterWang%22}}]}},%22header%22:{%22Content-Type%22:%22application/json%22}}
*/
        
        
        let targetObjectType = "Product"
        
      /*
        var url: String = "http://171.221.254.231:9000/c=addComments&WEB_HUB_PARAMS=%7B%22data%22:%7B%22commentParameter%22:%7B%22targetObjectType%22:%22\(targetObjectType)%22,%22objectId%22:\(serviceId),%22comments%22:[%7B%22partyRoleId%22:\(kUser_ID),%22contextComment%22:%7B%22context%22:%22\(commentText)%22%7D%7D]%7D%7D,%22header%22:%7B%22Content-Type%22:%22application/json%22%7D%7D"
*/
        var varRate = "1.0"
        
        if rate != nil {
            varRate = rate!
        }
        
        var url: String = "http://171.221.254.231:9000/c=addComments&WEB_HUB_PARAMS=%7B%22data%22:%7B%22commentParameter%22:%7B%22targetObjectType%22:%22\(targetObjectType)%22,%22objectId%22:\(serviceId),%22comments%22:[%7B%22partyRoleId%22:\(kUser_ID),%22grades%22:[%7B%22gradeValue%22:%22\(varRate)%22%7D],%22contextComment%22:%7B%22context%22:%22\(commentText)%22%7D%7D]%7D%7D,%22header%22:%7B%22Content-Type%22:%22application/json%22%7D%7D"

        Alamofire.request(.GET, NSURL(string: url)!, parameters:nil)
            .responseJSON { (_request, _response, JSON, error) in
                
                var result = false
                println("response: \(_response)")
                println("JSON: \(JSON)")
                
                if error != nil {
                    
                
                    fail(errType: AINetError.Format, errDes: error!.localizedDescription)
                    
                } else {
                    if let reponses = JSON as? NSDictionary {
                        if let dataValue = reponses["data"] as? NSDictionary{
                            let resultCode = dataValue["resultCode"] as String
                            if  resultCode == "1" {
                                result = true
                                success()
                            } else {
                                var errString = ""
                                if dataValue["result_msg"] != nil {
                                    errString = dataValue["result_msg"] as String
                                }
                                
                                fail(errType: AINetError.Format, errDes: errString)
                            }
                        } else {
                            fail(errType: AINetError.Format, errDes: "")
                        }
                    } else {
                        fail(errType: AINetError.Format, errDes: "")
                    }
                }
        }

    }
}
