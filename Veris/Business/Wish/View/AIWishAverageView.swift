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
    private var prePosition: CGPoint = CGPointMake(0, 0)
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            prePosition = touch.locationInView(button)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let currentPosition = touch.locationInView(button)
            
            let deltaX = fabsf(Float(prePosition.x - currentPosition.x));
            
            print("\(currentPosition.x)   \(deltaX)")
            
        }
    }
    
    
}