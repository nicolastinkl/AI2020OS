//
//  AIWorkManageViewController.swift
//  AIVeris
//
//  Created by 王坜 on 16/6/28.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIWorkManageViewController: AIBaseViewController {

    //MARK:

    var tableView: UITableView!


    //MARK: Functions

    override func viewDidLoad() {
        super.viewDidLoad()


        setupNavigationBar()
        makeTableView()
        makeMainShowButton()
    }



    //MARK: Main Button


    func makeMainShowButton() {
        let x = AITools.displaySizeFrom1080DesignSize(40)
        let y = CGRectGetHeight(self.view.frame) - AITools.displaySizeFrom1080DesignSize(210)
        let width = CGRectGetWidth(self.view.frame) - x * 2
        let height = AITools.displaySizeFrom1080DesignSize(185)
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let mainButton = AIViews.baseButtonWithFrame(frame, normalTitle: "See More Opportunity")
        mainButton.titleLabel?.font = AITools.myriadSemiboldSemiCnWithSize(AITools.displaySizeFrom1080DesignSize(60))
        mainButton.titleLabel?.textColor = UIColor.whiteColor()
        mainButton.layer.cornerRadius = height / 2
        mainButton.clipsToBounds = true
        mainButton.backgroundColor = AITools.colorWithR(15, g: 110, b: 197)
        mainButton.addTarget(self, action: #selector(self.gotoWorkInfoViewController), forControlEvents: UIControlEvents.TouchUpInside)

        self.view.addSubview(mainButton)
    }

    override func setupNavigationBar() {

        let backButton = goBackButtonWithImage("comment-back")
        navigatonBarAppearance?.leftBarButtonItems = [backButton]
        setNavigationBarAppearance(navigationBarAppearance: navigatonBarAppearance!)
    }

    //MARK: 到工作机会首页
    func gotoWorkInfoViewController() {
        AILog("asdasd")
    }


    //MARK: 构造表格

    func makeTableView() {
        tableView = UITableView(frame: self.view.bounds, style: .Grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.clearColor()
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = .None
        tableView.showsVerticalScrollIndicator = false
        self.view.addSubview(tableView!)
    }



}


extension AIWorkManageViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let reuseIdentifier: String = "JobReuseCell"
        let cell = AIJobTableViewCell(style: .Default, reuseIdentifier: reuseIdentifier)
        cell.backgroundColor = UIColor.clearColor()
        let model = AIJobSurveyModel()
        model.jobIcon = ""
        model.jobDescription = "Private Transport"

        cell.resetCellModel(model)

        return cell
    }

}


extension AIWorkManageViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30.displaySizeFrom1242DesignSize()
//    }

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
