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

    /// 服务是否浏览过
    var viewed = false

    @IBOutlet weak var scrollview: UIScrollView!

    @IBOutlet weak var roundView: UIView!
    
    @IBOutlet weak var superView: UIView!
    
    private var preCacheView: UIView?
    
    private var naviBar: AINavigationBar?
    
    private var leftOffSet: CGFloat = 13

    var serviceModel: AISearchServiceModel?
    
    private var selfImage: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: Init
        initLayoutViews()
        fetchData()
        createBrowserHistory()
    }
    
    @IBAction func targetServiceDetail(any: AnyObject) {
        let pvc  = AIProductInfoViewController.initFromNib()
        pvc.sid = serviceModel?.sid ?? 0
        showTransitionStyleCrossDissolveView(pvc)
    }

    func initDatawithViewsImaeg() {
        
        let shapLayer = CAShapeLayer()
        shapLayer.contents = UIImage(named: "AI_Superiority_bg_mask")?.CGImage
        var newFrame = superView.frame
        newFrame.origin = CGPointMake(0, -13)
        shapLayer.frame = newFrame
        superView.layer.mask = shapLayer
        
        // Top ImageView.
        let imageView = DesignableImageView()
        imageView.setHeight(UIScreen.mainScreen().bounds.height)
        imageView.setLeft(0)
        addNewSubView(imageView, preView: UIView(), color: UIColor.clearColor(), space: 0)
        imageView.sd_setImageWithURL(NSURL(string: self.selfImage)!, placeholderImage: smallPlace())        
    }
    
    func initDatawithViews() {
        
        // Make Mask with ScrollView.
        
        let shapLayer = CAShapeLayer()
        shapLayer.contents = UIImage(named: "AI_Superiority_bg_mask")?.CGImage
        var newFrame = superView.frame
        newFrame.origin = CGPointMake(0, -13)
        shapLayer.frame = newFrame
        superView.layer.mask = shapLayer
        
        // Top ImageView.
        let imageView = DesignableImageView()
        imageView.setHeight(136)
        imageView.setLeft(leftOffSet)
        imageView.cornerRadius = 68
        imageView.borderWidth = 0.5
        imageView.clipsToBounds = true
        imageView.borderColor = UIColor(hex: AIApplication.AIColor.AIVIEWLINEColor)
        addNewSubView(imageView, preView: UIView(), color: UIColor.clearColor(), space: 42)
        imageView.setWidth(136)
        imageView.sd_setImageWithURL(NSURL(string: "http://img04.tooopen.com/images/20131025/sy_44028468847.jpg")!, placeholderImage: smallPlace())

        // Top Title.
        let titleLabel = DesignableLabel()
        titleLabel.textAlignment = .Left
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .ByCharWrapping
        titleLabel.textColor = UIColor(hexString: "#FFFFFF", alpha: 0.8)
        titleLabel.font = UIFont.boldSystemFontOfSize(105/3)
        titleLabel.setHeight(284/3)
        titleLabel.setLeft(leftOffSet)
        addNewSubView(titleLabel, preView: imageView, color: UIColor.clearColor(), space: 53/3)
        titleLabel.setWidth(UIScreen.mainScreen().bounds.width - 50)
        titleLabel.text = "听说你还为孕检\n操碎了心？"

        // List Superiority Desciption.
//        var preCellView: UIView?
//        for index in 0...3 {
//            if let aisCell = AISuperiorityCellView.initFromNib() as? AISuperiorityCellView {
//                aisCell.labelDesciption.text = "一键启动符合服务"
//                if index > 0 {
//                    addNewSubView(aisCell, preView: preCellView!, color: UIColor.clearColor(), space: 48/3)
//                } else {
//                    addNewSubView(aisCell, preView: titleLabel)
//                }
//                preCellView = aisCell
//            }
//        }
//        
//        
        
        if let aisCell = AISuperiorityCellView.initFromNib() as? AISuperiorityCellView {
            aisCell.labelDesciption.text = "一键启动符合服务"
            addNewSubView(aisCell)
            aisCell.setHeight(32)
        }
        
        if let aisCell = AISuperiorityCellView.initFromNib() as? AISuperiorityCellView {
            aisCell.labelDesciption.text = "7*24小时随时待命"
            addNewSubView(aisCell)
            aisCell.setHeight(32)
        }
        
        if let aisCell = AISuperiorityCellView.initFromNib() as? AISuperiorityCellView {
            aisCell.labelDesciption.text = "孕期检查的一站式服务"
            addNewSubView(aisCell)
            aisCell.setHeight(32)
        }
        

        // Price Label.
        let priceLabel = AILabel()
        priceLabel.text = "€ 184.0 +"
        priceLabel.setHeight(44/3)
        addNewSubView(priceLabel, preView: preCacheView!, color: UIColor.clearColor(), space: 69/3)
        priceLabel.font = UIFont.boldSystemFontOfSize(60/3)
        priceLabel.textColor = UIColor(hexString: "e7c400")

        let canvas = canvasLineView(frame: priceLabel.frame)
        addNewSubView(canvas, preView: priceLabel, color: UIColor.clearColor(), space: 55/3)
        
 
        // Add Service List Icon , So at top and at down.
 
        let serverIcons = UIView()
        serverIcons.setHeight(350)
        //  从JSON数据生成的界面
        var height: CGFloat = 10
        var preView: UIView?
        var leftOffset: CGFloat = 0
        let textArray = ["专车接送（去程）", "挂号", "专业陪护", "专车接送（返程）"]
        for i in 0...3 {
            if let iconText = AISuperiorityIconTextView.initFromNib() as? AISuperiorityIconTextView {
                let offSet: CGFloat = 50.0 + CGFloat(arc4random() % 20)
                iconText.setTop(height)
                height = offSet + iconText.top
                if i % 2 != 0 {
                    iconText.setLeft(self.view.width / 3 + CGFloat(arc4random() % 50) + leftOffset)
                } else {
                    iconText.setLeft(leftOffset)
                }
                serverIcons.addSubview(iconText)
                iconText.content.text = textArray[i]
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
        
//        let imageV = UIImageView(image: UIImage(named: "pathService"))
//        imageV.setHeight(180)
//        imageV.setTop(10)
//        serverIcons.addSubview(imageV)
//        imageV.setLeft(10)
        addNewSubView(serverIcons, preView: priceLabel, color: UIColor.clearColor(), space: 19)
        
//        addCureLineView()

    }

    func createBrowserHistory() {
        if let sid = serviceModel?.sid {
            AISearchHomeService().createBrowserHistory(sid)
        }
    }
    
    func fetchData() {
        view.showLoading()
        if let serviceModel = serviceModel {
            AISuperiorityService.requestSuperiority(String(serviceModel.sid)) { (response, error) in
                self.view.hideLoading()
                if let res = response {
                    let model = res as! AISuperiorityModel
                    self.selfImage = model.icon ?? ""
                    // MARK: Loading Data Views
                    //self.initDatawithViews()
                    Async.main({ 
                        self.initDatawithViewsImaeg()
                    })
                    if model.collected == 0 {
                        //未收藏
                        self.naviBar?.setRightIcon1Action(UIImage(named: "AINavigationBar_faviator")!)
                    } else {
                        self.naviBar?.setRightIcon1Action(UIImage(named: "AINavigationBar_faviator_ok")!)
                    }
                }
            }
        }
    }
    
    func favoriteAction() {
        
        view.showLoading()
        //AIProdcutinfoService.addFavoriteServiceInfo(String(serviceModel.sid))
        if let serviceModel = serviceModel {
             AIProdcutinfoService.addFavoriteServiceInfo(String(serviceModel.sid), proposal_spec_id: "") { (obj, error) in
                self.view.hideLoading()
                if let res = obj as? String {
                    // MARK: Loading Data Views
                    if res == "1"{
                        self.naviBar?.setRightIcon1Action(UIImage(named: "AINavigationBar_faviator_ok")!)
                        if let naviBar = self.naviBar {
                            naviBar.commentButton.animation = "pop"
                            naviBar.commentButton.animate()
                        }
                    } else {
                        AIAlertView().showError("收藏失败", subTitle: "")
                    }
                } else {
                    AIAlertView().showError("收藏失败", subTitle: "")
                }
            }
        }
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
            navi.titleLabel.text = serviceModel?.name
            navi.videoButton.addTarget(self, action: #selector(shareAction), forControlEvents: UIControlEvents.TouchUpInside)
            navi.commentButton.addTarget(self, action: #selector(favoriteAction), forControlEvents: UIControlEvents.TouchUpInside)
            naviBar = navi
            
        }
    }


    //MARK: Share Action

    func shareAction() {
        //如果需要分享回调，请将delegate对象设置self，并实现下面的回调方法
        UMSocialData.defaultData().extConfig.title = "分享的title"
        UMSocialSnsService.presentSnsIconSheetView(self, appKey: AIApplication.UMengAppID, shareText: "ZhuangBi With Me & Fly With Me", shareImage: nil, shareToSnsNames: [UMShareToWechatSession, UMShareToWechatTimeline, UMShareToSina, UMShareToQQ, UMShareToQzone], delegate: self)
    }

    func addNewSubView(cview: UIView) {
        addNewSubView(cview, preView: preCacheView!)
    }
    
    func addNewSubView(cview: UIView, preView: UIView, color: UIColor = UIColor.clearColor(), space: CGFloat = 0) {
        cview.alpha = 0
        scrollview.addSubview(cview)
        let width = UIScreen.mainScreen().bounds.size.width
        cview.setWidth(width)
        cview.setTop(preView.top + preView.height+space)
        cview.backgroundColor = color
        scrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), cview.top + cview.height)
        preCacheView = cview
        
        SpringAnimation.springEaseIn(0.2) { 
            cview.alpha = 1
        }
    }
    
    func addCureLineView() {
        let rightOffset = self.roundView.right
        let center: CGPoint = CGPointMake(self.roundView.width/2, self.roundView.height)
        let startPoint: CGPoint = CGPointMake(0, 0)
        let endPoint: CGPoint = CGPointMake(rightOffset, 0)
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
    
    func addCurveLineWithModel(model: CurveModel, sview: UIView) -> CAShapeLayer {
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

class canvasLineView: UIView {
    override func drawRect(rect: CGRect) {
        
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPoint(x: 0, y: 0))
        bezierPath.addLineToPoint(CGPoint(x: rect.width, y: 0))
        UIColor(hexString: "#FFFFFF", alpha: 0.65) .setStroke()
        bezierPath.lineWidth = 0.5
        CGContextSaveGState(context)
        CGContextSetLineDash(context, 0, [4, 4], 2)
        bezierPath.stroke()
        CGContextRestoreGState(context)
        backgroundColor = UIColor.clearColor()        
    }
}



//MARK: ShareDelegate
extension AISuperiorityViewController: UMSocialUIDelegate {

    func didFinishGetUMSocialDataInViewController(response: UMSocialResponseEntity!) {
        if response.responseCode == UMSResponseCodeSuccess {
            AILog("share to sns name is" + "\(response.data.keys.first)")
        }
    }
    
}
