//
//  AIFundManageViewController.swift
//  AIVeris
//
//  Created by 王坜 on 16/6/28.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIFundManageViewController: AIBaseViewController {

    @IBOutlet weak var contentScrollView: UIScrollView!
    private var preCacheView: UIView = UIView()
    
    private let contentArray = ["我的余额", "我的信用积分", "我的商家币", "我的优惠券", "我的资金账户", "我的会员卡"]
    private let contentArrayColor = ["#7b3990", "#1c789f", "#619505", "#f79a00", "#d05126", "#b32b1d"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //makeBackButton()
        // Do any additional setup after loading the view.
        self.title = "My Wattet"
        setupNavigationBar()
        
        // add view controller to this vc
        //let vc = AIMyWalletBalanceViewController.initFromNib()
        //let vc = AIWillPayVController.init()
        //presentBlurViewController(vc, animated: true, completion: nil)        
       
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var index = 0
        contentArray.forEach { (string) in
            if let cell = AIFundCellView.initFromNib() as? AIFundCellView {
                cell.title.text = string
                let color = contentArrayColor[index]
                cell.round.backgroundColor = UIColor(hex: color)
                self.addNewSubView(cell)
                index  = index + 1
                cell.tag = index
                let tap = UITapGestureRecognizer(target: self, action: Selector("showAction:"))
                cell.addGestureRecognizer(tap)
            }
        }
        
    }
    
    //跳转点击事件分发
    func showAction(ges: UITapGestureRecognizer) {
        if let tag = ges.view?.tag {
            switch tag {
            case 1:
                //我的余额
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
