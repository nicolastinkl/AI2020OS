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

    var mainTableView: UITableView!


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
        let vc = AIWorkOpportunityIndexViewController()
        presentViewController(vc, animated: true, completion: nil)
    }


    //MARK: 构造表格

    func makeTableView() {
        mainTableView = UITableView(frame: self.view.bounds, style: .Grouped)
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.separatorColor = UIColor.clearColor()
        mainTableView.backgroundColor = UIColor.clearColor()
        mainTableView.separatorStyle = .None
        mainTableView.showsVerticalScrollIndicator = false
        self.view.addSubview(mainTableView)
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
        model.jobIcon = "http://img5.imgtn.bdimg.com/it/u=4115455389,1829632566&fm=11&gp=0.jpg"
        model.jobDescription = "Private Transport"

        cell.resetCellModel(model)

        return cell
    }

}


extension AIWorkManageViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        if section == 0 {
            return 200.displaySizeFrom1242DesignSize()
        } else {
            return 30.displaySizeFrom1242DesignSize()
        }

    }

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        
        return 1
    }
}
