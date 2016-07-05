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

/// 商品详情视图
class AIProductInfoViewController: UIViewController {


    private let defaultTableViewHeaderMargin: CGFloat = 300.0
    private let imageScalingFactor: CGFloat = 350.0

    @IBOutlet weak var scrollview: UIScrollView!

    private var preCacheView: UIView?

    private var navi = AINavigationBar.initFromNib()

    private let topImage = AIImageView()
    
    /**
     Init
     */

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add ContentOffSet Listen.
        configureObserver()

        // Make AINavigationBar 'View.
        initLayoutViews()

        // Make UIScrollView.
        Async.main(after: 0.1) {
            self.initScrollViewData()
        }

    }
    /**
     observerValueForKeyPath.
     */
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "contentOffset" {
            scrollViewDidScrollWithOffset(scrollview.contentOffset.y)
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }

    private func configureObserver() {
        scrollview.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
    }

    /**
     处理大图放大缩小效果
     */
    func  scrollViewDidScrollWithOffset(scrollOffset: CGFloat) {
        let scrollViewDragPoint: CGPoint = CGPoint(x: 0, y: 0)
        if scrollOffset < 0 {
            //topImage.transform = CGAffineTransformMakeScale(1 - (scrollOffset / self.imageScalingFactor), 1 - (scrollOffset / self.imageScalingFactor))
        } else {
            //topImage.transform = CGAffineTransformMakeScale(1.0, 1.0)
        }

        animateImageView(scrollOffset, draggingPoint: scrollViewDragPoint, alpha: 1.0)

    }

    // MAKE 处理Navigationbar 背景模糊虚化效果.
    func animateImageView(scrollOffset: CGFloat, draggingPoint: CGPoint, alpha: CGFloat) {

        animateNavigationBar(scrollOffset, draggingPoint: draggingPoint)
        if scrollOffset > draggingPoint.y && scrollOffset > defaultTableViewHeaderMargin {
            UIView.animateWithDuration(0.3, animations: {
                if let navi = self.navi as? AINavigationBar {
                    navi.bgView.subviews.first?.alpha = 1.0
                }
            })
        } else if scrollOffset <= defaultTableViewHeaderMargin {
            UIView.animateWithDuration(0.3, animations: {
                if let navi = self.navi as? AINavigationBar {
                    navi.bgView.subviews.first?.alpha = 0
                }
            })
        }
    }

    func animateNavigationBar(scrollOffset: CGFloat, draggingPoint: CGPoint) {

    }


    /**
     Init with TOP VIEW.
     */
    func initLayoutViews() {

        /// Title.
        if let navi = navi as? AINavigationBar {
            view.addSubview(navi)
            navi.holderViewController = self
            constrain(navi, block: { (layout) in
                layout.left == layout.superview!.left
                layout.top == layout.superview!.top
                layout.right == layout.superview!.right
                layout.height == 44.0 + 10.0
            })

            navi.titleLabel.text = ""

        }
    }

    func initScrollViewData() {

        /**
         定制的TitleView
         */
        func getTitleLabelView(title: String, desctiption: String = "", showRight: Bool = true) -> UIView {
            let heightLabel: CGFloat = 30
            let tView = UIView()
            tView.frame = CGRectMake(0, 0, self.view.width, heightLabel)

            let titleLabel = AILabel()
            titleLabel.text = title
            titleLabel.setHeight(heightLabel)
            titleLabel.font = UIFont.systemFontOfSize(15)
            titleLabel.textColor = UIColor(hexString: "#FFFFFF")

            let desLabel = AILabel()
            desLabel.text = desctiption
            desLabel.setHeight(heightLabel)
            desLabel.font = UIFont.systemFontOfSize(12)
            desLabel.textColor = UIColor(hexString: "#FFFFFF", alpha: 0.4)

            tView.addSubview(titleLabel)
            tView.addSubview(desLabel)
            titleLabel.frame = CGRectMake(0, 0, 80, heightLabel)
            desLabel.frame = CGRectMake(80, 0, 180, heightLabel)

            let imageview = UIImageView()
            imageview.image = UIImage(named: "right_triangle")
            tView.addSubview(imageview)
            imageview.contentMode = UIViewContentMode.ScaleToFill
            imageview.frame = CGRectMake(view.width - 15, 10, 8, 12)
            imageview.hidden = !showRight
            return tView
        }

        // Setup 1 : Top UIImageView.
        topImage.setURL(NSURL(string: "https://www.cdc.gov/pregnancy/meds/images/woman-talking-to-dr-400px.jpg"), placeholderImage: smallPlace())
        topImage.setHeight(imageScalingFactor)
        topImage.contentMode = UIViewContentMode.ScaleAspectFill
        addNewSubView(topImage, preView: UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)))

        // Setup 2: title Info View.
        let titleLabel = getTitleLabelView("孕检无忧", desctiption: "", showRight: false)
        addNewSubView(titleLabel, preView: topImage)
        titleLabel.backgroundColor = UIColor(hexString: "#000000", alpha: 0.3)
        
        let desLabel = AILabel()
        desLabel.text = "最后还是要提一下，“过早的优化是万恶之源”，在需求未定，性能问题不明显时，没必要尝试做优化，而要尽量正确的实现功能。做性能优化时，也最好是走修改代码 -> Profile -> 修改代码这样一个流程，优先解决最值得优化的地方。"
        desLabel.setHeight(60)
        desLabel.numberOfLines = 0
        desLabel.lineBreakMode = .ByCharWrapping
        desLabel.font = UIFont.systemFontOfSize(13)
        desLabel.textColor = UIColor(hexString: "#FFFFFF", alpha: 0.7)
        addNewSubView(desLabel, preView: titleLabel)

        let priceLabel = AILabel()
        priceLabel.text = "$ 184.0"
        priceLabel.setHeight(30)
        priceLabel.font = UIFont.systemFontOfSize(16)
        priceLabel.textColor = AITools.colorWithR(253, g: 225, b: 50)
        addNewSubView(priceLabel, preView: desLabel)
        priceLabel.addBottomWholeSSBorderLine(AIApplication.AIColor.AIVIEWLINEColor)

        let tagsView = UIView()
        tagsView.setHeight(40)

        for index in 0...2 {
            // add tag view.
            let tag = DesignableButton()
            tag.borderColor = UIColor.whiteColor()
            tag.borderWidth = 0.5
            tag.cornerRadius = 10
            tagsView.addSubview(tag)
            tag.titleLabel?.textColor = UIColor.whiteColor()
            tag.titleLabel?.font = UIFont.systemFontOfSize(13)
            tag.frame = CGRectMake(CGFloat(index) * (55 + 10), 10, 55, 20)

            tag.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            tag.setTitleColor(AITools.colorWithR(253, g: 225, b: 50), forState: UIControlState.Highlighted)
            
            
            if index == 0 {
                tag.setTitle("方案A", forState: UIControlState.Normal)
            } else if index == 1 {
                tag.setTitle("方案B", forState: UIControlState.Normal)
            } else {
                tag.setTitle("自由定制", forState: UIControlState.Normal)
                tag.addTarget(self, action: #selector(AIProductInfoViewController.showDetailView), forControlEvents: UIControlEvents.TouchUpInside)
            }

        }
        tagsView.setLeft(10)
        addNewSubView(tagsView, preView: priceLabel)

        let lineView1 = addSplitView()

        // Setup 3:
        let commond = getTitleLabelView("商品评价", desctiption: "好评率50%")
        addNewSubView(commond, preView: lineView1)
        commond.addBottomWholeSSBorderLine(AIApplication.AIColor.AIVIEWLINEColor)

        let commentView = AICommentInfoView.initFromNib() as? AICommentInfoView
        addNewSubView(commentView!, preView: commond)
        commentView?.fillDataWithModel()
        let lineView2 = addSplitView()

        // Setup 4:
        let pLabel = getTitleLabelView("为您推荐")
        addNewSubView(pLabel, preView: lineView2)
        pLabel.addBottomWholeSSBorderLine(AIApplication.AIColor.AIVIEWLINEColor)
        let hView4 = UIView()
        addNewSubView(hView4, preView: pLabel)
        hView4.setHeight(100)

        let lineView3 = addSplitView()

        // Setup 5:
        let pcLabel = getTitleLabelView("商品介绍")
        addNewSubView(pcLabel, preView: lineView3)

        let bottomImage = AIImageView()
        bottomImage.setURL(NSURL(string:"http://ww1.sinaimg.cn/bmiddle/661433edjw1f44f65foq7j20ku4cge81.jpg"), placeholderImage: smallPlace())
        bottomImage.setHeight(1335.0)
        bottomImage.backgroundColor = UIColor(hexString: "#6AB92E", alpha: 0.7)
        bottomImage.contentMode = UIViewContentMode.ScaleAspectFill
        bottomImage.clipsToBounds = true
        addNewSubView(bottomImage, preView: pcLabel)


    }

    /**
     copy from old View Controller.
     */
    func addNewSubView(cview: UIView, preView: UIView, color: UIColor = UIColor.clearColor(), space: CGFloat = 0) {
        scrollview.addSubview(cview)
        cview.setWidth(self.view.width)
        cview.setTop(preView.top + preView.height+space)
        cview.backgroundColor = color
        scrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), cview.top + cview.height)
        preCacheView = cview
    }

    // Make Add Split View.
    func addSplitView() -> UIView {
        let splitView = UIView()
        splitView.setHeight(7)
        if let preCacheView = preCacheView {
            addNewSubView(splitView, preView: preCacheView)
            splitView.backgroundColor = UIColor(hexString: "#372D49", alpha: 0.8)
        }
        return splitView
    }
    
    
    // MARK: - DIY ACTION
    
    func showDetailView() {
        let model = AIBuyerBubbleModel()
        model.proposal_id = 3525
        model.proposal_name = "Pregnancy Care"
        let viewsss = createBuyerDetailViewController(model)
        self.showViewController(viewsss, sender: self)
    }
    
    func  createBuyerDetailViewController(model: AIBuyerBubbleModel) -> UIViewController {
        
        let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIBuyerStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIBuyerDetailViewController) as! AIBuyerDetailViewController
        viewController.bubbleModel = model
        viewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        viewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        
        return viewController
    }
    
    func configOrderAction() {
        let model = AIProposalInstModel()
        model.proposal_id = 3525
        model.proposal_name = "Pregnancy Care"
        
        if let vc = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIBuyerStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIConfirmOrderViewController) as? AIConfirmOrderViewController {
            vc.dataSource  = model
            self.showViewController(vc, sender: self)
        }
        
    }
   
    @IBAction func showOrderAction(sender: AnyObject) {
        configOrderAction()
    }
    
}


extension AIProductInfoViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(scrollView: UIScrollView) {

    }


}
