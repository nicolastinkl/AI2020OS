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
import AIAlertView

//心愿预览
class AIWishPreviewController: UIViewController {
    
    /// Views
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var contentScrollview: UIScrollView!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var priceTitle: UIView!
    @IBOutlet weak var view_price: UIView!
    
    /// Constraint
    @IBOutlet weak var textpriceConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceConstraint: NSLayoutConstraint!
    
    /// Vars
    
    var model: AIWishHotChildModel?
    var preCacheView: UIView?
    var preContentCacheView: UIView?
    var textFeild: DesignableTextField?
    
    private var preWishView: AIWishTitleIconView?
    private var prePosition: CGPoint = CGPointMake(0, 0)
    private var averageMenoy: Int = 0
    private var averageTotalMenoy: Int = 0
    private var preAverageView: AIWishAverageView?
    
    /**
     Main Init
     */
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
            navi.titleLabel.text = model?.name
            navi.backButton.setImage(UIImage(named: "scan_back"), forState: UIControlState.Normal)
        }
        
        Async.main(after: 0.3) {
            self.initSubViews()
        }
    }
    
    /// 初始化处理
    func initSubViews() {
        averageMenoy = 22
        averageTotalMenoy = 200
        // Description
        let dbgView = UIView()
        dbgView.setHeight(82)
        addNewSubView(dbgView, preView: UIView())
        dbgView.backgroundColor = UIColor(hexString: "#000000", alpha: 0.15)
        
//        let DescriptionLabel = UILabel()
//        DescriptionLabel.font = AITools.myriadLightWithSize(20)
//        DescriptionLabel.text = "Find anywhere good camera, a good photogra-pher. There are currently 12 people and you have the same desire, the there are 8 people dream come true!"
//        DescriptionLabel.textAlignment = .Left
//        DescriptionLabel.lineBreakMode = .ByCharWrapping
//        DescriptionLabel.textColor = UIColor.whiteColor()
//        DescriptionLabel.setHeight(100)
//        DescriptionLabel.numberOfLines = 5
//        dbgView.addSubview(DescriptionLabel)
//        let dWidth = UIScreen.mainScreen().bounds.width - 50*2
//        DescriptionLabel.setWidth(dWidth)
//        DescriptionLabel.setLeft(50)
        
        let DescriptionLabel = AIWishTopView.initFromNib()!
        dbgView.addSubview(DescriptionLabel)
        DescriptionLabel.setWidth(UIScreen.mainScreen().bounds.width)
        DescriptionLabel.setHeight(82)
        
        // Question Title
        
        let QuestionTitle1 = AIWishTitleIconView.initFromNib() as! AIWishTitleIconView
        QuestionTitle1.icon.image = UIImage(named: "AI_Wish_Make_comment")
        QuestionTitle1.title.text = "See what they say about it"
        QuestionTitle1.title.font = AITools.myriadLightSemiCondensedWithSize(20)
        addNewSubView(QuestionTitle1, preView: DescriptionLabel)
        QuestionTitle1.setHeight(42)
        QuestionTitle1.addBottomWholeSSBorderLineLeftMapping(AIApplication.AIColor.AIVIEWLINEColor, leftMapping: 0)
        // Add Read All Button
        QuestionTitle1.button.hidden = false
        QuestionTitle1.button.addTarget(self, action: #selector(AIWishPreviewController.readallAction), forControlEvents: UIControlEvents.TouchUpInside)
        preWishView = QuestionTitle1
        
        // Top Scope
        let topScope = UIView()
        topScope.setHeight(10)
        addNewSubViewContent(topScope)
        
        let imgTop = UIImageView(image: UIImage(named: "AI_Wish_Make_top"))
        imgTop.setWidth(13)
        imgTop.setHeight(11)
        topScope.addSubview(imgTop)
        imgTop.setTop(13)
        imgTop.setLeft(15)
        
        // Answer List
        let AnswerList = ["Best to provider some commeon not to buy expensvie qure Trial ",
                          "Often go to the field,more concerned about their own shipping equipment , the best you can always hire some professional equipment",
                          "Professional photographers can hope to teach experience, and can have specific guideance", "Best to provider some commeon not to buy expensvie qure Trial ",
                           "Professional photographers can hope to teach experience, and can have specific guideance", "Best to provider some commeon not to buy expensvie qure Trial ",
                           "Professional photographers can hope to teach experience, and can have specific guideance", "Best to provider some commeon not to buy expensvie qure Trial "]
        
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
            addNewSubViewContent(QuestionTitleX)
            QuestionTitleX.setHeight(10 + sHeight)
        }
        
        // Down Scope
        let downScope = UIView()
        downScope.setHeight(10)
        addNewSubViewContent(downScope)
        
        let imgDown = UIImageView(image: UIImage(named: "AI_Wish_Make_down"))
        imgDown.setWidth(13)
        imgDown.setHeight(11)
        downScope.addSubview(imgDown)
        imgDown.setTop(-15)
        imgDown.setLeft(UIScreen.mainScreen().bounds.width - 27)
        
        // TextField
        let textField = AIWishTextWishsView.initFromNib()
        self.textView.addSubview(textField!)
        textField?.snp_makeConstraints(closure: { (make) in
            //make.edges.equalTo(self.textView)
            make.leftMargin.equalTo(0)
            make.rightMargin.equalTo(0)
            make.topMargin.equalTo(0)
            make.height.equalTo(85)//固定高度
        })
        if let newt = textField as? AIWishTextWishsView {
            textFeild = newt.textfeild
        }
        
        
        textField?.addBottomWholeSSBorderLineLeftMapping(AIApplication.AIColor.AIVIEWLINEColor, leftMapping: 0)
        // will to Pay
        let QuestionTitle2 = AIWishTitleIconView.initFromNib() as! AIWishTitleIconView
        QuestionTitle2.icon.image = UIImage(named: "AI_Wish_Make_insterest")
        QuestionTitle2.title.text = "The price you are willing to pay"
        QuestionTitle2.title.font = AITools.myriadLightSemiCondensedWithSize(20)
//        QuestionTitle2.setHeight(53)
        QuestionTitle2.backgroundColor = UIColor.clearColor()
        self.priceTitle.addSubview(QuestionTitle2)
        QuestionTitle2.snp_makeConstraints(closure: { (make) in
            make.edges.equalTo(self.priceTitle)
        })
        
        let wishAverage = AIWishAverageView.initFromNib() as?  AIWishAverageView
        wishAverage?.backgroundColor = UIColor(hexString: "#ffffff", alpha: 0.1)
        self.view_price.addSubview(wishAverage!)
        wishAverage?.snp_makeConstraints(closure: { (make) in
            make.edges.equalTo(self.view_price)
        })
        preAverageView = wishAverage
        preAverageView?.button.setTitle(String(averageMenoy), forState: UIControlState.Normal)
        preAverageView?.totalButton.setTitle(String(averageTotalMenoy), forState: UIControlState.Normal)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(AIWishPreviewController.subAverage))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        wishAverage?.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(AIWishPreviewController.addAverage))
        swipeRight.direction = .Right
        wishAverage?.addGestureRecognizer(swipeRight)
        
    }
    
    func addAverage() {
        averageMenoy += 10
        preAverageView?.button.setTitle(String(averageMenoy), forState: UIControlState.Normal)
        if averageMenoy >= averageTotalMenoy {
            
            preAverageView?.userInteractionEnabled = false
            
            self.preAverageView?.button.snp_removeConstraints()            
            self.preAverageView?.button.snp_makeConstraints(closure: { (make) in
                make.center.equalTo((self.preAverageView?.totalButton.snp_center)!)
                make.width.height.equalTo(76)
            })
            
            SpringAnimation.springEaseIn(0.5, animations: {
                 self.preAverageView?.button.layoutIfNeeded()
            })
        }
    }
    
    func subAverage() {
        if averageMenoy > 10 {
            averageMenoy -= 10
            preAverageView?.button.setTitle(String(averageMenoy), forState: UIControlState.Normal)
        }
    }
    
    func readallAction() {
        preWishView?.button.setTitle("Flod up", forState: UIControlState.Normal)
        preWishView?.button.removeTarget(self, action: #selector(AIWishPreviewController.readallAction), forControlEvents: UIControlEvents.TouchUpInside)
        preWishView?.button.addTarget(self, action: #selector(AIWishPreviewController.expendAction), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.textpriceConstraint.constant = 90
        self.priceConstraint.constant = 0
        
        SpringAnimation.springEaseIn(0.5, animations: {
            self.view.layoutIfNeeded()
            self.view_price.hidden = true
        })
    }
    
    func expendAction() {
        preWishView?.button.setTitle("Read all", forState: UIControlState.Normal)
        preWishView?.button.removeTarget(self, action: #selector(AIWishPreviewController.expendAction), forControlEvents: UIControlEvents.TouchUpInside)
        preWishView?.button.addTarget(self, action: #selector(AIWishPreviewController.readallAction), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.textpriceConstraint.constant = 160
        self.priceConstraint.constant = 132
        
        SpringAnimation.springEaseIn(0.5, animations: {
            self.view_price.hidden = false
            self.view.layoutIfNeeded()
        })
    }
    
    func addNewSubView(cview: UIView) {
        addNewSubView(cview, preView: preCacheView!)
    }
    
    func addNewSubView(cview: UIView, preView: UIView, color: UIColor = UIColor.clearColor(), space: CGFloat = 0) {
        scrollview.addSubview(cview)
        let width = UIScreen.mainScreen().bounds.size.width
        cview.setWidth(width)
        cview.setTop(preView.top + preView.height+space)
        cview.backgroundColor = color
        scrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), cview.top + cview.height)
        preCacheView = cview
    }
    
    /// Scrollview
    func addNewSubViewContent(cview: UIView) {
        if let _ = preContentCacheView {
            addNewSubViewContent(cview, preView: preContentCacheView!)
        } else {
            addNewSubViewContent(cview, preView: UIView())
        }
        
    }
    
    func addNewSubViewContent(cview: UIView, preView: UIView, color: UIColor = UIColor.clearColor(), space: CGFloat = 0) {
        contentScrollview.addSubview(cview)
        let width = UIScreen.mainScreen().bounds.size.width
        cview.setWidth(width)
        cview.setTop(preView.top + preView.height+space)
        cview.backgroundColor = color
        contentScrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), cview.top + cview.height)
        preContentCacheView = cview
    }
    
    @IBAction func subitAction(sender: AnyObject) {
        if let stext = self.textFeild?.text {
            let number: Double = 123
            view.showLoading()
//            AIWishServices.requestMakeWishs(number, wish: stext, complate: { (obj, error)  in
//                self.view.hideLoading()
//                if let _ = obj {
            
                    // 退出当前界面 然后通知主页刷新
                    // AIAlertView().showSuccess("提示", subTitle: "提交成功")
//                    if let alertView = AIAlertWishInputView.initFromNib() as? AIAlertWishInputView{
//                        self.view.addSubview(alertView)
//                        alertView.alpha = 0
//                        alertView.snp_makeConstraints(closure: { (make) in
//                            make.edges.equalTo(self.view)
//                        })
//                        SpringAnimation.springEaseIn(0.5, animations: {
//                            alertView.alpha = 1
//                        })
//                        alertView.buttonSubmit.addTarget(self, action: #selector(AIWishVowViewController.realSubmitAction), forControlEvents: UIControlEvents.TouchUpInside)
//                    }
//                    
//                    let model = AIBuyerBubbleModel()
//                    model.order_times = 1
//                    model.proposal_id_new = 1
//                    model.proposal_name =  String(self.model?.name ?? "")
//                    model.proposal_price = String(number)
//                    model.service_list = []
//                    model.service_id = 1
//                    NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.WishVowViewControllerNOTIFY, object: model)
//                    
//                    
//                } else {
//                    AIAlertView().showError("提示", subTitle: "提交失败，请重新提交")
//                }
//            })
        }
    
    }
    
    func realSubmitAction() {
        let number = "123"
        let stext = self.textFeild?.text ?? ""
        
        let model = AIBuyerBubbleModel()
        model.order_times = 1
        model.proposal_id_new = 1
        model.proposal_name = stext
        model.proposal_price = number
        model.service_list = []
        model.service_id = 1
        NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.WishVowViewControllerNOTIFY, object: model)
        
    }
    
    

}
