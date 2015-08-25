//
//  AIEffectView.swift
//  AITrans
//
//  Created by admin on 6/24/15.
//  Copyright (c) 2015 __ASIAINFO__. All rights reserved.
//

import Foundation
import UIKit

class AIEffectView: UIView {
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    init(frame: CGRect, type:CommonCellBackgroundViewType,row: Int) {
        
        super.init(frame: frame)
        
        self.backgroundColor =  UIColor(hex: "#848291")
        
//        self.backgroundColor =  UIColor.clearColor()
        
        //self.alpha = 0.9
        
        var imageName = "bg_top_\(row)"
        
        //let newImage = UIImage(named: imageName)?.blurryImagewithBlurLevel(0.5)
        //self.layer.contents = UIImage(named: imageName)?.CGImage
        
        var image = UIColor.clearColor().imageWithColor()
        self.layer.contents = image.CGImage
        self.layer.opacity = 1
        
        if type == CommonCellBackgroundViewType.GroupFirst {
            self.setCornerOnTop()
        }
        
        if type == CommonCellBackgroundViewType.GroupLast {
            self.setCornerOnBottom()
        }
        
        if type == CommonCellBackgroundViewType.GroupSingle {
            self.setCornerOnAll()
        }
        
        if type == CommonCellBackgroundViewType.GroupMiddle{
            self.setCornerOnNone()
        }
        
    }
    
}