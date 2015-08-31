//
//  AIAssignUtils.swift
//  AI2020OS
//
//  Created by tinkl on 10/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

extension String{

    /*!
        Auto get XXXViewController's idtifiter
    */
    func viewControllerClassName()->String{
        //NSStringFromClass(AINetworkLoadingViewController)
        let classNameSS = self.componentsSeparatedByString(".").last! as String
        return classNameSS;
    }
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
    
    func stringHeightWith(fontSize:CGFloat,width:CGFloat)->CGFloat
        
    {
        var font = UIFont.systemFontOfSize(fontSize)
        var size = CGSizeMake(width,CGFloat.max)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByWordWrapping;
        var  attributes = [NSFontAttributeName:font,
            NSParagraphStyleAttributeName:paragraphStyle.copy()]
        
        var text = self as NSString
        var rect = text.boundingRectWithSize(size, options:.UsesLineFragmentOrigin, attributes: attributes, context:nil)
        return rect.size.height
    }
     
    //TODO 以后还需判断是不是数字类型 add by liux
    func timestampStringToDateString() -> String{
        var strTime = self
        let doubleTime = (strTime as NSString).doubleValue
        let date = NSDate(timeIntervalSince1970: doubleTime)
        var dateFormatter2 = NSDateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter2.stringFromDate(date)
    }
}

extension Double{
    func dateStringFromTimestamp()->String
    {
        var ts = self
        var  formatter = NSDateFormatter ()
        formatter.dateFormat = "yyyy年MM月dd日 HH:MM:ss"
        var date = NSDate(timeIntervalSince1970 : ts)
        return  formatter.stringFromDate(date)
        
    }
}

extension Int{
    func toString() -> String{
        let returnString:String = "\(self)"
        return returnString
    }
}