//
//  AIUserModel.swift
//  AI2020OS
//
//  Created by admin on 8/24/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

import JSONJoy

///  用户详细信息
class AIUserModel: JSONJoy {
    
    var id: Int?
    var name: String?
    var openid: String?
    var mobilenumber: String?
    var imageurl: String?
    
    init() {
        
    }
    
    required init(_ decoder: JSONDecoder) {
        
        id = decoder["id"].integer
        name = decoder["name"].string
        openid = decoder["openid"].string
        mobilenumber = decoder["mobilenumber"].string
        imageurl = decoder["imageurl"].string
    }
}

///  用户详细信息
class AIUserInfoModel: JSONJoy {
    var user_id: Int?
    var user_name: String?
    var email: String?
    var phone: String?
    var wx_openid: String?
    var imageurl: String?
    
    init() {
        
    }

    required init(_ decoder: JSONDecoder) {
        
        user_id = decoder["user_id"].integer
        user_name = decoder["user_name"].string
        email = decoder["email"].string
        phone = decoder["phone"].string
        wx_openid = decoder["wx_openid"].string
        imageurl = decoder["image_url"].string ?? "http://weico.u.qiniudn.com/32a477dffd877aa097d1d108efe42ca8_2834027910889238568_1414566053_356086_1012x1800?imageView2/1/w/640/h/320"
    }
    
}

