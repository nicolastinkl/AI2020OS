//
//  AICustomerServiceExecuteViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/6/16.
//  Base on Aerolitec Template
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import AIAlertView

// MARK: -
// MARK: AICustomerServiceExecuteViewController
// MARK: -
internal class AICustomerServiceExecuteViewController: UIViewController {
    

    // MARK: -
    // MARK: Public access
    // MARK: -

    // MARK: -> Public properties

    var serviceInstsView: AIVerticalScrollView!
    var orderInfoContentView: AITimelineTopView?
    var orderInfoModel: AICustomerOrderDetailTopViewModel?
    var timelineModels: [AITimelineViewModel] = []
    //订单信息是否已加载标志
    var orderInfoIsLoad = false
    var cellHeightArray: Array<CGFloat>!
    
    let messageBadge = GIBadgeView()
    let noticeBadge = GIBadgeView()

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
        //self.dismissViewControllerAnimated(true, completion: nil)
        self.dismissPopupViewController(true, completion: nil)
    }


    // MARK: -> Class override UIViewController

    override internal func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupViews()
        loadData()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        AIMapView.sharedInstance.releaseView()
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if serviceInstsView == nil && orderInfoModel != nil && orderInfoModel?.serviceInsts?.count > 0 {
            buildServiceInstsView()
        }
    }

    // MARK: -> Public methods

    func setupViews() {
        //selfview CornerRadius
        view.setCorner(corners: [.TopLeft, .TopRight], cornerRadii: CGSize(width: 10, height: 10))
        //orderInfoView
        orderInfoContentView = AITimelineTopView.createInstance()
        orderInfoView.addSubview(orderInfoContentView!)
        //orderInfoContentView?.delegate = self

        orderInfoContentView?.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(orderInfoView)
        }

        //timeLine tableView
        timelineTableView.registerNib(UINib(nibName: AIApplication.MainStoryboard.CellIdentifiers.AITimelineTableViewCell, bundle: nil), forCellReuseIdentifier: AIApplication.MainStoryboard.CellIdentifiers.AITimelineTableViewCell)
        timelineTableView.registerNib(UINib(nibName: AIApplication.MainStoryboard.CellIdentifiers.AITimelineNowTableViewCell, bundle: nil), forCellReuseIdentifier: AIApplication.MainStoryboard.CellIdentifiers.AITimelineNowTableViewCell)
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
//        timelineTableView.estimatedRowHeight = 110
//        timelineTableView.rowHeight = UITableViewAutomaticDimension
        //下拉刷新方法
        weak var weakSelf = self
        timelineTableView.addHeaderWithCallback { 
            () -> Void in
            weakSelf?.loadData()
        }
        timelineTableView.addHeaderRefreshEndCallback { 
            () -> Void in
            weakSelf?.timelineTableView.reloadData()
        }
        //TODO: 测试方式
        //timelineTableView.rowHeight = UITableViewAutomaticDimension
        
        //增加通知图标
        buttonMessage.addSubview(messageBadge)
        messageBadge.badgeValue = 1
        messageBadge.topOffset = 5
        messageBadge.rightOffset = 5
        messageBadge.font = AITools.myriadLightSemiExtendedWithSize(12)
        
        buttonNeedReply.addSubview(noticeBadge)
        noticeBadge.badgeValue = 2
        noticeBadge.topOffset = 5
        noticeBadge.rightOffset = 5
        noticeBadge.font = AITools.myriadLightSemiExtendedWithSize(12)

    }

    func buildServiceInstsView() {
        
        if let models = orderInfoModel?.serviceInsts {

            let frame = serviceIconContainerView.bounds
            serviceInstsView = AIVerticalScrollView(frame: frame, needCheckAll : false)
            serviceInstsView.userInteractionEnabled = true
            serviceInstsView.myDelegate = self
            serviceInstsView.showsVerticalScrollIndicator = false
            serviceIconContainerView.addSubview(serviceInstsView)
            serviceInstsView.loadData(models)
        }
    }

    func loadDataFake() {
        //订单信息数据fake
        orderInfoModel = AICustomerOrderDetailTopViewModel()
        orderInfoModel?.serviceIcon = "http://171.221.254.231:3000/upload/shoppingcart/Hm7ulONUnenmN.png"
        orderInfoModel?.serviceName = "孕检无忧"
        orderInfoModel?.completion = 0.75
        orderInfoModel?.price = "¥ 1428"
        orderInfoModel?.serviceIcon = "http://171.221.254.231:3000/upload/proposal/NKfG9YRqfEZq3.png"
        orderInfoModel?.serviceDesc = "孕检无负担，轻松愉快。"
        orderInfoModel?.unReadMessageNumber = 1
        orderInfoModel?.unConfirmMessageNumber = 3
        orderInfoContentView?.model = orderInfoModel
        
        orderInfoModel?.serviceInsts = [IconServiceIntModel(serviceInstId: 1, serviceIcon: "http://171.221.254.231:3000/upload/proposal/NKfG9YRqfEZq3.png", serviceInstStatus: ServiceInstStatus.Assigned, executeProgress: 1), IconServiceIntModel(serviceInstId: 1, serviceIcon: "http://171.221.254.231:3000/upload/proposal/NKfG9YRqfEZq3.png", serviceInstStatus: ServiceInstStatus.Assigned, executeProgress: 1), IconServiceIntModel(serviceInstId: 1, serviceIcon: "http://171.221.254.231:3000/upload/proposal/NKfG9YRqfEZq3.png", serviceInstStatus: ServiceInstStatus.Assigned, executeProgress: 1)]
        //未读消息赋值
        messageBadge.badgeValue = orderInfoModel!.unReadMessageNumber!
        noticeBadge.badgeValue = orderInfoModel!.unConfirmMessageNumber!
        
        timelineModels.removeAll()
        for i in 0...3 {
            timelineModels.append(AITimelineViewModel.createFakeData("\(i)"))
        }
        timelineModels.append(AITimelineViewModel.createFakeDataLocation("4"))
        timelineModels.append(AITimelineViewModel.createFakeDataOrderComplete("5"))
        timelineModels.append(AITimelineViewModel.createFakeDataAuthoration("6"))
        timelineModels = handleViewModels(timelineModels)
        //结束下拉刷新
        timelineTableView.headerEndRefreshing()
        timelineTableView.reloadData()
    }
    
    func loadData() {
        let interfaceHandler = AICustomerServiceExecuteHandler.sharedInstance
        let compServiceInstId = "111"
        let orderId = "1111"
        
        
        //刷新订单信息和消息数据
        weak var weakSelf = self
        interfaceHandler.queryCustomerServiceExecute(compServiceInstId, success: { (viewModel) in
            weakSelf?.orderInfoContentView?.model = viewModel
            weakSelf?.messageBadge.badgeValue = viewModel.unReadMessageNumber!
            weakSelf?.noticeBadge.badgeValue = viewModel.unConfirmMessageNumber!
            //刷新时间线表格
            var serviceInstIds = Array<String>()
            for serviceInst in viewModel.serviceInsts! {
                serviceInstIds.append("\(serviceInst.serviceInstId)")
            }
            interfaceHandler.queryCustomerTimelineList(orderId, serviceInstIds: serviceInstIds, filterType: 1, success: { (viewModel) in
                weakSelf?.timelineTableView.headerEndRefreshing()
                weakSelf?.timelineModels.removeAll()
                weakSelf?.timelineModels = viewModel
                weakSelf?.timelineTableView.reloadData()
            }) { (errType, errDes) in
                weakSelf?.timelineTableView.headerEndRefreshing()
                AIAlertView().showError("刷新失败", subTitle: errDes)
            }
        }) { (errType, errDes) in
            weakSelf?.timelineTableView.headerEndRefreshing()
            AIAlertView().showError("刷新失败", subTitle: errDes)
        }
    }
    
    //TODO: 过滤时间线
    func filterTimeline() {
        
    }

    // MARK: -> util methods
    //计算view高度，如果还没有loadData则返回0
    func getHeight(viewModel: AITimelineViewModel, containerHeight: CGFloat) -> CGFloat {
        var totalHeight: CGFloat = 0
        switch viewModel.layoutType! {
        case AITimelineLayoutTypeEnum.Normal:
            totalHeight = AITimelineTableViewCell.baseTimelineContentLabelHeight + AITimelineTableViewCell.cellMargin + containerHeight
        case .Authoration, .ConfirmOrderComplete, .ConfirmServiceComplete:
            totalHeight = AITimelineTableViewCell.baseTimelineContentLabelHeight + AITimelineTableViewCell.cellMargin + AITimelineTableViewCell.subViewMargin + containerHeight
        default: break
        }
        if viewModel.timeModel?.shouldShowDate == true {
            totalHeight += 60.displaySizeFrom1242DesignSize()
        }
        //在这里给cellHeight赋值
        viewModel.cellHeight = totalHeight
        AILog("totalHeight : \(totalHeight)")
        return totalHeight
    }

}

