//
//  AIWillPayService.swift
//  AIVeris
//
//  Created by asiainfo on 10/28/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation


class AIWillPayService: Object {
    
    class AIWillPayServiceModel: JSONModel {
        
        var aid: Int?
        var sname: String?
        var saddress: String?
        var simageurl: String?
        var sprice: String?
        var stime: Double?
        init() {
            
        }
        
    }
    
}
