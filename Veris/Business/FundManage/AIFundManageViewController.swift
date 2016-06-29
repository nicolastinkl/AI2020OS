//
//  AIFundManageViewController.swift
//  AIVeris
//
//  Created by 王坜 on 16/6/28.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIFundManageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        makeBackButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: 设置基本属性
    func makeBaseProperties() {

    }


    //MARK: back button

    func backAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func makeBackButton() {

        let frame = CGRect(x: 10, y: 10, width: 35, height: 35)
        let backButton = AIViews.baseButtonWithFrame(frame, normalTitle: "")

        backButton.setImage(UIImage(named: "backIcon"), forState: .Normal)

        backButton.addTarget(self, action: #selector(backAction), forControlEvents: UIControlEvents.TouchUpInside)

        self.view.addSubview(backButton)
    }

}
