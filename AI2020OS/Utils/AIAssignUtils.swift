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
    
}

extension Int{
//    func string -> String{
//        let returnString:String = "\(self)"
//        return returnString
//    }
}