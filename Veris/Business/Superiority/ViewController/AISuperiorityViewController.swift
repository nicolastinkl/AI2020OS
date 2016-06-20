//
//  AIWishVowViewController.swift
//  AIVeris
//
// Copyright (c) 2016 ___ASIAINFO___
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import UIKit
import Spring
import Cartography
import AIAlertView
import SnapKit

/// 服务优势介绍视图
class AISuperiorityViewController: UIViewController {
    
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    private var preCacheView: UIView?
    
    var serviceModel: AISearchResultItemModel? {
        didSet{
            
        }
    }
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        // MARK: Init
        initLayoutViews()
        
        // MARK: Layout
        initDataWithModel()
        
        // MARK: Loading Data Views
        Async.main(after: 0.15) {
            self.initDatawithViews()
        }
        
    }
    
    func initDatawithViews(){
        
        // Top ImageView.
        let imageView = DesignableImageView()
        imageView.setHeight(100)
        imageView.setLeft(10)
        imageView.cornerRadius = 50
        imageView.borderWidth = 0.5
        imageView.clipsToBounds = true
        imageView.borderColor = UIColor(hex: AIApplication.AIColor.AIVIEWLINEColor)
        addNewSubView(imageView, preView: UIView(), color: UIColor.clearColor(), space: 30)
        imageView.setWidth(100)
        imageView.sd_setImageWithURL(NSURL(string: "http://img04.tooopen.com/images/20131025/sy_44028468847.jpg")!, placeholderImage: smallPlace())
        
        // Top Title.
        let titleLabel = DesignableLabel()
        titleLabel.font = UIFont.systemFontOfSize(30)
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .ByCharWrapping
        titleLabel.textColor = UIColor(hexString: "#FFFFFF", alpha: 0.7)
        titleLabel.setHeight(80)
        titleLabel.setLeft(10)
        titleLabel.setWidth(self.view.width)
        addNewSubView(titleLabel, preView: imageView)
        titleLabel.text = "听说你还为孕检超碎了心？"
        
        // List Superiority Desciption.
        var preCellView: UIView?
        for index in 0...3 {
            if let aisCell = AISuperiorityCellView.initFromNib() as? AISuperiorityCellView{
                aisCell.labelDesciption.text = "一键启动符合服务"
                if index > 0 {
                    addNewSubView(aisCell, preView: preCellView!)
                }else{
                    addNewSubView(aisCell, preView: titleLabel)
                }
                preCellView = aisCell
            }
        }
        
        // Price Label.
        let priceLabel = AILabel()
        priceLabel.text = "$ 184.0"
        priceLabel.setHeight(30)
        priceLabel.font = UIFont.systemFontOfSize(16)
        priceLabel.textColor = AITools.colorWithR(253, g: 225, b: 50)
        addNewSubView(priceLabel, preView: preCellView!)
        priceLabel.addBottomWholeSSBorderLine(AIApplication.AIColor.AIVIEWLINEColor)
        
        // Add Service List Icon , So at top and at down.
        
        
        let serverIcons = UIView()
        serverIcons.setHeight(300)
        var height: CGFloat = 0
        var preView:UIView?
        for i in 0...4 {
            if let iconText = AISuperiorityIconTextView.initFromNib() {
                let offSet: CGFloat = 50.0 + CGFloat(arc4random() % 20)
                iconText.setTop(height)
                serverIcons.addSubview(iconText)
                height = offSet + iconText.top
                if i % 2 != 0 {
                    iconText.setLeft(100 + CGFloat(arc4random() % 20))
                }
                
                if let pre = preView {
//                    let imageview = drawAtLineWithPoint(pre.frame.origin, endPoint: iconText.frame.origin)
//                    serverIcons.addSubview(imageview)
                    
                }
                
                preView = iconText
                
            }
        }
        
        
        addNewSubView(serverIcons, preView: priceLabel)
        
        
    }
    
    func initDataWithModel(){
        
    }
    
    func initLayoutViews(){
        
        /// Title.
        if let navi = AINavigationBar.initFromNib() as? AINavigationBar{
            view.addSubview(navi)
            navi.holderViewController = self
            constrain(navi, block: { (layout) in
                layout.left == layout.superview!.left
                layout.top == layout.superview!.top
                layout.right == layout.superview!.right
                layout.height == 44.0 + 10.0
            })
            
            navi.titleLabel.text = "孕检无忧"
            
            Async.main(after: 0.15, block: {
                navi.addBottomWholeSSBorderLine(AIApplication.AIColor.AIVIEWLINEColor)
            })
        }
        
    }
    
    func addNewSubView(cview: UIView,preView: UIView,color: UIColor = UIColor.clearColor(),space: CGFloat = 0){
        scrollview.addSubview(cview)
        cview.setWidth(self.view.width)
        cview.setTop(preView.top + preView.height+space)
        cview.backgroundColor = color
        scrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), cview.top + cview.height)
        preCacheView = cview
    }
    
    /**
     通过两点之间画线。
     
     - parameter startPoint: startPoint
     - parameter endPoint:   endPoint
     */
    func drawAtLineWithPoint(startPoint: CGPoint, endPoint: CGPoint) -> UIImageView {
        
        let imageView: UIImageView = UIImageView(frame: self.view.frame)
        
        UIGraphicsBeginImageContext(imageView.frame.size)
        imageView.image!.drawInRect(CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height))
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), CGLineCap.Round)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 15.0)
        //线宽
        CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), true)
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0)
        //颜色
        CGContextBeginPath(UIGraphicsGetCurrentContext())
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 100, 100)
        //起点坐标
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 200, 100)
        //终点坐标
        CGContextStrokePath(UIGraphicsGetCurrentContext())
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageView
        
    }
    
}
