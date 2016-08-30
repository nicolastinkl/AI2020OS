//
//  AIWishAverageView.swift
//  AIVeris
//
//  Created by tinkl on 8/10/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring
class AIWishAverageView: UIView {
 
    @IBOutlet weak var button: DesignableButton!
    
    @IBOutlet weak var totalButton: DesignableButton!
    /* 随着手触摸点移动button
    private var prePosition: CGPoint = CGPointMake(0, 0)
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            prePosition = touch.locationInView(self)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            
            
            let currentPosition = touch.locationInView(self)
            
//            let deltaX = fabsf(Float(prePosition.x - currentPosition.x))
//            let offset = button.left + button.width
//            if currentPosition.x > button.left && currentPosition.x < offset{
//                
//            }
            button.setLeft(currentPosition.x-button.width/2)
            
            
        }
    }*/
}
