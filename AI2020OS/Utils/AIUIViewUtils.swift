//
//  AIUIViewUtils.swift
//  AI2020OS
//
//  Created by tinkl on 8/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring

extension UIView {
    
    /*!
        根据tag 获取视图对象
    */
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
    
    /*!
        处理加载展示
    */
    public func showProgressViewLoading() {
        
        if let loadingXibView = self.viewWithTag(AIApplication.AIViewTags.loadingProcessTag) {
            // If loading view is already found in current view hierachy, do nothing
            return
        }
        
        let loadingXibView:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)!
        loadingXibView.frame = self.bounds
        loadingXibView.tag = AIApplication.AIViewTags.loadingProcessTag
        loadingXibView.color = UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor)
        loadingXibView.hidesWhenStopped = true
        self.addSubview(loadingXibView)

        loadingXibView.startAnimating()
        
        loadingXibView.alpha = 0
        spring(0.7, {
            loadingXibView.alpha = 1
        })
    }
    
    /*!
        处理加载隐藏
    */
    public func hideProgressViewLoading() {
        
        if let loadingXibView = self.viewWithTag(AIApplication.AIViewTags.loadingProcessTag) {
            loadingXibView.alpha = 1
            let viewss = loadingXibView as UIActivityIndicatorView
            springWithCompletion(0.7, {
                loadingXibView.alpha = 0
                viewss.stopAnimating()
                loadingXibView.transform = CGAffineTransformMakeScale(1.5, 1.5)
                }, { (completed) -> Void in
                    loadingXibView.removeFromSuperview()
            })
        }
    }
    
    
}