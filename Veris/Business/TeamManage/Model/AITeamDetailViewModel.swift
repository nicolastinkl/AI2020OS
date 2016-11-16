//
//  AITeamDetailViewModel.swift
//  AIVeris
//
//  Created by 刘先 on 16/11/15.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation


class AITeamDetailViewModel: AIBaseViewModel {
    var detailIcon: String?
    var detailContent: String?
    
    init(detailIcon: String, detailContent: String) {
        self.detailIcon = detailIcon
        self.detailContent = detailContent
    }
}

class AITeamDetailUserViewModel: AIBaseViewModel {
    var userIcon: String?
    var userName: String?
    
    init(userIcon: String, userName: String) {
        self.userIcon = userIcon
        self.userName = userName
    }
}
