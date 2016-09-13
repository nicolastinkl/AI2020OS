//
//  AppUtils.swift
//  AIVeris
//
//  Created by Rocky on 16/7/29.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation


class AppUtils: NSObject {
    /*!
     Application hook viewdidload
     */
    static func hookViewDidLoad() {
        swizzlingMethod(UIViewController.self,
                        oldSelector: #selector(UIViewController.viewDidLoad),
                        newSelector: #selector(UIViewController.viewDidLoadForChangeTitleColor))
    }
    
    /*!
     Application hookViewDesLoad
     */
    static func hookViewWillAppear() {
        swizzlingMethod(UIViewController.self,
                        oldSelector: #selector(UIViewController.viewDidAppear(_:)),
                        newSelector: #selector(UIViewController.viewWillAppearForShowBottomBar(_:)))
    }
    
    static func hookViewWillDisappear() {
        swizzlingMethod(UIViewController.self,
                        oldSelector: #selector(UIViewController.viewWillDisappear(_:)),
                        newSelector: #selector(UIViewController.viewWillDisappearForHiddenBottomBar(_:)))
    }
    
    static func swizzlingMethod(clzz: AnyClass, oldSelector: Selector, newSelector: Selector) {
        let oldMethod = class_getInstanceMethod(clzz, oldSelector)
        let newMethod = class_getInstanceMethod(clzz, newSelector)
        method_exchangeImplementations(oldMethod, newMethod)
    }
}
