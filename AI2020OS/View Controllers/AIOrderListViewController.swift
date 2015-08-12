//
//  OrderListViewController.swift
//  AI2020OS
//
//  Created by 刘先 on 15/5/26.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit
import Cartography


class AIOrderListViewController:UIViewController{

    // MARK: - IBOutlets

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var tableView: UITableView!
    

    // MARK: variables

    private var orderList = Array<AIOrderListItemModel>()
    
    // MARK: life cycle
    override func viewWillAppear(animated: Bool) {
//        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer.delegate = nil
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSizeMake(650, 40)
 
        retryNetworkingAction()
        buildDynaStatusButton()
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
            case "待处理":
                addOperButton([ButtonModel(title: "派单"),ButtonModel(title: "处理")], buttonView: buttonView)
            case "已完成":
                addOperButton([ButtonModel(title: "评价")], buttonView: buttonView)
            default :
                return
            
        }
    }

    func addOperButton(buttonArray:[ButtonModel],buttonView:UIView){
        buttonView.subviews.filter{
            let value:UIButton = $0 as UIButton
            value.removeFromSuperview()
            return true
        }
        
        var x:CGFloat = 0
        for buttonModel in buttonArray{
            var button = UIButton(frame: CGRectMake(x, 0, 40, 20))
            button.setTitle(buttonModel.title, forState: UIControlState.Normal)
            //扩展的直接读取rgba颜色的方法
            button.setTitleColor(UIColor(rgba: "#30D7CE"), forState: UIControlState.Normal)
            button.backgroundColor = UIColor.clearColor()
            button.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
            buttonView.addSubview(button)
            x = x + 40
            
            
        }
    }
    
    func buildDynaStatusButton(){
        let buttonArray = [StatusButtonModel(title: "全部", amount: 9),StatusButtonModel(title: "待处理", amount: 1),StatusButtonModel(title: "待付款", amount: 0),StatusButtonModel(title: "待完成", amount: 2),StatusButtonModel(title: "待评价", amount: 3)]
        addStatusButton(buttonArray, scrollView: scrollView)
    }
    
    func addStatusButton(buttonArray:[StatusButtonModel],scrollView:UIScrollView){
        scrollView.subviews.filter{
            let value:UIView = $0 as UIView
            value.removeFromSuperview()
            return true
        }
        let statusButtonWidth:CGFloat = 60
        let buttonPadding:CGFloat = 2
        let statusLabelWidth:CGFloat = 10
        
        var x1:CGFloat = 0
        var x2:CGFloat = statusButtonWidth
        
        for buttonModel in buttonArray{
            var button = UIButton(frame: CGRectMake(x1, 0, statusButtonWidth, 33))
            
            button.setTitle(buttonModel.title, forState: UIControlState.Normal)
            //扩展的直接读取rgba颜色的方法
            button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            button.setTitleColor(UIColor(rgba: "#30D7CE"), forState: UIControlState.Selected)
            button.backgroundColor = UIColor.clearColor()
            button.titleLabel?.font = UIFont.systemFontOfSize(17)
            
            //add click event
            button.addTarget(self, action: "filterOrderAction:", forControlEvents: UIControlEvents.TouchUpInside)
            scrollView.addSubview(button)
            x1 = x1 + statusButtonWidth + statusButtonWidth + buttonPadding
            
            var label = UILabel(frame: CGRectMake(x2, 0, statusLabelWidth, 33))
            label.font = UIFont.systemFontOfSize(17)
            label.textColor = UIColor(rgba: "#30D7CE")
            label.text = "\(buttonModel.amount)"
            scrollView.addSubview(label)
            x2 = x1 + statusButtonWidth
            
        }
    }
    
    func filterOrderAction(target:UIButton){
        scrollView.subviews.filter{
            if let value:UIButton = $0 as? UIButton {
                value.selected = false
             }
            return true
        }
        target.selected = true
    }
}

// TODO: struct for testing.
//订单列表信息模型
//struct OrderListModel {
//    var createDate = "12:37"
//    var orderName = "带你深度畅游SANTORINI"
//    var serviceDate = "3月17日－3月22日"
//    var orderPrice = "7200元"
//    var orderState = "待处理"
//    
//    init(orderList:Dictionary<String,String>){
//        self.createDate = orderList["createDate"]!
//        self.orderName = orderList["orderName"]!
//        self.serviceDate = orderList["serviceDate"]!
//        self.orderPrice = orderList["orderPrice"]!
//        self.orderState = orderList["orderState"]!
//    }
//}




//MARK: - extension UITableView
extension AIOrderListViewController:UITableViewDelegate,UITableViewDataSource{
    
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("OrderListCell", forIndexPath: indexPath) as UITableViewCell //1
        
        let orderListModel = orderList[indexPath.row] as AIOrderListItemModel //2
        
        if let createDateLabel = cell.viewWithTag(110) as? UILabel { //3
            createDateLabel.text = orderListModel.order_create_time
        }
        if let orderNameLabel = cell.viewWithTag(120) as? UILabel {
            orderNameLabel.text = orderListModel.service_name
        }
        if let serviceDateLabel = cell.viewWithTag(130) as? UILabel {
            serviceDateLabel.text = orderListModel.service_time_duration
        }
        if let orderPriceLabel = cell.viewWithTag(150) as? UILabel {
            orderPriceLabel.text = orderListModel.order_price
        }
        if let orderStateLabel = cell.viewWithTag(170) as? UILabel {
            orderStateLabel.text = orderListModel.order_state_name
        }
        if let buttonView = cell.viewWithTag(180) {
            buildDynaOperButton(orderListModel.order_state_name!, orderType: "", buttonView: buttonView)
        }
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 167
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //AIOrderDetailStoryboard
//        println("执行跳转逻辑")
        let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AIOrderDetailStoryboard, bundle: nil).instantiateInitialViewController() as UIViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}