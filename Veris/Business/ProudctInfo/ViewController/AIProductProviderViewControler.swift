//
//  AIProductProviderViewControler.swift
//  AIVeris
//
//  Created by asiainfo on 7/21/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit
import Cartography

class AIProductProviderViewControler: UIViewController {
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var topView: UIView!
    
    private var preCacheView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navi = AINavigationBar.initFromNib() as? AINavigationBar {
            topView.addSubview(navi)
            navi.holderViewController = self
            constrain(navi, block: { (layout) in
                layout.left == layout.superview!.left
                layout.top == layout.superview!.top
                layout.right == layout.superview!.right
                layout.height == 44.0 + 10.0
            })
            navi.titleLabel.text = ""
            navi.videoButton.setTitle("关注", forState: UIControlState.Normal)
            
        }
     
        Async.main(after: 0.1) { 
            self.loadViews()
        }
        
        
    }
    
    
    func loadViews() {
        
        /**
         定制的TitleView
         */
        func getTitleLabelView(title: String, desctiption: String = "", showRight: Bool = true) -> UIView {
            let heightLabel: CGFloat = 108 / 3
            let tView = UIView()
            tView.frame = CGRectMake(0, 0, self.view.width, heightLabel)
            
            let titleLabel = AILabel()
            titleLabel.text = title
            titleLabel.setHeight(heightLabel)
            titleLabel.font = UIFont.systemFontOfSize(42 / 3)
            titleLabel.textColor = UIColor(hexString: "#FFFFFF")
            
            let desLabel = AILabel()
            desLabel.text = desctiption
            desLabel.setHeight(heightLabel)
            desLabel.font = UIFont.systemFontOfSize(36 / 3)
            desLabel.textColor = UIColor(hexString: "#FFFFFF", alpha: 0.5)
            
            tView.addSubview(titleLabel)
            tView.addSubview(desLabel)
            titleLabel.frame = CGRectMake(0, 0, 100, heightLabel)
            desLabel.frame = CGRectMake(80, 0, 180, heightLabel)
            
            let imageview = UIImageView()
            imageview.image = UIImage(named: "right_triangle")
            tView.addSubview(imageview)
            imageview.contentMode = UIViewContentMode.ScaleToFill
            imageview.frame = CGRectMake(view.width - 15, 10, 8, 12)
            imageview.hidden = !showRight
            return tView
        }
        
        if let p = AIProvideIView.initFromNib() {
            addNewSubView(p, preView: UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0)))
            addNewSubView(AIAptitudeView.initFromNib()!, preView: p)
        }
        
        let s1 = addSplitView()
        
        
        // Setup 2:
        let pLabel = getTitleLabelView("服务者介绍")
        
        addNewSubView(pLabel, preView: s1)
        pLabel.backgroundColor = UIColor(hexString: "#000000", alpha: 0.3)
        let hView4 = AIServerProviderView.initFromNib() as? AIServerProviderView
        addNewSubView(hView4!, preView: pLabel)
        hView4?.fillDataWithModel()
        let lineView3 = addSplitView()
        
        // Setup 4:
        let pLabel44 = getTitleLabelView("为您推荐")
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(AIProductInfoViewController.recommondForYouPressed))
        pLabel44.addGestureRecognizer(tap4)
        addNewSubView(pLabel44, preView: lineView3)
        pLabel44.backgroundColor = UIColor(hexString: "#000000", alpha: 0.3)
        
        let bubbleViewContain = UIView()
        bubbleViewContain.setHeight(0)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let bubbleModels = appDelegate.dataSourcePop
        if bubbleModels.count > 0 {
            for i in 0..<min(4, bubbleModels.count) {
                let model: AIBuyerBubbleModel! = bubbleModels[i]
                let marginLeft = AITools.displaySizeFrom1242DesignSize(34)
                let space = AITools.displaySizeFrom1242DesignSize(15)
                let bubbleWidth = (screenWidth - marginLeft * 2 - space * 3) / 4
                model.bubbleSize = Int(bubbleWidth)/2
                let bubbleView = AIBubble(center: .zero, model: model, type: model.bubbleType, index: 0)
                bubbleViewContain.addSubview(bubbleView)
                bubbleView.tag = i
                let bubbleY = AITools.displaySizeFrom1242DesignSize(87)
                bubbleView.frame = CGRect(x: marginLeft + CGFloat(i) * (bubbleWidth + space), y: bubbleY, width: bubbleWidth, height: bubbleWidth)
                
            }
            
            bubbleViewContain.setHeight(125)
        }
        addNewSubView(bubbleViewContain, preView: pLabel44)
        
        
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
        splitView.setHeight(0)
        if let preCacheView = preCacheView {
            addNewSubView(splitView, preView: preCacheView)
            splitView.backgroundColor = UIColor(hexString: "#372D49", alpha: 0.8)
        }
        return splitView
    }
    
    
    
}