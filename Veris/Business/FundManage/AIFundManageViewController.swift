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
        //makeBackButton()
        // Do any additional setup after loading the view.

        setupNavigationBar()
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

        let frame = CGRect(x: 10, y: 10, width: 95, height: 35)
        let backButton = AIViews.baseButtonWithFrame(frame, normalTitle: " ")
        backButton.setImage(UIImage(named: "backIcon"), forState: .Normal)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 60)
        backButton.addTarget(self, action: #selector(backAction), forControlEvents: UIControlEvents.TouchUpInside)

        self.view.addSubview(backButton)
    }

    private func setupNavigationBar() {
        extendedLayoutIncludesOpaqueBars = true

        let backButton = UIButton()
        backButton.setImage(UIImage(named: "comment-back"), forState: .Normal)
        backButton.addTarget(self, action: #selector(UIViewController.dismiss), forControlEvents: .TouchUpInside)

        let deleteButton = UIButton()
        deleteButton.setImage(UIImage(named: "item_button_delete"), forState: .Normal)
        deleteButton.setSize(CGSize(width: 196.displaySizeFrom1242DesignSize(), height: 80.displaySizeFrom1242DesignSize()))

        let appearance = UINavigationBarAppearance()
        appearance.leftBarButtonItems = [backButton]
        appearance.rightBarButtonItems = [deleteButton]
        appearance.itemPositionForIndexAtPosition = { index, position in
            if position == .Left {
                return (47.displaySizeFrom1242DesignSize(), 55.displaySizeFrom1242DesignSize())
            } else {
                return (47.displaySizeFrom1242DesignSize(), 40.displaySizeFrom1242DesignSize())
            }
        }
        appearance.barOption = UINavigationBarAppearance.BarOption(backgroundColor: UIColor.clearColor(), backgroundImage: nil, removeShadowImage: true, height: AITools.displaySizeFrom1242DesignSize(192))
        setNavigationBarAppearance(navigationBarAppearance: appearance)
    }


}
