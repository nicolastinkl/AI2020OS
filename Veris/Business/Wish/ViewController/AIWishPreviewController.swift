//
//  AIWishPreviewController.swift
//  AIVeris
//
//  Created by tinkl on 8/9/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

import Spring
import Cartography

class AIWishPreviewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if let navi = AINavigationBar.initFromNib() as? AINavigationBar {
            view.addSubview(navi)
            navi.holderViewController = self
            constrain(navi, block: { (layout) in
                layout.left == layout.superview!.left
                layout.top == layout.superview!.top
                layout.right == layout.superview!.right
                layout.height == 44.0 + 10.0
            })
            navi.titleLabel.font = AITools.myriadLightWithSize(24)
            navi.titleLabel.text = "Make a wish"
            
        }

    }
}
