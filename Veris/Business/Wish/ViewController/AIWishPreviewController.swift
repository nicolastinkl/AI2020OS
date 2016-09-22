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
import IQKeyboardManagerSwift

//心愿预览
class AIWishPreviewController: UIViewController {
    
    /// Views
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var contentScrollview: UIScrollView!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var priceTitle: UIView!
    @IBOutlet weak var view_price: UIView!
    @IBOutlet weak var submitButton: UIButton!
    
    /// Constraint
    @IBOutlet weak var textpriceConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var contentConstraint: NSLayoutConstraint!
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
    private var enbleEdit: Bool = false
    private var preContentView: AIWishTextWishsView?
 
    // MARK: Method Init
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.setTitle("AIWishVowViewController.Submit".localized, forState: UIControlState.Normal)
        submitButton.enabled = false
        if let navi = AINavigationBar.initFromNib() as? AINavigationBar {
            view.addSubview(navi)
            navi.holderViewController = self
            constrain(navi, block: { (layout) in
                layout.left == layout.superview!.left
                layout.top == layout.superview!.top
                layout.right == layout.superview!.right
                layout.height == 44.0 + 10.0 + 17
            })
            navi.titleLabel.font = AITools.myriadCondWithSize(24)
            navi.titleLabel.text = model?.name
            navi.backButton.setImage(UIImage(named: "scan_back"), forState: UIControlState.Normal)
        }
        
