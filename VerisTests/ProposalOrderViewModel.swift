//
//  ProposalOrderViewModel.swift
//  AIVeris
//
//  Created by Rocky on 16/7/29.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation


class ProposalOrderViewModel {
    var isExpanded: Bool = false
    var model: ProposalOrderModel!
    
    init() {
        
    }
    
    init(model: ProposalOrderModel) {
        self.model = model
    }
}