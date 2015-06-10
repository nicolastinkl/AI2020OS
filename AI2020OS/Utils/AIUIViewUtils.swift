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
    
    private struct AssociatedKeys {
        static var DescriptiveName = "AIAssociatedName_UIView"
    }
    
    var associatedName: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.DescriptiveName) as? String
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.DescriptiveName,
                    newValue as NSString?,
                    UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                )
            }
        }
    }
    
    
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
    Cell下线处理
    */
    func addBottomBorderLine() {
        let color = UIColor(rgba: "#a7a7a7").CGColor
        let lineLayer =  CALayer()
        lineLayer.backgroundColor = color
        let left = self.width*0.9/2
        lineLayer.frame = CGRectMake(20, self.height-1, self.width*0.9, 0.5)
        self.layer.addSublayer(lineLayer)
    }
    
    /*!
    Cell上线处理
    */
    func addTopBorderLine() {
        let color = UIColor(rgba: "#898989").CGColor
        let lineLayer =  CALayer()
        lineLayer.backgroundColor = color
        let left = self.width*0.9/2
        lineLayer.frame = CGRectMake(20, 1, self.width*0.9, 0.5)
        self.layer.addSublayer(lineLayer)
    }
    
    
    /*!
    Cell下线处理
    */
    func addBottomWholeBorderLine() {
        let color = UIColor(rgba: "#a7a7a7").CGColor
        let lineLayer =  CALayer()
        lineLayer.backgroundColor = color
        lineLayer.frame = CGRectMake(0, self.height-1, 85, 0.5)
        self.layer.addSublayer(lineLayer)
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
        loadingXibView.backgroundColor = UIColor.whiteColor()
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
            if let viewss = loadingXibView as? UIActivityIndicatorView{
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
    
    /*!
        显示错误视图
    */
    public func showErrorView(){
        if let loadingXibView = self.viewWithTag(AIApplication.AIViewTags.errorviewTag) {
            // If loading view is already found in current view hierachy, do nothing
            return
        }
        
        let errorview = AIErrorRetryView.currentView()
        errorview.tag = AIApplication.AIViewTags.errorviewTag
        errorview.center = self.center
        self.addSubview(errorview)
        
        errorview.alpha = 0
        spring(0.7, {
            errorview.alpha = 1
        })
        
    }
    
    
    /*!
        隐藏错误视图
    */
    public func hideErrorView(){
        if let loadingXibView = self.viewWithTag(AIApplication.AIViewTags.errorviewTag) {
            loadingXibView.alpha = 1
            springWithCompletion(0.7, {
                loadingXibView.alpha = 0
                loadingXibView.transform = CGAffineTransformMakeScale(1.5, 1.5)
                }, { (completed) -> Void in
                    loadingXibView.removeFromSuperview()
            })
        }
    }
    
    
    
    
    // MARK: SYSTEM Extension
    var width:      CGFloat { return self.frame.size.width }
    var height:     CGFloat { return self.frame.size.height }
    var size:       CGSize  { return self.frame.size}
    
    var origin:     CGPoint { return self.frame.origin }
    var x:          CGFloat { return self.frame.origin.x }
    var y:          CGFloat { return self.frame.origin.y }
    var centerX:    CGFloat { return self.center.x }
    var centerY:    CGFloat { return self.center.y }
    
    var left:       CGFloat { return self.frame.origin.x }
    var right:      CGFloat { return self.frame.origin.x + self.frame.size.width }
    var top:        CGFloat { return self.frame.origin.y }
    var bottom:     CGFloat { return self.frame.origin.y + self.frame.size.height }
    
    func setWidth(width:CGFloat)
    {
        self.frame.size.width = width
    }
    
    func setHeight(height:CGFloat)
    {
        self.frame.size.height = height
    }
    
    func setSize(size:CGSize)
    {
        self.frame.size = size
    }
    
    func setOrigin(point:CGPoint)
    {
        self.frame.origin = point
    }
    
    func setX(x:CGFloat) //only change the origin x
    {
        self.frame.origin = CGPointMake(x, self.frame.origin.y)
    }
    
    func setY(y:CGFloat) //only change the origin x
    {
        self.frame.origin = CGPointMake(self.frame.origin.x, y)
    }
    
    func setCenterX(x:CGFloat) //only change the origin x
    {
        self.center = CGPointMake(x, self.center.y)
    }
    
    func setCenterY(y:CGFloat) //only change the origin x
    {
        self.center = CGPointMake(self.center.x, y)
    }
    
    func roundCorner(radius:CGFloat)
    {
        self.layer.cornerRadius = radius
    }
    
    func setTop(top:CGFloat)
    {
        self.frame.origin.y = top
    }
    
    func setLeft(left:CGFloat)
    {
        self.frame.origin.x = left
    }
    
    func setRight(right:CGFloat)
    {
        self.frame.origin.x = right - self.frame.size.width
    }
    
    func setBottom(bottom:CGFloat)
    {
        self.frame.origin.y = bottom - self.frame.size.height
    }
    
    
}