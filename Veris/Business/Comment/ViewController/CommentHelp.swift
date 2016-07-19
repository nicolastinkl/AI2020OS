//
//  CommentUtils.swift
//  AIVeris
//
//  Created by Rocky on 16/6/17.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

class CommentUtils {
    private static var starDesMap: [String: String]?
    
    static var hasStarDesData: Bool {
        get {
            return starDesMap != nil
        }
    }
    
    class func setStarDesData(starList: [StarDesc]) {
        starDesMap = [String: String]()
        
        for data in starList {
            starDesMap![data.numbers] = data.desc
        }
    }
}
