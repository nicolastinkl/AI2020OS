//
//  AIOrderDetailViewController.swift
//  AI2020OS
//
//  Created by 郑鸿翔 on 15/5/25.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIOrderDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: storyboard elements
    // 订单详情参数tableView
    @IBOutlet weak var tableView: UITableView!


    // MARK: variables
    let titleColon = ":";
    // 订单详情数据模型
    var orderDetail : OrderDetailModel = OrderDetailModel()
    
    // 初始化headerView的所有数据
    func initHeaderView() {
        let orderNoTitle = self.tableView.tableHeaderView?.viewWithTag(100) as UILabel
        
        let orderStateTitle = self.tableView.tableHeaderView?.viewWithTag(102) as UILabel
        
        orderNoTitle.text = "订单号" + titleColon
//        orderNo.text = String(orderDetail.orderNum!)
        orderStateTitle.text = "订单状态" + titleColon
//        orderState.text = getOrderStateName(orderDetail.orderState!)
    }
    
    // 初始化footerView的所有数据
    func initFooterView(){
        
        
        let servicePic = self.tableView.tableFooterView?.viewWithTag(103) as UIImageView
        let collect = self.tableView.tableFooterView?.viewWithTag(102) as UIButton
        
        servicePic.image = UIImage(named: "Sample1")
    }
    
    func retryNetworkingAction(){
//        self.view.hideProgressViewLoading()
//        self.view.showProgressViewLoading()
        //后台请求数据
        Async.background(){
            // Do any additional setup after loading the view, typically from a nib.
            AIOrderDetailRequester().queryOrderDetail({ (data,error) -> () in
                self.view.hideProgressViewLoading()
                
                if error != nil{
                    self.view.showErrorView()
                }else{
                    self.orderDetail = data
                    
                    let orderNo = self.tableView.tableHeaderView?.viewWithTag(101) as UILabel
                    let orderState = self.tableView.tableHeaderView?.viewWithTag(103) as UILabel
                    
                    let servicePrice = self.tableView.tableFooterView?.viewWithTag(101) as UILabel
                    let serviceName = self.tableView.tableFooterView?.viewWithTag(100) as UILabel
                    
                    orderNo.text = String(data.orderNum!)
                    orderState.text = self.getOrderStateName(data.orderState!)
                    
                    serviceName.text = data.serviceName
                    servicePrice.text = data.servicePrice
                    
                    self.tableView.reloadData()
                    self.view.hideErrorView()
                }
            })
        }
    }

    
    // MARK:life cycle
    override func viewWillAppear(animated: Bool) {
        navigationController?.interactivePopGestureRecognizer.delegate = nil
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 绑定代理
        self.tableView.delegate = self
        // 绑定数据源
        self.tableView.dataSource = self
        
        initHeaderView()
        initFooterView()
        
        retryNetworkingAction()
        
//        loadOrderDetailData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    // 返回分区个数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    // 返回行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        // 注意界面加载起来的时候可能为空
        return orderDetail.params == nil ? 0 : orderDetail.params!.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("orderDetail") as DetailTableViewCell

        let param = orderDetail.params![indexPath.row] as ServiceParam
        // 标题
        if let titleLabel = cell.viewWithTag(100) as? UILabel {
            println(param.paramName)
            titleLabel.text = param.paramName
        }
        if let contentLabel = cell.viewWithTag(101) as? UILabel {
            contentLabel.text = param.paramValue
        }
        return cell
    }
    
    func getOrderStateName (orderState: Int) -> String {
        switch orderState {
        case 0:
            return "已下单"
        case 1:
            return "已支付"
        case 2:
            return "已完成"
        default:
            return "已下单"
        }
    
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

class DetailTableViewCell: UITableViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var detailLabel: UILabel!
}



