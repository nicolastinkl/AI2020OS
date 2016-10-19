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

    var subcribledJobs: [AnyObject]!

    //MARK: Functions

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        makeTableView()
        makeMainShowButton()

        self.title = "AIWorkManageViewController.Title".localized
    }



    //MARK: Make Content View


    override func clickBackAction () {
        super.clickBackAction()
        AINetEngine.defaultEngine().cancelMessage(queryMessage)
    }


    //MARK: Main Button


    func makeMainShowButton() {
        let x = AITools.displaySizeFrom1080DesignSize(39)
        let y = CGRectGetHeight(self.view.frame) - AITools.displaySizeFrom1080DesignSize(229)
        let width = CGRectGetWidth(self.view.frame) - x * 2
        let height = AITools.displaySizeFrom1080DesignSize(182)
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let mainButton = AIViews.baseButtonWithFrame(frame, normalTitle: "AIWorkManageViewController.SeeMore".localized)
        mainButton.titleLabel?.font = AITools.myriadSemiboldSemiCnWithSize(AITools.displaySizeFrom1080DesignSize(80))
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

        var tableFrame = self.view.bounds
        tableFrame.size.height = tableFrame.size.height - AITools.displaySizeFrom1080DesignSize(229)

        mainTableView = UITableView(frame: self.view.bounds, style: .Grouped)
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.separatorColor = UIColor.clearColor()
        mainTableView.backgroundColor = UIColor.clearColor()
        mainTableView.separatorStyle = .None
        mainTableView.showsVerticalScrollIndicator = false
        
        self.view.addSubview(mainTableView)

        makeRefreshAction()
        mainTableView.headerBeginRefreshing()
    }

    //MARK: 查询数据

    func startQuery() {
        queryMessage = AIMessage()
        queryMessage.url = AIApplication.AIApplicationServerURL.querySubscribedWorkOpportunity.description
        queryMessage.body = ["user_id" : AILocalStore.userId]

        weak var wf = self
        AINetEngine.defaultEngine().postMessage(queryMessage, success: { (response) in
            if response is [AnyObject] {
                wf!.subcribledJobs = response as! [AnyObject]
                wf!.mainTableView.reloadData()
            }

            wf!.mainTableView.headerEndRefreshing()
        }) { (errorType, errorDesc) in
            AIAlertView().showError(errorDesc, subTitle: "")
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

        return subcribledJobs != nil ? subcribledJobs.count : 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let reuseIdentifier: String = "JobReuseCell"
        let cell = AIJobTableViewCell(style: .Default, reuseIdentifier: reuseIdentifier)
        cell.backgroundColor = UIColor.clearColor()
        cell.actionDelegate = self
        let jobData: [String : AnyObject] = subcribledJobs[indexPath.section] as! [String : AnyObject]

        do {
            let model: AISubscribledJobModel = try AISubscribledJobModel(dictionary: jobData)
            cell.resetCellModel(model)
        } catch {

        }


        return cell
    }

}


extension AIWorkManageViewController: AIJobTableViewCellDelegate {
    func didTriggerJobActionToUploadInformation() {

    }

    func didTriggerJobActionToUploadStateParams(params: [String : AnyObject]) {

        self.showLoading()

        var body: [String : AnyObject] = ["user_id" : AILocalStore.userId]
        body.addEntriesFromDictionary(params)


        let message = AIMessage()
        message.url = AIApplication.AIApplicationServerURL.updateWorkStatus.description
        message.body = BDKTools.createRequestBody(body)

        weak var wf = self
        AINetEngine.defaultEngine().postMessage(message, success: { (response) in
            let result: NSNumber = response["result"] as! NSNumber
            if result.boolValue == true {
                wf!.mainTableView.headerBeginRefreshing()
            }
            wf!.dismissLoading()
        }) { (errorType, errorDesc) in
            wf!.dismissLoading()
            AIAlertView().showError(errorDesc, subTitle: "")
        }
    }
}


extension AIWorkManageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let bar = self.navigationController?.navigationBar

        if offset > 0 {
            bar?.alpha = 0
        } else if offset <= 0 {
            bar?.alpha = 1
        }
    }
}

extension AIWorkManageViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 395.displaySizeFrom1242DesignSize()
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
