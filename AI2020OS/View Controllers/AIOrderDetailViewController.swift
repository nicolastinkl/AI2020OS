//
//  AIOrderDetailViewController.swift
//  AI2020OS
//
//  Created by 郑鸿翔 on 15/5/25.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit


struct OrderDetail {
    var title = ""
    var content = ""
}

struct OrderTitle {
    var title = ""
    var content = ""
}

let titleColon = ":";

var titles = [OrderTitle]()
var details = [OrderDetail]()

class AIOrderDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // 订单详情参数tableView
    @IBOutlet weak var tableView: UITableView!

    func initTableView() {
        // 绑定代理
        self.tableView.delegate = self
        // 绑定数据源
        self.tableView.dataSource = self
    }
    
    // 初始化headerView的所有数据
    func initHeaderView() {
        let orderNoTitle = self.tableView.tableHeaderView?.viewWithTag(100) as UILabel
        let orderNo = self.tableView.tableHeaderView?.viewWithTag(101) as UILabel
        let orderStateTitle = self.tableView.tableHeaderView?.viewWithTag(102) as UILabel
        let orderState = self.tableView.tableHeaderView?.viewWithTag(103) as UILabel
        
        orderNoTitle.text = "订单号" + titleColon
        orderNo.text = "2012312312312321"
        orderStateTitle.text = "订单状态" + titleColon
        orderState.text = "已支付"
    }
    
    // 初始化footerView的所有数据
    func initFooterView(){
        let serviceName = self.tableView.tableFooterView?.viewWithTag(100) as UILabel
        let servicePrice = self.tableView.tableFooterView?.viewWithTag(101) as UILabel
        let servicePic = self.tableView.tableFooterView?.viewWithTag(103) as UIImageView
        let collect = self.tableView.tableFooterView?.viewWithTag(102) as UIButton
        serviceName.text = "小丽上门保洁";
        servicePrice.text = "120元/次 起"
        servicePic.image = UIImage(named: "Sample1")
    }
    
    func loadOrderDetailData() {
        details.removeAll(keepCapacity: true);
        let detail1 = OrderDetail(title: "服务名" + titleColon, content: "小丽上门保洁")
        details.append(detail1)
        let detail2 = OrderDetail(title: "服务商" + titleColon, content: "小丽家政")
        details.append(detail2)
        let detail3 = OrderDetail(title: "服务时间" + titleColon, content: "2015-04-07 14:00")
        details.append(detail3)
        let detail4 = OrderDetail(title: "上门地址" + titleColon, content: "安河桥北龙背村路220号")
        details.append(detail4)
        self.tableView.reloadData()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.interactivePopGestureRecognizer.delegate = nil
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initTableView()
        initHeaderView()
        initFooterView()
        
        loadOrderDetailData()

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
        return details.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("orderDetail") as DetailTableViewCell

        let orderDetail = details[indexPath.row] as OrderDetail
        // 标题
        if let titleLabel = cell.viewWithTag(100) as? UILabel {
            titleLabel.text = orderDetail.title
        }
        if let contentLabel = cell.viewWithTag(101) as? UILabel {
            contentLabel.text = orderDetail.content
        }
        return cell
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



