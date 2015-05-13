//
//  AIUIViewUtils.swift
//  AI2020OS
//
//  Created by tinkl on 8/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation


extension UIView {
    func getViewByTag(tag:Int) -> UIView{
        
        let thisView = self.subviews.filter({(view:AnyObject)->Bool in
            let someView = view as UIView
            return someView.tag == tag
        })
        
        return thisView.last as UIView
    }
}