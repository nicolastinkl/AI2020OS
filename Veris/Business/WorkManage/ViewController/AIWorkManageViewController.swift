//
//  AIWorkManageViewController.swift
//  AIVeris
//
//  Created by 王坜 on 16/6/28.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import AIAlertView

class AIWorkManageViewController: AIBaseViewController {

    //MARK:

    var mainTableView: UITableView!

    var queryMessage: AIMessage!

    var subcribledJobs: [AISubscribledJobModel]!

    //MARK: Functions

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        makeTableView()
        makeMainShowButton()

        self.title = "My Job"
    }


    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        AINetEngine.defaultEngine().cancelMessage(queryMessage)
    }

    //MARK: Make Content View





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

        makeRefreshAction()
    }

    //MARK: 查询数据

    func startQuery() {
        queryMessage = AIMessage()
        queryMessage.url = AIApplication.AIApplicationServerURL.querySubscribedWorkOpportunity.description
        queryMessage.body = ["user_id" : AILocalStore.userId]

        weak var wf = self
        AINetEngine.defaultEngine().postMessage(queryMessage, success: { (response) in
            if response is [AISubscribledJobModel] {
                wf!.subcribledJobs = response as! [AISubscribledJobModel]
                wf!.mainTableView.reloadData()
            }

            wf!.mainTableView.headerEndRefreshing()
        }) { (errorType, errorDesc) in
            AIAlertView().showError("出错啦！", subTitle: errorDesc)
            wf!.mainTableView.headerEndRefreshing()
        }
        
    }

    func makeRefreshAction() {

        if mainTableView == nil {
            return
        }

        weak var wf = self
        mainTableView.addHeaderWithCallback { 
            wf!.startQuery()
        }

        mainTableView.addHeaderRefreshEndCallback { 
            wf!.mainTableView.headerEndRefreshing()
        }





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


extension AIWorkManageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let bar = self.navigationController?.navigationBar
        let barHeight = CGRectGetHeight((bar?.frame)!)
        if offset > 0 && offset <= barHeight {
            let alpha = (barHeight - offset) / barHeight
            bar?.alpha = alpha > 0 ? alpha : 0
        } else if offset < 0 && offset >= -barHeight {
            if bar?.alpha <= 0 {
                let alpha = (barHeight + offset) / barHeight
                bar?.alpha = alpha
            }
        }
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
