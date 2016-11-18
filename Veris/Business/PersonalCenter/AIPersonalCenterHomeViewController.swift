//
//  AIPersonalCenterHomeViewController.swift
//  AIVeris
//
//  Created by zx on 11/15/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIPersonalCenterHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
    }
    
    func setupNavigationItems() {
        extendedLayoutIncludesOpaqueBars = true
        
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "comment-back"), forState: .Normal)
        backButton.addTarget(self, action: #selector(AIPersonalCenterHomeViewController.backButtonPressed(_:)), forControlEvents: .TouchUpInside)
        
        let appearance = UINavigationBarAppearance()
        appearance.leftBarButtonItems = [backButton]
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

    @IBAction func backButtonPressed(sender: UIButton) {
        AIOpeningView.instance().show()
    }
}
