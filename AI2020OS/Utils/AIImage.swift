//
//  AIImage.swift
//  AI2020OS
//
//  Created by tinkl on 21/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

extension UIImage {
    
    class func imageWithColor(color: UIColor) -> UIImage {
        var rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        
        var context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        
        var image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext();
        
        return image
    }
    
}
