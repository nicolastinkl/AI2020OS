//
//  AIJobSurveyModel.swift
//  AIVeris
//
//  Created by 王坜 on 16/8/10.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIJobStatus: NSObject {
    var type: NSNumber?
    var statusDescription: String?

}

class AIJobAction: NSObject {
    var type: NSNumber?
    var actionDescription: String?
}

class AIJobSurveyModel: NSObject {
    var jobIcon: String?
    var jobDescription: String?
    var jobStatus: AIJobStatus?
    var jobAction: AIJobAction?
}
