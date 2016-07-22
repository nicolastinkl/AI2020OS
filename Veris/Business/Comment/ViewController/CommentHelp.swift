//
//  CommentUtils.swift
//  AIVeris
//
//  Created by Rocky on 16/6/17.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

class CommentUtils {
    private static var starDes: [StarDesc]?
    
    static var hasStarDesData: Bool {
        get {
            return starDes != nil
        }
    }
    
    class func setStarDesData(starList: [StarDesc]) {
        starDes = starList  
    }
}
