//
//  AICustomerServiceExecuteViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/6/16.
//  Base on Aerolitec Template
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

// MARK: -
// MARK: AICustomerServiceExecuteViewController
// MARK: -
internal class AICustomerServiceExecuteViewController: UIViewController {
    

    // MARK: -
    // MARK: Public access
    // MARK: -

    // MARK: -> Public properties

    var serviceInstsView: AIVerticalScrollView!
    var models: [IconServiceIntModel]?
    var orderInfoContentView: AITimelineTopView?
    var orderInfoModel: AICustomerOrderDetailTopViewModel?
    var timelineModels: [AITimelineViewModel] = []
    var cellHeightArray: Array<CGFloat>!


    // MARK: -> Public class methods

    // MARK: -> Public init methods




    // MARK: -> Public protocol <#protocol name#>

    // MARK: -> Interface Builder properties

    @IBOutlet weak var buttonAll: UIButton!
    @IBOutlet weak var buttonMessage: UIButton!
    @IBOutlet weak var buttonNeedReply: UIButton!
    @IBOutlet weak var serviceIconContainerView: UIView!
    @IBOutlet weak var timelineTableView: UITableView!
    @IBOutlet weak var orderInfoView: UIView!



    // MARK: -> Interface Builder actions

    //点击左边的切换时间线过滤规则按钮事件
    @IBAction func timelineFilterButtonAction(sender: UIButton) {
        let tag = sender.tag
        switch tag {
        case 1:
            buttonAll.selected = true
            buttonMessage.selected = false
            buttonNeedReply.selected = false
        case 2:
            buttonAll.selected = false
            buttonMessage.selected = true
            buttonNeedReply.selected = false
        case 3:
            buttonAll.selected = false
            buttonMessage.selected = false
            buttonNeedReply.selected = true
        default:
            break
        }
        filterTimeline()
    }

    @IBAction func contactAction(sender: UIButton) {
    }


    @IBAction func filterPopAction(sender: UIButton) {

    }



    @IBAction func navigationBackAction(sender: AnyObject) {
        self.dismissPopupViewController(true, completion: nil)
    }


    // MARK: -> Class override UIViewController

    override internal func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupViews()
        loadData()
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if serviceInstsView == nil {
            buildServiceInstsView()
        }
    }

    // MARK: -> Public methods

    func setupViews() {
        //orderInfoView
        orderInfoContentView = AITimelineTopView.createInstance()
        orderInfoView.addSubview(orderInfoContentView!)
        //orderInfoContentView?.delegate = self

        orderInfoContentView?.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(orderInfoView)
        }

        orderInfoModel = AICustomerOrderDetailTopViewModel()
        orderInfoModel?.serviceIcon = "http://171.221.254.231:3000/upload/shoppingcart/Hm7ulONUnenmN.png"
        orderInfoModel?.serviceName = "孕检无忧"
        orderInfoModel?.completion = 0.75
        orderInfoModel?.price = "340"
        orderInfoModel?.serviceDesc = "孕检无负担，轻松愉快。"
        orderInfoContentView?.model = orderInfoModel
        //timeLine tableView
        timelineTableView.registerNib(UINib(nibName: AIApplication.MainStoryboard.CellIdentifiers.AITimelineTableViewCell, bundle: nil), forCellReuseIdentifier: AIApplication.MainStoryboard.CellIdentifiers.AITimelineTableViewCell)
        timelineTableView.registerNib(UINib(nibName: AIApplication.MainStoryboard.CellIdentifiers.AITimelineNowTableViewCell, bundle: nil), forCellReuseIdentifier: AIApplication.MainStoryboard.CellIdentifiers.AITimelineNowTableViewCell)
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
    }

    func buildServiceInstsView() {

        models = [IconServiceIntModel(serviceInstId: 1, serviceIcon: "http://171.221.254.231:3000/upload/proposal/NKfG9YRqfEZq3.png", serviceInstStatus: ServiceInstStatus.Assigned, executeProgress: 1), IconServiceIntModel(serviceInstId: 1, serviceIcon: "http://171.221.254.231:3000/upload/proposal/NKfG9YRqfEZq3.png", serviceInstStatus: ServiceInstStatus.Assigned, executeProgress: 1), IconServiceIntModel(serviceInstId: 1, serviceIcon: "http://171.221.254.231:3000/upload/proposal/NKfG9YRqfEZq3.png", serviceInstStatus: ServiceInstStatus.Assigned, executeProgress: 1)]
        if let models = models {

            let frame = serviceIconContainerView.bounds
            serviceInstsView = AIVerticalScrollView(frame: frame, needCheckAll : false)
            serviceInstsView.userInteractionEnabled = true
            serviceInstsView.myDelegate = self
            serviceInstsView.showsVerticalScrollIndicator = false
            serviceIconContainerView.addSubview(serviceInstsView)
            serviceInstsView.loadData(models)
        }
    }

    func loadData() {
        timelineModels.removeAll()
        for i in 0...3 {
            timelineModels.append(AITimelineViewModel.createFakeData("\(i)"))
        }
        timelineModels.append(AITimelineViewModel.createFakeDataOrderComplete("\(4)"))
        timelineModels = handleViewModels(timelineModels)
    }
    
    //TODO: 过滤时间线
    func filterTimeline() {
        
    }

    // MARK: -> Protocol <#protocol name#>

}

