//
//  AICustomerOrderListViewController.swift
//  AI2020OS
//
//  Created by 刘先 on 15/8/13.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AICustomerOrderListViewController: AIBaseOrderListViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: variables
    private var storeHouseRefreshControl:CBStoreHouseRefreshControl?
    
    // MARK: life cycle
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer.delegate = nil
        super.viewWillAppear(animated)
            }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        self.scrollView.contentSize = CGSizeMake(450, 0)
        
        //registerNib        
        tableView.registerNib(UINib(nibName:"CustomerOrderTableViewCell",bundle:NSBundle.mainBundle()), forCellReuseIdentifier: "CustomerOrderCell")
        
        // request networking.
        retryNetworkingAction()
        
        //refresh control
        storeHouseRefreshControl = CBStoreHouseRefreshControl.attachToScrollView(self.tableView, target: self, refreshAction: "requestOrderList", plist: "storehouse", color: UIColor(hex: AIApplication.AIColor.MainSystemBlueColor), lineWidth: 2, dropHeight: 80, scale: 1, horizontalRandomness: 150, reverseLoadingAnimation: false, internalAnimationFactor: 0.7)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentOffset = CGPointMake(0, 0)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    // MARK: - utils
    func retryNetworkingAction(){
        requestOrderNumber()
        requestOrderList()
    }
    
    //不同状态的订单动态创建按钮
    //orderType:买家订单 卖家订单
    //orderState: 待处理 进行中 待完成 已完成
    func buildDynaOperButton(orderState : Int,orderType : String,buttonView:UIView,indexNumber : Int){
        if let stateEnum = OrderStatus(rawValue: orderState) {
            
            switch stateEnum {
            case .WaitForPay:
                addOperButton([ButtonModel(title: "付款",action:"payOrder:")], buttonView: buttonView,indexNumber : indexNumber)
            case .Executing:
                addOperButton([ButtonModel(title: "完成",action:"finishOrder:")], buttonView: buttonView,indexNumber : indexNumber)
            case .Finished:
                addOperButton([ButtonModel(title: "评价",action:"commentsOrder:"),ButtonModel(title: "分享",action:"shareOrder:")], buttonView: buttonView,indexNumber : indexNumber)
            case .WaitForExe:
                addOperButton([ButtonModel(title: "申请变更",action:"commentsOrder:")], buttonView: buttonView,indexNumber : indexNumber)
            case .Commented:
                addOperButton([ButtonModel(title: "分享",action:"shareOrder:")], buttonView: buttonView,indexNumber : indexNumber)
            default :
                addOperButton([ButtonModel(title: "评价",action:"commentsOrder:"),ButtonModel(title: "处理",action:"excuteOrder:")], buttonView: buttonView,indexNumber : indexNumber)
                return
                
            }
        }
    }
    
    func buildDynaStatusButton(orderNumberList : [OrderNumberModel]){
        
        var orderNumberDictinary = Dictionary<Int,Int>()
        var totalNumber : Int = 0
        //buildOrderNumberData
        for orderNumberModel in orderNumberList{
            orderNumberDictinary[orderNumberModel.order_state] = orderNumberModel.order_num
            totalNumber += orderNumberModel.order_num
        }
        
        func getAmountByStatus(status : Int) -> Int{
            if let orderNumber = orderNumberDictinary[status] {
                return orderNumber
            }
            return 0
        }
        
        let buttonArray = [StatusButtonModel(title: "全部", amount: totalNumber,status:0),
            StatusButtonModel(title: "待付款", amount: getAmountByStatus(OrderStatus.WaitForPay.rawValue),status:OrderStatus.WaitForPay.rawValue),
            StatusButtonModel(title: "待执行", amount: getAmountByStatus(OrderStatus.WaitForExe.rawValue),status:OrderStatus.WaitForExe.rawValue),
            StatusButtonModel(title: "执行中", amount: getAmountByStatus(OrderStatus.Executing.rawValue),status:OrderStatus.Executing.rawValue),
            StatusButtonModel(title: "已完成", amount: getAmountByStatus(OrderStatus.Finished.rawValue),status:OrderStatus.Finished.rawValue),
            StatusButtonModel(title: "已评价", amount: getAmountByStatus(OrderStatus.Commented.rawValue),status:OrderStatus.Commented.rawValue)
            ]
        addStatusButton(buttonArray, scrollView: scrollView)
    }
    
    override func filterOrderAction(target:UIButton){
        super.filterOrderAction(target)
        //refresh data
        self.orderStatus = target.associatedName?.toInt() ?? 0

        requestOrderList()
    }
    
    func requestOrderNumber(){
        scrollView.hideProgressViewLoading()
        scrollView.showProgressViewLoading()
        //后台请求数据
        Async.background(){
            // Do any additional setup after loading the view, typically from a nib.
            AIOrderRequester().queryOrderNumber(1, orderStatus: self.orderStatus, completion: {
                (data,error) ->() in
                // Init buttons.
                self.buildDynaStatusButton(data)
                self.scrollView.hideProgressViewLoading()
            })
        }
    }
    
    func requestOrderList(){
        tableView.hideProgressViewLoading()
        tableView.showProgressViewLoading()
        //后台请求数据
        Async.background(){
            // Do any additional setup after loading the view, typically from a nib.
            AIOrderRequester().queryOrderList(page: 1, orderRole: 1, orderState: self.orderStatus, completion: { (data) -> () in
                self.storeHouseRefreshControl?.finishingLoading()
                self.orderList = data
                self.tableView.reloadData()
                self.tableView.hideErrorView()
                self.tableView.hideProgressViewLoading()
            })
        }

    }
}