        // Reqeust network's queryWishRecordList
        Async.main(after: 0.3) {
            self.initData()
        }        
    }
    
    func initData() {
        
        // Get Data
        view.showLoading()
        AIWishServices.requestListQueryWishs(self.model?.type_id ?? 0) { (obj, error) in
            self.view.hideLoading()
            if let resultArray = obj as? [String] {
                self.view.hideErrorView()
                self.initSubViews(resultArray)
            } else {
                self.view.showErrorView()
            }
        }
        
        // 检测是否同一个customer
        
        AIWishServices.requestCheckBolWish(self.model?.type_id ?? 0) { (obj, error) in
            if let result = obj as? String {
                if result == "0" {
                    //这里是标识不能再次被编辑和提交
                    self.enbleEdit = false
                    self.preContentView?.textfeild.enabled = false
                    
                } else if result == "1" {
                    self.enbleEdit = true
                    self.submitButton.enabled = true
                    self.preContentView?.textfeild.enabled = true
                }
            }
        }
    }
    
    /**
     重新请求数据
     */
    func retryNetworkingAction() {        
        initData()
    }
    /// 初始化处理
    func initSubViews(cotentsArray: [String]) {
        averageMenoy = Int(model?.money_avg ?? 0)
        averageTotalMenoy = Int(model?.money_adv ?? 0)
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
        
        let DescriptionLabel = AIWishTopView.initFromNib() as! AIWishTopView
        dbgView.addSubview(DescriptionLabel)
        DescriptionLabel.setWidth(UIScreen.mainScreen().bounds.width)
        DescriptionLabel.setHeight(82)
        DescriptionLabel.contentText.text = model?.contents
        DescriptionLabel.wishText.text = "\(model?.already_wish ?? 0) \("AIWishPreviewController.wished".localized)"
        DescriptionLabel.moreText.text = "\(model?.target_wish ?? 0) \("AIWishPreviewController.moreto".localized)"
        
        // Question Title
        
        let QuestionTitle1 = AIWishTitleIconView.initFromNib() as! AIWishTitleIconView
        QuestionTitle1.icon.image = UIImage(named: "AI_Wish_Make_comment")
        QuestionTitle1.title.text = "AIWishPreviewController.seewhatsay".localized
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
        let AnswerList = cotentsArray
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
            newt.textfeild.text = "AIWishPreviewController.noteyourwish".localized
        }
        preContentView = textField as? AIWishTextWishsView
        self.preContentView?.textfeild.enabled = false
        textField?.addBottomWholeSSBorderLineLeftMapping(AIApplication.AIColor.AIVIEWLINEColor, leftMapping: 0)
        // will to Pay
        let QuestionTitle2 = AIWishTitleIconView.initFromNib() as! AIWishTitleIconView
        QuestionTitle2.icon.image = UIImage(named: "AI_Wish_Make_insterest")
        QuestionTitle2.title.text = "AIWishPreviewController.whatpriceyouwill".localized
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
        wishAverage?.inputPrice.delegate = self
        
        preAverageView = wishAverage
        preWishView?.button.setTitle("AIWishPreviewController.readall".localized, forState: UIControlState.Normal)
        //preAverageView?.button.setTitle(String(averageMenoy), forState: UIControlState.Normal)
        preAverageView?.totalButton.setTitle(String(averageTotalMenoy), forState: UIControlState.Normal)
        preAverageView?.currentPrice = averageMenoy
        preAverageView?.totalPrice = averageTotalMenoy
        /*let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(AIWishPreviewController.subAverage))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        wishAverage?.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(AIWishPreviewController.addAverage))
        swipeRight.direction = .Right
        wishAverage?.addGestureRecognizer(swipeRight)
        */
        //wishAverage?.button.setTitle("\(Int(model?.money_avg ?? 0))", forState: UIControlState.Normal)
        wishAverage?.inputPrice.text = "\(Int(model?.money_avg ?? 0))"
        let totalPrice = model?.money_adv ?? 0
        if totalPrice > 9999 {
            let newTO = totalPrice/10000
            wishAverage?.totalButton.setTitle("\(newTO)w", forState: UIControlState.Normal)
        } else {
            wishAverage?.totalButton.setTitle("\(model?.money_adv ?? 0)", forState: UIControlState.Normal)
        }
        
        wishAverage?.averageLabel.text = "AIWishPreviewController.average".localized
        wishAverage?.leftRMB.text = "AIWishPreviewController.unit".localized
        wishAverage?.rightRMB.text = "AIWishPreviewController.unit".localized
        
    }
    
    func addAverage() {
        averageMenoy += 10
        preAverageView?.inputPrice.text = String(averageMenoy)
        //preAverageView?.button.setTitle(String(averageMenoy), forState: UIControlState.Normal)
        meger()
    }
    
    func meger() {
        
        if averageMenoy == averageTotalMenoy {
            
            preAverageView?.userInteractionEnabled = false
            
            self.preAverageView?.button.hidden = true
            self.preAverageView?.leftRMB.hidden = true
            self.preAverageView?.inputButtonView.hidden = true
            let newDesignButton = DesignableButton()
            newDesignButton.frame = self.preAverageView!.totalButton.frame
            self.preAverageView?.insertSubview(newDesignButton, belowSubview: self.preAverageView!.rightRMB)
            self.preAverageView!.rightRMB.textColor = UIColor(hexString: "FFBA00")
            newDesignButton.cornerRadius = 76/2
            newDesignButton.borderWidth = 2
            newDesignButton.titleLabel?.font = self.preAverageView!.totalButton.titleLabel?.font
            newDesignButton.borderColor = UIColor.whiteColor()
            newDesignButton.backgroundColor = UIColor(hex: "#0C93D9")
            newDesignButton.alpha = 0
            newDesignButton.center = (self.preAverageView!.button.center)
            newDesignButton.setTitleColor(UIColor(hexString: "FFBA00"), forState: UIControlState.Normal)
            newDesignButton.setTitle(String(averageMenoy), forState: UIControlState.Normal)
            SpringAnimation.springEaseIn(0.5, animations: {
                newDesignButton.center = self.preAverageView!.totalButton.center
                newDesignButton.alpha = 1
            })
        }
    }
    
    func subAverage() {
        if averageMenoy > 10 {
            averageMenoy -= 10
            preAverageView?.inputPrice.text = String(averageMenoy)
            //preAverageView?.button.setTitle(String(averageMenoy), forState: UIControlState.Normal)
        }
    }
    
    func readallAction() {
        preWishView?.button.setTitle("AIWishPreviewController.floadup".localized, forState: UIControlState.Normal)
        preWishView?.button.removeTarget(self, action: #selector(AIWishPreviewController.readallAction), forControlEvents: UIControlEvents.TouchUpInside)
        preWishView?.button.addTarget(self, action: #selector(AIWishPreviewController.expendAction), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.textpriceConstraint.constant = 90
        self.priceConstraint.constant = 0
        //self.contentConstraint.constant = 320
        self.contentScrollview.contentSize = CGSizeMake(self.view.width, 320)
        SpringAnimation.springEaseIn(0.5, animations: {
            self.view.layoutIfNeeded()
            self.view_price.hidden = true
        })
    }
    
    func expendAction() {
        preWishView?.button.setTitle("AIWishPreviewController.readall".localized, forState: UIControlState.Normal)
        preWishView?.button.removeTarget(self, action: #selector(AIWishPreviewController.expendAction), forControlEvents: UIControlEvents.TouchUpInside)
        preWishView?.button.addTarget(self, action: #selector(AIWishPreviewController.readallAction), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.textpriceConstraint.constant = 160
        self.priceConstraint.constant = 132
        //self.contentConstraint.constant = 150
        self.contentScrollview.contentSize = CGSizeMake(self.view.width, 150)
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
            
            if enbleEdit == false {
                AIAlertView().showError("AIWishPreviewController.noteyourwishnotify".localized, subTitle: "")
                return
            }
            
            if stext.length <= 0 || stext == "AIWishPreviewController.noteyourwish".localized {
                AIAlertView().showError("AIWishPreviewController.noteyourwish".localized, subTitle: "")
                return
            }
            let number: Double = Double(averageMenoy)
            view.showLoading()
            AIWishServices.requestMakeWishs(model?.type_id ?? 0, name: model?.name ?? "", money: number, contents: stext, complate: { (obj, error) in
                self.view.hideLoading()
                if let _ = obj {
                    let model = AIBuyerBubbleModel()
                    model.order_times = self.model?.already_wish ?? 0
                    model.proposal_id_new = 1
                    model.proposal_name = self.model?.name ?? ""
                    model.proposal_price = "￥\(number)"
                    model.service_list = []
                    model.service_id = self.model?.type_id ?? 0
                    model.proposal_type = 3
                    if model.service_id == 0 {
                    NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.WishVowViewControllerNOTIFY, object: model)
                    }
                    self.dismissViewControllerAnimated(false, completion: nil)
                    self.dismissViewControllerAnimated(false, completion: nil)
                    
                } else {
                    AIAlertView().showError("AIAlertView.Title".localized, subTitle: "AIAlertView.SubmitError".localized)
                }
            })
        }
    }

}

extension AIWishPreviewController: UITextViewDelegate {
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        let text = textView.text
        if text.isEmpty {
            textView.text = "0"
            averageMenoy = 0
        } else {
            let number = text.toInt() ?? 0
            averageMenoy = number
            if averageMenoy == averageTotalMenoy {
                //处理融合动画
                textView.hidden = true
                meger()
            }
        }
        
        return true
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        textView.text = ""
        return true
    }
    
}