extension AICustomerServiceExecuteViewController : OrderAndBuyerInfoViewDelegate, VerticalScrollViewDelegate {

    func viewCellDidSelect(verticalScrollView: AIVerticalScrollView, index: Int, cellView: UIView) {

    }
}

extension AICustomerServiceExecuteViewController : UITableViewDelegate, UITableViewDataSource, AITimelineTableViewCellDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timelineModels.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let timeLineItem = timelineModels[indexPath.row]
        if timeLineItem.layoutType == AITimelineLayoutTypeEnum.Now {
            let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITimelineNowTableViewCell, forIndexPath: indexPath) as! AITimelineNowTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITimelineTableViewCell, forIndexPath: indexPath) as! AITimelineTableViewCell
            
            cell.delegate = self
            cell.loadData(timeLineItem)
            return cell
        }
        
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let timeLineItem = timelineModels[indexPath.row]
        if timeLineItem.cellHeight != 0 {
            return timeLineItem.cellHeight
        }
        return AITimelineTableViewCell.caculateHeightWidthData(timeLineItem)
    }
    
    func cellImageDidLoad(viewModel viewModel: AITimelineViewModel, cellHeight: CGFloat) {
        let indexPath = NSIndexPath(forRow: Int(viewModel.itemId!)!, inSection: 0)
        //AILog("\(viewModel.itemId!) : \(indexPath.row)")
        //如果cell在visible状态，才reload，否则不reload
        if let visibleIndexPathArray = timelineTableView.indexPathsForVisibleRows?.filter({ (visibleIndexPath) -> Bool in
            return visibleIndexPath.row == indexPath.row
        }) {
            if !visibleIndexPathArray.isEmpty {
                self.timelineTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            }
        }
    }
    
    func cellConfirmButtonDidClick(viewModel viewModel: AITimelineViewModel) {
        
        let vc = parentViewController
        self.dismissPopupViewController(true) { [weak vc] in
            //打开评论页面
            if viewModel.layoutType == AITimelineLayoutTypeEnum.ConfirmServiceComplete {
                let commentVC = ServiceCommentViewController.loadFromXib()
                commentVC.view.frame = self.view.bounds
                vc?.presentPopupViewController(commentVC, animated: true)
            }
            //打开支付页面
            else if viewModel.layoutType == AITimelineLayoutTypeEnum.ConfirmOrderComplete {
                let popupVC = AIPaymentViewController.initFromNib()
                popupVC.view.frame = self.view.bounds
                vc?.presentPopupViewController(popupVC, animated: true)
            }
        }
        
    }
    
    /**
     <#Description#>
     
     - parameter timelineModels: <#timelineModels description#>
     
     - returns: <#return value description#>
     */
    func handleViewModels(timelineModels: [AITimelineViewModel]) -> [AITimelineViewModel] {
        //insertNowCellToModel
        var newTimelineModels = timelineModels
        let nowTime = NSDate()
        let datetimeFormat = NSDateFormatter()
        var lastDate: NSDate!
        var isNowHandled = false
        datetimeFormat.dateFormat = "MM-dd HH:mm"
        for (index, timelineModel) in timelineModels.enumerate() {
            let timelineDateString = "\(timelineModel.timeModel!.date!) \(timelineModel.timeModel!.time!)"
            if let timelineDate = datetimeFormat.dateFromString(timelineDateString) {
                //处理now
                if nowTime.compare(timelineDate) == NSComparisonResult.OrderedAscending && !isNowHandled {
                    let nowTimelineViewModel = AITimelineViewModel()
                    nowTimelineViewModel.layoutType = AITimelineLayoutTypeEnum.Now
                    nowTimelineViewModel.cellHeight = 44
                    newTimelineModels.insert(nowTimelineViewModel, atIndex: index)
                    isNowHandled = true
                }
                //处理是否显示月日
                if index == 0 {
                    timelineModel.timeModel?.shouldShowDate = true
                } else {
                    if compareOneDate(timelineDate, anotherDate: lastDate) != NSComparisonResult.OrderedSame {
                        timelineModel.timeModel?.shouldShowDate = true
                    }
                }
                lastDate = timelineDate
            }
        }
        //如果循环到最后都没有，则加在最后
        if !isNowHandled {
            let nowTimelineViewModel = AITimelineViewModel()
            nowTimelineViewModel.layoutType = AITimelineLayoutTypeEnum.Now
            nowTimelineViewModel.cellHeight = 44
            newTimelineModels.append(nowTimelineViewModel)
        }
        
        return newTimelineModels
    }
    
    /**
     按天来比较日期
     
     - parameter oneDate:     <#oneDate description#>
     - parameter anotherDate: <#anotherDate description#>
     
     - returns: <#return value description#>
     */
    func compareOneDate(oneDate: NSDate, anotherDate: NSDate) -> NSComparisonResult {
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "MM-dd"
        let oneFormatDate = dateFormat.dateFromString(dateFormat.stringFromDate(oneDate))
        let anotherFormatDate = dateFormat.dateFromString(dateFormat.stringFromDate(anotherDate))
        return (oneFormatDate?.compare(anotherFormatDate!))!
    }
}
