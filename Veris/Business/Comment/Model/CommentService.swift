//
//  CommentService.swift
//  AIVeris
//
//  Created by Rocky on 16/7/11.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation


protocol CommentService {
    func getProposalList(success: (responseData: ProposalOrderListModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void)

}