extension AICustomerServiceExecuteViewController : OrderAndBuyerInfoViewDelegate, VerticalScrollViewDelegate {

    func viewCellDidSelect(verticalScrollView: AIVerticalScrollView, index: Int, cellView: UIView) {

    }
}

// MARK: -> delegates
extension AICustomerServiceExecuteViewController : UITableViewDelegate, UITableViewDataSource, AITimelineContentContainerViewDelegate {

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
            cell.loadData(timeLineItem, delegate: self)
            return cell
        }
        
    }
    
//    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        let timeLineItem = timelineModels[indexPath.row]
//        if timeLineItem.cellHeight != 0 {
//            return timeLineItem.cellHeight
//        }
//        return AITimelineTableViewCell.caculateHeightWidthData(timeLineItem)
//
//    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let timeLineItem = timelineModels[indexPath.row]
        if timeLineItem.cellHeight != 0 {
            return timeLineItem.cellHeight
        }
        return AITimelineTableViewCell.caculateHeightWidthData(timeLineItem)
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let timeLineItem = timelineModels[indexPath.row]
        if timeLineItem.layoutType != AITimelineLayoutTypeEnum.Now {
            if let timelineCell = cell as? AITimelineTableViewCell {
                if let mapView = timelineCell.viewWithTag(AIMapView.viewTag) as? BMKMapView {
                    mapView.viewWillDisappear()
                    mapView.delegate = nil
                }
            }
        }
    }
    
    func confirmServiceButtonDidClick(viewModel viewModel: AITimelineViewModel) {
        let vc = parentViewController
        self.dismissPopupViewController(true) { [weak vc] in
            let commentVC = ServiceCommentViewController.loadFromXib()
            commentVC.view.frame = self.view.bounds
            vc?.showTransitionStyleCrossDissolveView(commentVC)
//            vc?.presentPopupViewController(commentVC, animated: true)
        }
    }
    func confirmOrderButtonDidClick(viewModel viewModel: AITimelineViewModel) {
        let vc = parentViewController
        self.dismissPopupViewController(true) { [weak vc] in
            //打开支付页面
            let popupVC = AIPaymentViewController.initFromNib()
            popupVC.view.frame = self.view.bounds
            vc?.showTransitionStyleCrossDissolveView(popupVC)
//            vc?.presentPopupViewController(popupVC, animated: true)
        }
    }
    func refuseButtonDidClick(viewModel viewModel: AITimelineViewModel) {
        AIAlertView().showInfo("忽略授权请求!", subTitle: "")
    }
    func acceptButtonDidClick(viewModel viewModel: AITimelineViewModel) {
        AIAlertView().showInfo("同意授权请求!", subTitle: "")
    }

    func containerImageDidLoad(viewModel viewModel: AITimelineViewModel, containterHeight: CGFloat) {
        
        getHeight(viewModel, containerHeight: containterHeight)
        let indexPath = NSIndexPath(forRow: Int(viewModel.itemId!)!, inSection: 0)
        //AILog("\(viewModel.itemId!) : \(indexPath.row)")
        //如果cell在visible状态，才reload，否则不reload
        if let visibleIndexPathArray = timelineTableView.indexPathsForVisibleRows?.filter({ (visibleIndexPath) -> Bool in
            return visibleIndexPath.row == indexPath.row
        }) {
            if !visibleIndexPathArray.isEmpty {
                //测试通过自动高度计算
//                if let cell = timelineTableView.cellForRowAtIndexPath(indexPath) as? AITimelineTableViewCell {
//                    cell.layoutIfNeeded()
//                    viewModel.cellHeight = cell.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
//                    
//                }
                self.timelineTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
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
