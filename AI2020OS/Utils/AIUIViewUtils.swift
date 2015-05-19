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
    
    /*!
        圆角处理
    */
    func maskWithEllipse() {
        
        var maskLayer = CALayer()
        maskLayer.frame = CGRectMake(
            0, 0, self.bounds.width, self.bounds.height)
        maskLayer.contents = UIImage(named: "profileview_avatar_mask")?.CGImage
        self.layer.mask = maskLayer
        
    }
    
    /*!
    虚线处理
    */
    func addDashedBorder() {
        let color = UIColor(rgba: "#a7a7a7").CGColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 0.5
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [2,1]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 0).CGPath
        
        self.layer.addSublayer(shapeLayer)
        
    }
}