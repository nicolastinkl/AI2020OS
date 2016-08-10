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
            navi.titleLabel.font = AITools.myriadLightWithSize(24)
            navi.titleLabel.text = model?.proposal_name
            
        }
        
        Async.main(after: 0.3) {
            self.initSubViews()
        }
    }
    
    /// 初始化处理
    func initSubViews(){
        
        // Description
        
        let DescriptionLabel = UILabel()
        DescriptionLabel.font = AITools.myriadLightWithSize(20)
        DescriptionLabel.text = "Find anywhere good camera, a good photogra-pher. There are currently 12 people and you have the same desire, the there are 8 people dream come true!"
        DescriptionLabel.textAlignment = .Left
        DescriptionLabel.lineBreakMode = .ByWordWrapping
        DescriptionLabel.textColor = UIColor.whiteColor()
        DescriptionLabel.setHeight(100)
        DescriptionLabel.numberOfLines = 100
        addNewSubView(DescriptionLabel, preView: UIView())
        DescriptionLabel.backgroundColor = UIColor(hexString: "#000000", alpha: 0.15)
        
        // Question Title
        
        let QuestionTitle1 = AIWishTitleIconView.initFromNib() as! AIWishTitleIconView
        QuestionTitle1.icon.image = UIImage(named: "AI_Wish_Make_comment")
        QuestionTitle1.title.text = "See what they say about the wish"
        QuestionTitle1.title.font = AITools.myriadBoldWithSize(20)
        addNewSubView(QuestionTitle1, preView: DescriptionLabel)
        QuestionTitle1.setHeight(53)
        QuestionTitle1.addBottomWholeSSBorderLineLeftMapping(AIApplication.AIColor.AIVIEWLINEColor, leftMapping: 0)
        // Answer List
        
        for _ in 0...4 {
            let QuestionTitleX = AIWishTitleIconView.initFromNib() as! AIWishTitleIconView
            QuestionTitleX.icon.image = UIImage(named: "")
            QuestionTitleX.title.text = "Best to provider some commeon not to buy expensvie qure Trial"
            QuestionTitleX.title.font = AITools.myriadLightWithSize(48/3)
            addNewSubView(QuestionTitleX)
            QuestionTitleX.setHeight(35)
        }
        
        // TextField
        let textField = AIWishTextWishsView.initFromNib()
        addNewSubView(textField!)
        textField?.addBottomWholeSSBorderLineLeftMapping(AIApplication.AIColor.AIVIEWLINEColor, leftMapping: 0)
        
        // will to Pay 
        
        let QuestionTitle2 = AIWishTitleIconView.initFromNib() as! AIWishTitleIconView
        QuestionTitle2.icon.image = UIImage(named: "AI_Wish_Make_insterest")
        QuestionTitle2.title.text = "Tell us the price you are willing to pay"
        QuestionTitle2.title.font = AITools.myriadBoldWithSize(20)
        addNewSubView(QuestionTitle2, preView: textField!)
        QuestionTitle2.setHeight(53)
        QuestionTitle2.addBottomWholeSSBorderLineLeftMapping(AIApplication.AIColor.AIVIEWLINEColor, leftMapping: 0)
        
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
}