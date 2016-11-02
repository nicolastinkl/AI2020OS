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
    
    private let contentArray = ["我的余额", "我的信用积分", "我的商家币", "我的优惠券", "我的资金账户", "我的会员卡"]
    private let contentArrayColor = ["#7b3990", "#1c789f", "#619505", "#f79a00", "#d05126", "#b32b1d"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //makeBackButton()
        // Do any additional setup after loading the view.
        
        setupNavigationBar()
        
        // add view controller to this vc
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if contentScrollView.subviews.count > 0 {
            return
        }
        
        var index = 0
        contentArray.forEach { (string) in
            if let cell = AIFundCellView.initFromNib() as? AIFundCellView {
                cell.title.text = string
                let color = contentArrayColor[index]
                cell.round.backgroundColor = UIColor(hex: color)
                self.addNewSubView(cell)
                index  = index + 1
                cell.tag = index
                let tap = UITapGestureRecognizer(target: self, action: #selector(AIFundManageViewController.showAction(_:)))
                cell.addGestureRecognizer(tap)
            }
        }
        
    }
    
    //资金点击触发
    @IBAction func moneyListAction(sender: AnyObject) {
        
    }
    
    //跳转点击事件分发
    func showAction(ges: UITapGestureRecognizer) {
        if let tag = ges.view?.tag {
            switch tag {
            case 1:
                //我的余额
                let holdVC = AIMyWalletBalanceViewController.initFromNib()
                let vc = AIFundBaseViewCotroller.initFromNib()
                vc.setupFillView(holdVC)
                presentViewController(vc, animated: true, completion: nil)
                 
                break
            case 2:
                //我的信用积分
                break
            case 3:
                //我的商家币
                break
            case 4:
                //我的优惠券
                break
            case 5:
                //我的资金账户
                break
            case 6:
                //我的会员卡
                break
            case 7:
                //年收入
                break
            case 8:
                // 待付
                let vc = AIWillPayVController.init()
                presentBlurViewController(vc, animated: true, completion: nil)
                
                break
            case 9:
                // 待收
                let vc = AIWillReceiverVController.init()
                presentBlurViewController(vc, animated: true, completion: nil)
                break
                
            default:
                break
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: NavigationBar
    override func setupNavigationBar() {

        let backButton = goBackButtonWithImage("comment-back")
        navigatonBarAppearance?.leftBarButtonItems = [backButton]
        let font = AITools.myriadSemiCondensedWithSize(72.displaySizeFrom1242DesignSize())
        navigatonBarAppearance!.titleOption = UINavigationBarAppearance.TitleOption(bottomPadding: 40.displaySizeFrom1242DesignSize(), font: font, textColor: UIColor.whiteColor(), text: "我的钱包")
        setNavigationBarAppearance(navigationBarAppearance: navigatonBarAppearance!)
        
        zijinButton.layer.cornerRadius = 4
        zijinButton.layer.masksToBounds = true
        
        localCode {
            let badge = GIBadgeView()
            badge.badgeValue = 13
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
            badge.badgeValue = 5
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
            badge.badgeValue = 8
            badge.topOffset = 10
            badge.rightOffset = 5
            badge.font = AITools.myriadLightSemiExtendedWithSize(12)
            self.daishouView.addSubview(badge)
            self.daishouView.tag = 9
            let tap = UITapGestureRecognizer(target: self, action: #selector(AIFundManageViewController.showAction(_:)))
            self.daishouView.addGestureRecognizer(tap)
        }
       
        
        
       
        
        
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