//MARK: - extension UITableView
extension AICustomerOrderListViewController:UITableViewDelegate,UITableViewDataSource{
    
    //实现tableViewDelegate的方法
        func numberOfSectionsInTableView(tableView: UITableView) -> Int{
            return 1
        }
    
    //实现tableViewDataSource的方法
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderList.count
    }
    
    //实现tableViewDataSource的方法
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomerOrderCell", forIndexPath: indexPath) as CustomerOrderTableViewCell //1
        
        let orderListModel = orderList[indexPath.row] as AIOrderListItemModel //2
        
        if let createDateLabel = cell.viewWithTag(110) as? UILabel { //3
            createDateLabel.text = orderListModel.order_create_time == "" ? "12:37" : orderListModel.order_create_time
        }
        if let orderNameLabel = cell.viewWithTag(120) as? UILabel {
            orderNameLabel.text = orderListModel.service_name
        }
        if let serviceDateLabel = cell.viewWithTag(130) as? UILabel {
            var service_time_duration = orderListModel.service_time_duration ?? "8月1日－8月20日"
            
            serviceDateLabel.text = service_time_duration.imestampStringToDateString()
        }
        if let orderPriceLabel = cell.viewWithTag(150) as? UILabel {
            orderPriceLabel.text = (orderListModel.order_price == "" ? "100" : orderListModel.order_price)
        }
        if let orderStateLabel = cell.viewWithTag(170) as? UILabel {
            orderStateLabel.text = orderListModel.order_state_name
        }
        if let buttonView = cell.viewWithTag(180) {
            buildDynaOperButton(orderListModel.order_state ?? 0, orderType: "", buttonView: buttonView,indexNumber : indexPath.row)
        }
        if let customerIconImg = cell.viewWithTag(140) as? AIImageView{
            customerIconImg.setURL(NSURL(string: orderListModel.provider_portrait_url ?? "http://img1.gtimg.com/kid/pics/hv1/47/231/1905/123931577.jpg"), placeholderImage: UIImage(named: "Placeholder"))
        }
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AIOrderStoryboard, bundle: nil).instantiateViewControllerWithIdentifier("AICustomerOrderDetailViewController") as AICustomerOrderDetailViewController
//        self.navigationController?.pushViewController(viewController, animated: true)
        viewController.orderId = findOrderNumberByIndexNumber(indexPath.row)
        viewController.serviceId = findOServiceIdByIndexNumber(indexPath.row)
        showViewController(viewController, sender: self)
    }
    
    //MARK:ScrollDelegate pragma mark - Notifying refresh control of scrolling
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.storeHouseRefreshControl?.scrollViewDidScroll()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.storeHouseRefreshControl?.scrollViewDidEndDragging()
    }
    
}
