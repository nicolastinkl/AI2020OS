//
//  AIFundManageViewController.swift
//  AIVeris
//
//  Created by 王坜 on 16/6/28.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

/// 我的钱包首页
class AIFundManageViewController: AIBaseViewController {
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    private var preCacheView: UIView = UIView()
    @IBOutlet weak var zijinButton: UIButton!
    
    @IBOutlet weak var nianshouruView: UIView!
    @IBOutlet weak var daishouView: UIView!
    @IBOutlet weak var daifuView: UIView!
    @IBOutlet weak var daishou: UILabel!
    @IBOutlet weak var daifu: UILabel!
    @IBOutlet weak var total: UILabel!
    
    private let contentArray = ["我的余额", "我的信用积分", "我的商家币", "我的优惠券", "我的资金账户", "我的会员卡"]
    private let contentArrayColor = ["#7b3990", "#1c789f", "#619505", "#f79a00", "#d05126", "#b32b1d"]
    
    private var dataSource: AIFundManageModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //makeBackButton()
        // Do any additional setup after loading the view.
        
        setupNavigationBar()
        
        // add view controller to this vc
        
        AIFundManageServices.reqeustIndexInfo({ (model) in
            self.dataSource = model
            Async.main(after: 1) {
                self.fillViewWithData()
            }
            }) { (error) in
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if contentScrollView.subviews.count > 0 {
            return
        }
      
    }
    
