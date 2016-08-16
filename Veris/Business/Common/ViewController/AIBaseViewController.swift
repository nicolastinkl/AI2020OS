//
//  AIBaseViewController.swift
//  AIVeris
//
//  Created by 王坜 on 16/8/10.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIBaseViewController: UIViewController {

    //MARK: Private Properties
    private var blurBackgroundView: UIVisualEffectView?
    private var goBackButton: UIButton?

    //MARK: Public Properties

    var navigatonBarAppearance: UINavigationBarAppearance?

    var shouldShowBlurBackground: Bool? {
        didSet {
            blurBackgroundView?.hidden = shouldShowBlurBackground != true
        }
    }






    override func viewDidLoad() {
        super.viewDidLoad()
        makeBaseProperties()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: 设置基本属性
    internal func makeBaseProperties() {

        makeBackgroundView()
        makeBlurBackgroundView()
        makeNavigatoinBar()
    }


    func makeBackgroundView() {
        let backgroundView = UIImageView(frame: self.view.bounds)
        backgroundView.image = UIImage(named: "search_background")
        self.view.addSubview(backgroundView)
    }

    func makeBlurBackgroundView() {
        let blurEffect = UIBlurEffect(style: .Dark)
        blurBackgroundView = UIVisualEffectView(effect: blurEffect)
        blurBackgroundView?.frame = self.view.bounds
        self.view.addSubview(blurBackgroundView!)
    }

    //Make navigatonBarAppearance
    func makeNavigatoinBar() {

        if self.navigationController == nil {
            return
        }
        extendedLayoutIncludesOpaqueBars = true
        navigatonBarAppearance = UINavigationBarAppearance()

        navigatonBarAppearance!.itemPositionForIndexAtPosition = { index, position in
            if position == .Left {
                return (47.displaySizeFrom1242DesignSize(), 55.displaySizeFrom1242DesignSize())
            } else {
                return (47.displaySizeFrom1242DesignSize(), 40.displaySizeFrom1242DesignSize())
            }
        }

        navigatonBarAppearance!.barOption = UINavigationBarAppearance.BarOption(backgroundColor: UIColor.clearColor(), backgroundImage: nil, removeShadowImage: true, height: AITools.displaySizeFrom1242DesignSize(192))

    }

    //MARK:
    func setupNavigationBar() {

    }

    //MARK: 提供默认的返回按钮

    func goBackButtonWithImage(name: String) -> UIButton {
        let button = UIButton(type: .Custom)
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 44)
        button.setImage(UIImage(named: name), forState: .Normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 60)
        button.addTarget(self, action: #selector(UIViewController.dismiss), forControlEvents: .TouchUpInside)

        return button
    }

}