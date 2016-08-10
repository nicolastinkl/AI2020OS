//
//  AIWorkManageViewController.swift
//  AIVeris
//
//  Created by 王坜 on 16/6/28.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIWorkManageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        makeBackButton()
        setupNavigationBar()
    }

    //MARK: 设置基本属性
    func makeBaseProperties() {
        
    }

    //MARK: back button
    func makeBackButton() {

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
