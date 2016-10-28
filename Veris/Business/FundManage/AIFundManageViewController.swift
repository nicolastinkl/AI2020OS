//
//  AIFundManageViewController.swift
//  AIVeris
//
//  Created by 王坜 on 16/6/28.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIFundManageViewController: AIBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //makeBackButton()
        // Do any additional setup after loading the view.
        self.title = "My Wattet"
        setupNavigationBar()
        
        // add view controller to this vc
        //let vc = AIMyWalletBalanceViewController.initFromNib()
        let vc = AIWillPayVController.init()
        presentBlurViewController(vc, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: NavigationBar
    override func setupNavigationBar() {

        let backButton = goBackButtonWithImage("comment-back")
        navigatonBarAppearance?.leftBarButtonItems = [backButton]
        setNavigationBarAppearance(navigationBarAppearance: navigatonBarAppearance!)
        
    }

    //MARK:

}
