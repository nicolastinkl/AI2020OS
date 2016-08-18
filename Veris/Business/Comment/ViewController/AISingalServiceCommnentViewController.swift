//
//  AISingalServiceCommnentViewController.swift
//  AIVeris
//
//  Created by 王坜 on 16/8/9.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AISingalServiceCommnentViewController: AIBaseViewController {

    //MARK: Properties

    var submitButton: UIButton!




    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        setupNavigationBar()
        makeTitle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        AILog("\(CGRectGetHeight((self.navigationController?.navigationBar.bounds)!))")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


    //MARK: Configure NavigationBar
    override func setupNavigationBar() {

        let backButton = goBackButtonWithImage("comment-back")
        navigatonBarAppearance?.leftBarButtonItems = [backButton]
        submitButton  = makeSubmitButton()
        navigatonBarAppearance?.rightBarButtonItems = [submitButton]

        
        setNavigationBarAppearance(navigationBarAppearance: navigatonBarAppearance!)
    }

    func makeSubmitButton() -> UIButton {
        let button = UIButton(type: .Custom)
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 24)
        button.setTitle("submit", forState: UIControlState.Normal)
        button.titleLabel?.textAlignment = .Right
        button.titleLabel?.font = AITools.myriadSemiCondensedWithSize(60.displaySizeFrom1242DesignSize())
        button.titleLabel?.textColor = AITools.colorWithHexString("0f86e8")
        button.addTarget(self, action: #selector(submitAction), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }


    func makeTitle() {
        let y = 60.displaySizeFrom1242DesignSize()
        let height = 72.displaySizeFrom1242DesignSize()
        let frame = CGRect(x: 0, y: y, width: 200, height: height)
        let titleLabel = AIViews.normalLabelWithFrame(frame, text: "Review", fontSize: height, color: UIColor.whiteColor())
        titleLabel.textAlignment = .Center

        self.navigationItem.titleView = titleLabel

    }

    //MARK: Actions

    func submitAction() {

    }
}
