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
        starDes = starList.sort { (star1, star2) -> Bool in
            return Float(star2.value_min)! > Float(star1.value_min)!
        }
    }
    
    class func convertPercentToStarValue(percent: CGFloat) -> CGFloat {
        guard let _ = starDes else {
            return percent
        }
        
        let value = convertPercentToValue(percent)
        
        return value
    }
    
    class func getStarValueDes(percent: CGFloat) -> String {
        func isInRange(value: CGFloat, star: StarDesc) -> Bool {
            let min = CGFloat(Float(star.value_min)!)
            let max = CGFloat(Float(star.value_max)!)
            
            if value <= max && value >= min {
                return true
            }
            return false
        }
        
        guard let stars = starDes else {
            return ""
        }
        
        let value  = convertPercentToValue(percent)
        for star in stars {
            if isInRange(value, star: star) {
                return star.name
            }
        }
        
        return ""
    }
    
    private class func getMaxValue() -> CGFloat {
        guard let stars = starDes else {
            return 1
        }
        
        let max = Float(stars.last!.value_max)!
        let value = CGFloat(max)
        return value
    }
    
    private class func convertPercentToValue(percent: CGFloat) -> CGFloat {
        return getMaxValue() * percent
    }
    
    class func isStarValueValid(value: String?) -> Bool {
        guard let v = value else {
            return false
        }
        
        if v.isEmpty {
            return false
        }
        
        guard let fv = Float(v) else {
            return false
        }
        
        if fv < 0.0001 {
            return false
        }
        
        return true
    }
}
