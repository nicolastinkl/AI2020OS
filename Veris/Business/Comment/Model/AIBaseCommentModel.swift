//
//  AIBaseCommentModel.swift
//  AIVeris
//
//  Created by 王坜 on 16/8/9.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AICommentModel: NSObject {

    var serviceIconURL: NSURL?
    var serviceName: String?
    var starLevel: NSNumber?
    var comments: String?
    var commentPictures: [String]?
    var isAnonymous: Bool?
    var serviceModel: AICommentSeviceModel?

    var additionalComment: AICommentModel?
}



class AICommentSeviceModel: NSObject {
    var serviceIcon: String?
    var serviceName: String?
}
