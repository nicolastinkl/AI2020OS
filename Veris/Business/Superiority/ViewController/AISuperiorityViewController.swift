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

    @IBOutlet weak var roundView: UIView!
    private var preCacheView: UIView?

    var serviceModel: AISearchResultItemModel? {
        didSet {

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: Init
        self.initLayoutViews()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // MARK: Loading Data Views
        Async.main(after: 0.15) {
             
            // MARK: Layout
            self.initDataWithModel()

            
            self.initDatawithViews()
        }
    }
    
    
    @IBAction func targetServiceDetail(any: AnyObject) {
        showTransitionStyleCrossDissolveView(AIProductInfoViewController.initFromNib())
    }

    func initDatawithViews() {

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
        titleLabel.setWidth(UIScreen.mainScreen().bounds.width)
        addNewSubView(titleLabel, preView: imageView)
        titleLabel.text = "听说你还为孕检超碎了心？"

        // List Superiority Desciption.
        var preCellView: UIView?
        for index in 0...3 {
            if let aisCell = AISuperiorityCellView.initFromNib() as? AISuperiorityCellView {
                aisCell.labelDesciption.text = "一键启动符合服务"
                if index > 0 {
                    addNewSubView(aisCell, preView: preCellView!)
                } else {
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
        serverIcons.setHeight(350)
        var height: CGFloat = 0
        var preView: UIView?
        var leftOffset : CGFloat = 0
        for i in 0...4 {
            if let iconText = AISuperiorityIconTextView.initFromNib() {
                let offSet: CGFloat = 50.0 + CGFloat(arc4random() % 20)
                iconText.setTop(height)
                height = offSet + iconText.top
                if i % 2 != 0 {
                    
                    iconText.setLeft(self.view.width / 3 + CGFloat(arc4random() % 50) + leftOffset)
                }else{
                    iconText.setLeft(leftOffset)
                }
                serverIcons.addSubview(iconText)
                
                if let pre = preView {
                    let cureModel = CurveModel()
                    cureModel.startX = pre.frame.origin.x + 20
                    cureModel.startY = pre.frame.origin.y + 20
                    cureModel.endX = iconText.frame.origin.x + 20
                    cureModel.endY = iconText.frame.origin.y + 20
                    cureModel.strokeWidth = 1
                    cureModel.strokeColor = UIColor(hexString: "#FFFFFF", alpha: 0.3)
                    
                    addCurveLineWithModel(cureModel, sview: serverIcons)
                    
                    
                }

                preView = iconText
                leftOffset += 10
            }
        }


        addNewSubView(serverIcons, preView: priceLabel)

//        addCureLineView()

    }

    func initDataWithModel() {

    }

    func initLayoutViews() {

        /// Title.
        if let navi = AINavigationBar.initFromNib() as? AINavigationBar {
            view.addSubview(navi)
            navi.holderViewController = self
            constrain(navi, block: { (layout) in
                layout.left == layout.superview!.left
                layout.top == layout.superview!.top
                layout.right == layout.superview!.right
                layout.height == 44.0 + 10.0
            })
            
            navi.setRightIcon1Action(UIImage(named: "AINavigationBar_faviator")!)
            navi.setRightIcon2Action(UIImage(named: "AINavigationBar_send")!)
            navi.titleLabel.text = "孕检无忧"

        }
    }

    func addNewSubView(cview: UIView, preView: UIView, color: UIColor = UIColor.clearColor(), space: CGFloat = 0) {
        cview.alpha = 0
        scrollview.addSubview(cview)
        cview.setWidth(self.view.width)
        cview.setTop(preView.top + preView.height+space)
        cview.backgroundColor = color
        scrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), cview.top + cview.height)
        preCacheView = cview
        
        SpringAnimation.springEaseIn(0.2) { 
            cview.alpha = 1
        }
        
        
    }
    
    func addCureLineView(){
        let rightOffset = self.roundView.right
        let center: CGPoint = CGPointMake(self.roundView.width/2, self.roundView.height)
        let startPoint: CGPoint = CGPointMake(0,0)
        let endPoint: CGPoint = CGPointMake(rightOffset,0)
        let control1: CGPoint = center
        let path: UIBezierPath = UIBezierPath()
        path.moveToPoint(startPoint)
//        path.addLineToPoint(endPoint)
        path.addCurveToPoint(endPoint, controlPoint1: control1, controlPoint2: control1)
        let pathLayer: CAShapeLayer = CAShapeLayer()
        pathLayer.frame = self.roundView.bounds
        pathLayer.path = path.CGPath
        pathLayer.strokeColor = UIColor(hexString: "#FFFFFF", alpha: 0.3).CGColor
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 1
        pathLayer.lineJoin = kCALineJoinRound
        self.roundView.layer.addSublayer(pathLayer)
        
    }
    
    func addCurveLineWithModel(model: CurveModel,sview: UIView) -> CAShapeLayer {
        let startPoint: CGPoint = CGPointMake(model.startX, model.startY)
        let endPoint: CGPoint = CGPointMake(model.endX, model.endY)
        let path: UIBezierPath = UIBezierPath()
        path.moveToPoint(startPoint)
        path.addLineToPoint(endPoint)
        let pathLayer: CAShapeLayer = CAShapeLayer()
        pathLayer.frame = sview.bounds
        pathLayer.path = path.CGPath
        pathLayer.strokeColor = model.strokeColor.CGColor
        pathLayer.fillColor = nil
        pathLayer.lineWidth = model.strokeWidth
        pathLayer.lineJoin = kCALineJoinRound
        sview.layer.insertSublayer(pathLayer, atIndex: 0)
        return pathLayer
    }

}
