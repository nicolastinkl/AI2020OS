//
//  AIImageView.swift
//  AI2020OS
//
//  Created by tinkl on 7/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring
import AVOSCloud

/// 自定义Label 处理左右间距问题
public class AILabel: DesignableLabel {
    override public func drawTextInRect(rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
}

/*!
*  @author tinkl, 15-04-07 15:04:21
*
*  Loading image from url
*/
public class AIImageView: UIImageView {

    private struct AssociatedKeys {
        static var AIAssemblyIDKey = "AIAssemblyIDKey_UIImageView"
    }

    public var assemblyID: String? {
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.AIAssemblyIDKey, newValue  as NSString?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }

        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.AIAssemblyIDKey) as? String
        }
    }


    public var placeholderImage: UIImage?
    
    public var cacheImage: UIImage?
    
    private var cacheURL: NSURL?
    
    public var url: NSURL? {
        didSet {
            self.image = placeholderImage

            self.sd_setImageWithURL(url) { [weak self]  (imgContent, ErrorType, CacheType, CacheURL) -> Void in
                if let strongSelf = self {
                    if strongSelf.url == CacheURL {
                        strongSelf.alpha=0.2
                        strongSelf.image = imgContent
                        UIView.beginAnimations(nil, context: nil)
                        UIView.setAnimationDuration(0.5)
                        strongSelf.setNeedsDisplay()
                        strongSelf.alpha = 1
                        UIView.commitAnimations()

                    }
                }
            }
        }
    }

    public func setURL(url: NSURL?, placeholderImage: UIImage?) {
        self.placeholderImage = placeholderImage
        if url?.URLString.length > 10 {
            self.url = url
        } else {
            self.alpha=0.2
            self.image = placeholderImage
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.5)
            self.setNeedsDisplay()
            self.alpha = 1
            UIView.commitAnimations()
        }

    }
    
    
    func imageDownloadRetry(button: UIButton){
        button.removeFromSuperview()
        setURL(self.cacheURL, placeholderImage: self.cacheImage, showProgress: true)
    }
    
    public func setURL(url: NSURL?, placeholderImage: UIImage?, showProgress: Bool?) {
        self.contentMode = UIViewContentMode.ScaleAspectFill
        self.clipsToBounds = true
        cacheImage = placeholderImage
        if let showProgress = showProgress {
            if showProgress {
                
                let newFrame = CGRectMake(0, 0, self.width, self.height)                
                let progress = AIProgressWebHoldView(frame: newFrame)
                self.addSubview(progress)
                
                if url?.URLString.length > 10 {
                    self.cacheURL = url
                    self.sd_setImageWithURL(url!, placeholderImage: placeholderImage, options: SDWebImageOptions.CacheMemoryOnly, progress: { (start, end) in
                        progress.progress = CGFloat(start) / CGFloat(end)
                    }) { (image, error, cacheType, url) in
                        AILog(image)
                        AILog(error)
                        if image != nil {
                            UIView.animateWithDuration(0.2, animations: { 
                                progress.alpha = 1
                                }, completion: { (complate) in
                                progress.removeFromSuperview()
                            })
                            
                            
                        } else {
                            self.userInteractionEnabled = true
                            // add try button
                            let button = UIButton(frame: CGRectZero )
                            button.setImage(UIImage(named: "AI_ProductInfo_Home_like"), forState: UIControlState.Normal)
                            self.addSubview(button)
                            button.setWidth(self.width)
                            button.setHeight(self.height)
                            button.backgroundColor = UIColor(hexString: "#000000", alpha: 0.3)
                            button.addTarget(self, action: #selector(AIImageView.imageDownloadRetry(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                        }
                    }
                    
                } else {
                    
                }
            
            
            
            
            }
            
        }
    }
    
    
    public func uploadImage(complate: (NSURL?, NSError!) -> Void) {
        if let image = self.image {
            
            let newFrame = CGRectMake(0, 0, self.width, self.height)
            let progressView = AIProgressWebHoldView(frame: newFrame)
            self.addSubview(progressView)
            
            // upload to LeanCloud
            let data = UIImagePNGRepresentation(image)
            let file = AVFile(data: data)
            file.saveInBackgroundWithBlock({ (finish, error) in
                
                if finish {
                    
                    UIView.animateWithDuration(0.2, animations: {
                        progressView.alpha = 1
                        }, completion: { (complate) in
                            progressView.removeFromSuperview()
                    })
                    
                    if error != nil {
                        self.userInteractionEnabled = true
                        // add try button
                        let button = UIButton(frame: CGRectZero )
                        button.setImage(UIImage(named: "AI_ProductInfo_Home_like"), forState: UIControlState.Normal)
                        self.addSubview(button)
                        button.setWidth(self.width)
                        button.setHeight(self.height)
                        button.backgroundColor = UIColor(hexString: "#000000", alpha: 0.3)
                        button.addTarget(self, action: #selector(AIImageView.imageUploadRetry(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                        
                    }
                    complate(NSURL(string: file.url), error)
                }
                
                }, progressBlock: { (progress) in
                    
                progressView.progress = CGFloat(progress) / 100
            })
            
            
        }
    }
    
    
    // Retry Upload Image to LeanCloud.
    func imageUploadRetry(button: UIButton){
        button.removeFromSuperview()
        uploadImage { (url, error) in
            
        }
    }
    
}


/// Progress View

class AIProgressWebHoldView: UIView {
    
    var progress: CGFloat {
        didSet {
            self.setNeedsDisplay()
        }
        
    }
    var schemeColor: UIColor
    var progressTintColor: UIColor
    var backgroundTintColor: UIColor
    
    override init(frame: CGRect) {
        schemeColor = UIColor.whiteColor()
        progressTintColor = UIColor.whiteColor()
        backgroundTintColor = UIColor.whiteColor()
        self.progress = 0.0
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()//UIColor(hexString: "#000000", alpha: 0.3)
        self.opaque = false
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //pragma mark - Drawing
    
    override func drawRect(rect: CGRect) {
        let allRect = self.bounds
        let context = UIGraphicsGetCurrentContext()
        let circleRect: CGRect = CGRectInset(allRect, 2.0, 2.0)
        let colorBackAlpha: CGColorRef = CGColorCreateCopyWithAlpha(backgroundTintColor.CGColor, 0.1)!
        progressTintColor.setStroke()
        CGContextSetFillColorWithColor(context, colorBackAlpha)
        CGContextSetLineWidth(context, 2.0)
        CGContextFillEllipseInRect(context, circleRect)
        CGContextStrokeEllipseInRect(context, circleRect)
        
        let center: CGPoint = CGPointMake(allRect.size.width / 2, allRect.size.height / 2)
        let radius: CGFloat = (allRect.size.width - 4) / 2 - 3
        let startAngle: CGFloat = -(CGFloat(M_PI) / 2)
        let endAngle: CGFloat = (self.progress * 2 * CGFloat(M_PI)) + startAngle
        progressTintColor.setFill()
        CGContextMoveToPoint(context, center.x, center.y)
        CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, 0)
        CGContextClosePath(context)
        CGContextFillPath(context)
        
    }
}