    func fillViewWithData() {
        var index = 0
        daifu.text = String(dataSource?.total_wait_pay_amout ?? 0)
        daishou.text = String(dataSource?.total_wait_collection_amout ?? 0)
        total.text = String(dataSource?.total_income_amout ?? 0)
        
        
        localCode {
            let badge = GIBadgeView()
            badge.badgeValue = self.dataSource?.total_income_items ?? 0
            badge.topOffset = 10
            badge.rightOffset = 5
            badge.font = AITools.myriadLightSemiExtendedWithSize(12)
            self.nianshouruView.addSubview(badge)
            self.nianshouruView.tag = 7
            let tap = UITapGestureRecognizer(target: self, action: #selector(AIFundManageViewController.showAction(_:)))
            self.nianshouruView.addGestureRecognizer(tap)
        }
        
        localCode {
            let badge = GIBadgeView()
            badge.badgeValue =  self.dataSource?.total_wait_pay_items ?? 0
            badge.topOffset = 10
            badge.rightOffset = 5
            badge.font = AITools.myriadLightSemiExtendedWithSize(12)
            self.daifuView.addSubview(badge)
            self.daifuView.tag = 8
            let tap = UITapGestureRecognizer(target: self, action: #selector(AIFundManageViewController.showAction(_:)))
            self.daifuView.addGestureRecognizer(tap)
        }
        
        localCode {
            let badge = GIBadgeView()
            badge.badgeValue =  self.dataSource?.total_wait_collection_items ?? 0
            badge.topOffset = 10
            badge.rightOffset = 5
            badge.font = AITools.myriadLightSemiExtendedWithSize(12)
            self.daishouView.addSubview(badge)
            self.daishouView.tag = 9
            let tap = UITapGestureRecognizer(target: self, action: #selector(AIFundManageViewController.showAction(_:)))
            self.daishouView.addGestureRecognizer(tap)
        }
        
        
        
        dataSource?.drawers.forEach({ (model) in
            
            let string = contentArray[index]
            
            if let cell = AIFundCellView.initFromNib() as? AIFundCellView {
                cell.title.text = string
                cell.des.text = model.desc ?? ""
                cell.price.text = String( model.amout ?? 0)
                cell.unit.text = model.unit ?? ""
                
                let color = contentArrayColor[index]
                cell.round.backgroundColor = UIColor(hex: color)
                self.addNewSubView(cell)
                index  = index + 1
                cell.tag = index
                let tap = UITapGestureRecognizer(target: self, action: #selector(AIFundManageViewController.showAction(_:)))
                cell.addGestureRecognizer(tap)
            }
        })
        
    }
    
    //资金点击触发
    @IBAction func moneyListAction(sender: AnyObject) {
        let vc = CapitalFlowViewController.initFromStoryboard()
        let nav = UINavigationController(rootViewController: vc)
        presentBlurViewController(nav, animated: true, completion: nil)
    }
    
    //跳转点击事件分发
    func showAction(ges: UITapGestureRecognizer) {
        if let tag = ges.view?.tag {
            switch tag {
            case 1:
                //我的余额
                let holdVC = AIMyWalletBalanceViewController.initFromNib()
                let vc = AIFundBaseViewCotroller.initFromNib()
                showTransitionStyleCrossDissolveView(vc)
                vc.setupFillView(holdVC)
                break
            case 2:
                //我的信用积分
                break
            case 3:
                //我的商家币
                let vc = UIStoryboard(name: "AICouponsStoryboard", bundle: nil).instantiateViewControllerWithIdentifier("AIBusinessCurrencyViewController") as! AIBusinessCurrencyViewController
                let containerVC = AIFundBaseViewCotroller.initFromNib()
                containerVC.potColor = UIColor.orangeColor()
                containerVC.privacyLabelHide = true
                containerVC.title = "我的商家币"
                showTransitionStyleCrossDissolveView(containerVC)
                containerVC.setupFillView(vc)
                break
            case 4:
                //我的优惠券
                let vc = UIStoryboard(name: "AICouponsStoryboard", bundle: nil).instantiateViewControllerWithIdentifier("AICouponViewController") as! AICouponViewController
                let containerVC = AIFundBaseViewCotroller.initFromNib()
                containerVC.potColor = UIColor.orangeColor()
                containerVC.privacyLabelHide = true
                containerVC.title = "我的优惠券"
                let navigationController = UINavigationController(rootViewController: containerVC)
                showTransitionStyleCrossDissolveView(navigationController)
                //containerVC.setupFillView(navigationController)
            
                break
            case 5:
                //我的资金账户
                let holdVC = AIFundAccountViewController.initFromNib()
                let vc = AIFundBaseViewCotroller.initFromNib()
                vc.potColor = UIColor(hexString: "#ca4722")
                vc.privacyLabelHide = true
                vc.title = "我的资金账户"
                showTransitionStyleCrossDissolveView(vc)
                vc.setupFillView(holdVC)
                break
            case 6:
                //我的会员卡
                let holdVC = AIMyMemberCardViewController.initFromNib()
                let vc = AIFundBaseViewCotroller.initFromNib()
                vc.potColor = UIColor(hexString: "#aa261b")
                vc.privacyLabelHide = true
                vc.title = "我的会员卡"
                showTransitionStyleCrossDissolveView(vc)
                vc.setupFillView(holdVC)
                break
            case 7:
                //年收入
                break
            case 8:
                // 待付
                let vc = AIWillPayVController.init()
                showTransitionStyleCrossDissolveView(vc)
                
                break
            case 9:
                // 待收
                let vc = AIWillReceiverVController.init()
                showTransitionStyleCrossDissolveView(vc)
                break
                
            default:
                break
            }
        }
        
        
    }
    
    //MARK: NavigationBar
    override func setupNavigationBar() {

        let backButton = goBackButtonWithImage("comment-back")
        navigatonBarAppearance?.leftBarButtonItems = [backButton]
        let font = AITools.myriadSemiCondensedWithSize(72.displaySizeFrom1242DesignSize())
        navigatonBarAppearance?.titleOption = UINavigationBarAppearance.TitleOption(bottomPadding: 40.displaySizeFrom1242DesignSize(), font: font, textColor: UIColor.whiteColor(), text: "我的钱包")
        setNavigationBarAppearance(navigationBarAppearance: navigatonBarAppearance!)
        
        zijinButton.layer.cornerRadius = 4
        zijinButton.layer.masksToBounds = true
        
        
        
    }

    //MARK:
    
    /**
     copy from old View Controller.
     */
    func addNewSubView(cview: UIView, color: UIColor = UIColor.clearColor(), space: CGFloat = 0) {
        contentScrollView.addSubview(cview)
        cview.setWidth(self.view.width)
        cview.setTop(preCacheView.top + preCacheView.height+space)
        cview.backgroundColor = color
        contentScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), cview.top + cview.height)
        preCacheView = cview
    }
}
