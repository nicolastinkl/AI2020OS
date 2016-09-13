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
    
    var totalPrice: Int = 0
    var currentPrice: Int = 0

    
    @IBOutlet weak var button: DesignableButton!
    
    @IBOutlet weak var totalButton: DesignableButton!
    
    @IBOutlet weak var averageLabel: UILabel!
    
    @IBOutlet weak var rightRMB: UILabel!
    
    @IBOutlet weak var leftRMB: UILabel!
    
    @IBOutlet weak var inputPrice: UITextView!
    
    @IBOutlet weak var inputButtonView: UIView!
    
    //随着手触摸点移动button
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
            
            let buttonCenter = currentPosition.x - inputButtonView.width/2
            
            inputButtonView.setLeft(buttonCenter)
            
            let percent = buttonCenter/self.width
            
            let text = CGFloat(totalPrice * 2) * CGFloat(percent)
            
            inputPrice.text = String(Int(text))
            
        }
    }
}
