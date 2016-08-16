//
//  AIWishPreviewController.swift
//  AIVeris
//
//  Created by tinkl on 8/9/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

import Spring
import Cartography

class AIWishPreviewController: UIViewController {
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    var model: AIBuyerBubbleModel?
    
    var preCacheView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if let navi = AINavigationBar.initFromNib() as? AINavigationBar {
            view.addSubview(navi)
            navi.holderViewController = self
            constrain(navi, block: { (layout) in
                layout.left == layout.superview!.left
                layout.top == layout.superview!.top
                layout.right == layout.superview!.right
                layout.height == 44.0 + 10.0
            })
            navi.titleLabel.font = AITools.myriadCondWithSize(24)
            navi.titleLabel.text = model?.proposal_name
            navi.backButton.setImage(UIImage(named: "scan_back"), forState: UIControlState.Normal)
        }
        
        Async.main(after: 0.3) {
            self.initSubViews()
        }
    }
    
    /// 初始化处理
    func initSubViews(){
        
        // Description
        
        let dbgView = UIView()
        dbgView.setHeight(100)
        addNewSubView(dbgView, preView: UIView())
        dbgView.backgroundColor = UIColor(hexString: "#000000", alpha: 0.15)
        
        let DescriptionLabel = UILabel()
        DescriptionLabel.font = AITools.myriadLightWithSize(20)
        DescriptionLabel.text = "Find anywhere good camera, a good photogra-pher. There are currently 12 people and you have the same desire, the there are 8 people dream come true!"
        DescriptionLabel.textAlignment = .Left
        DescriptionLabel.lineBreakMode = .ByCharWrapping
        DescriptionLabel.textColor = UIColor.whiteColor()
        DescriptionLabel.setHeight(100)
        DescriptionLabel.numberOfLines = 5
        dbgView.addSubview(DescriptionLabel)
        let dWidth = UIScreen.mainScreen().bounds.width - 50*2
        DescriptionLabel.setWidth(dWidth)
        DescriptionLabel.setLeft(50)
        
        // Question Title
        
        let QuestionTitle1 = AIWishTitleIconView.initFromNib() as! AIWishTitleIconView
        QuestionTitle1.icon.image = UIImage(named: "AI_Wish_Make_comment")
        QuestionTitle1.title.text = "See what they say about it"
        QuestionTitle1.title.font = AITools.myriadBoldWithSize(20)
        addNewSubView(QuestionTitle1, preView: DescriptionLabel)
        QuestionTitle1.setHeight(53)
        QuestionTitle1.addBottomWholeSSBorderLineLeftMapping(AIApplication.AIColor.AIVIEWLINEColor, leftMapping: 0)
        
        // Add Read All Button
        QuestionTitle1.button.hidden = false
        QuestionTitle1.button.addTarget(self, action: #selector(AIWishPreviewController.readAllAction), forControlEvents: UIControlEvents.TouchUpInside)
        
        // Top Scope
        let topScope = UIView()
        topScope.setHeight(10)
        addNewSubView(topScope)
        
        let imgTop = UIImageView(image: UIImage(named: "AI_Wish_Make_top"))
        imgTop.setWidth(13)
        imgTop.setHeight(11)
        topScope.addSubview(imgTop)
        imgTop.setTop(15)
        imgTop.setLeft(15)
        
        // Answer List
        let AnswerList = ["Best to provider some commeon not to buy expensvie qure Trial ",
                          "Often go to the field,more concerned about their own shipping equipment , the best you can always hire some professional equipment",
                          "Professional photographers can hope to teach experience, and can have specific guideance"]
        
        for string in AnswerList {
            let QuestionTitleX = AIWishTitleIconView.initFromNib() as! AIWishTitleIconView
            QuestionTitleX.greenPoint.hidden = false
            QuestionTitleX.icon.hidden = true
            QuestionTitleX.title.text = string
            QuestionTitleX.title.font = AITools.myriadLightWithSize(48/3)
            QuestionTitleX.title.textAlignment = .Left
            QuestionTitleX.title.lineBreakMode = .ByCharWrapping
            QuestionTitleX.title.numberOfLines = 100
            let sHeight = string.sizeWithFont(AITools.myriadLightWithSize(48/3), forWidth: QuestionTitleX.title.width).height
            addNewSubView(QuestionTitleX)
            QuestionTitleX.setHeight(10 + sHeight)
        }
        
        // Down Scope
        let downScope = UIView()
        downScope.setHeight(10)
        addNewSubView(downScope)
        
        let imgDown = UIImageView(image: UIImage(named: "AI_Wish_Make_down"))
        imgDown.setWidth(13)
        imgDown.setHeight(11)
        downScope.addSubview(imgDown)
        imgDown.setTop(-15)
        imgDown.setLeft(UIScreen.mainScreen().bounds.width - 55)
        
        // TextField
        let textField = AIWishTextWishsView.initFromNib()
        addNewSubView(textField!)
        textField?.addBottomWholeSSBorderLineLeftMapping(AIApplication.AIColor.AIVIEWLINEColor, leftMapping: 0)
        
        // will to Pay 
        
        let QuestionTitle2 = AIWishTitleIconView.initFromNib() as! AIWishTitleIconView
        QuestionTitle2.icon.image = UIImage(named: "AI_Wish_Make_insterest")
        QuestionTitle2.title.text = "The price you are willing to pay"
        QuestionTitle2.title.font = AITools.myriadBoldWithSize(20)
        addNewSubView(QuestionTitle2, preView: textField!)
        QuestionTitle2.setHeight(53)
//        QuestionTitle2.addBottomWholeSSBorderLineLeftMapping(AIApplication.AIColor.AIVIEWLINEColor, leftMapping: 0)
        
        // Average
        let wishAverage = AIWishAverageView.initFromNib()
        addNewSubView(wishAverage!)
        wishAverage?.backgroundColor = UIColor(hexString: "#ffffff", alpha: 0.1)        
    }
    
    func addNewSubView(cview: UIView){
        addNewSubView(cview, preView: preCacheView!)
    }
    
    func addNewSubView(cview: UIView, preView: UIView , color: UIColor = UIColor.clearColor(), space: CGFloat = 0) {
        scrollview.addSubview(cview)
        let width = UIScreen.mainScreen().bounds.size.width
        cview.setWidth(width)
        cview.setTop(preView.top + preView.height+space)
        cview.backgroundColor = color
        scrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), cview.top + cview.height)
        preCacheView = cview
        
    }
    
    // Action
    
    func readAllAction(){
    
    }
}
