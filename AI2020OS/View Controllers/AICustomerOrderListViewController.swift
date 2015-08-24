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
    
    private var orderList = Array<AIOrderListItemModel>()
    
    // MARK: life cycle
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer.delegate = nil
        super.viewWillAppear(animated)
        scrollView.contentOffset = CGPointMake(0, 0)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init buttons.
        buildDynaStatusButton()
        self.scrollView.contentSize = CGSizeMake(450, 0)
        
        // request networking.
        retryNetworkingAction()
        
        //registerNib        
        tableView.registerNib(UINib(nibName:"CustomerOrderTableViewCell",bundle:NSBundle.mainBundle()), forCellReuseIdentifier: "CustomerOrderCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("segue:\(segue.identifier)")
    }
    
    // MARK: - utils
    func retryNetworkingAction(){
        self.view.hideProgressViewLoading()
        self.view.showProgressViewLoading()
        //后台请求数据
        Async.background(){
            // Do any additional setup after loading the view, typically from a nib.
            AIOrderRequester().queryOrderList(page: 1, completion: { (data) -> () in
                self.view.hideProgressViewLoading()
                if data.count > 0{
                    self.orderList = data
                    self.tableView.reloadData()
                    self.view.hideErrorView()
                }else{
                    self.view.showErrorView()
                }
            })
        }
    }
    
    
    
    //不同状态的订单动态创建按钮
    //orderType:买家订单 卖家订单
    //orderState: 待处理 进行中 待完成 已完成
    func buildDynaOperButton(orderState : String,orderType : String,buttonView:UIView){
        switch orderState{
        case "11":
            addOperButton([ButtonModel(title: "评价",action:"commentsOrder:"),ButtonModel(title: "处理",action:"excuteOrder:")], buttonView: buttonView)
        case "已完成":
            addOperButton([ButtonModel(title: "评价",action:"commentsOrder:")], buttonView: buttonView)
        default :
            addOperButton([ButtonModel(title: "评价",action:"commentsOrder:"),ButtonModel(title: "处理",action:"excuteOrder:")], buttonView: buttonView)
            return
            
        }
    }
    
    
    
    func buildDynaStatusButton(){
        let buttonArray = [StatusButtonModel(title: "全部", amount: 7),StatusButtonModel(title: "待执行", amount: 4),StatusButtonModel(title: "待付款", amount: 0),StatusButtonModel(title: "待评价", amount: 3)]
        addStatusButton(buttonArray, scrollView: scrollView)
    }
    
    
}

//MARK: - extension UITableView
extension AICustomerOrderListViewController:UITableViewDelegate,UITableViewDataSource{
    
    //实现tableViewDelegate的方法
    //    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
    //        return 1
    //    }
    
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
            serviceDateLabel.text = orderListModel.service_time_duration == "" ? "8月1日－8月20日" : orderListModel.service_time_duration
        }
        if let orderPriceLabel = cell.viewWithTag(150) as? UILabel {
            orderPriceLabel.text = (orderListModel.order_price == "" ? "100" : orderListModel.order_price)
        }
        if let orderStateLabel = cell.viewWithTag(170) as? UILabel {
            orderStateLabel.text = orderListModel.order_state_name
        }
        if let buttonView = cell.viewWithTag(180) {
            buildDynaOperButton(orderListModel.order_state_name!, orderType: "", buttonView: buttonView)
        }
        if let customerIconImg = cell.viewWithTag(140) as? AIImageView{
            customerIconImg.setURL(NSURL(string: orderListModel.provider_portrait_url! ?? ""), placeholderImage: UIImage(named: "Placeholder"))
        }
        cell.clipsToBounds = true
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //AIOrderDetailStoryboard
        //        println("执行跳转逻辑")
        let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AIOrderStoryboard, bundle: nil).instantiateViewControllerWithIdentifier("AICustomerOrderDetailViewController") as UIViewController
        //setup next page back button ,but it didn't work
        

        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
