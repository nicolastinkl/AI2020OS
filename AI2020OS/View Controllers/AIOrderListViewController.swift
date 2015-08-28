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
import SCLAlertView

class AIOrderListViewController:UIViewController{
    
    // MARK: - Local var
    let ORDER_ROLE_CUSTOMER = "Customer"
    let ORDER_ROLE_PROVIDER = "Provider"
    var initOrderRole : String = "Customer"

    // MARK: - IBOutlets
    @IBOutlet weak var customerOrderView: UIView!
    @IBOutlet weak var providerOrderView: UIView!
    
    @IBOutlet weak var customerOrderButton: UIButton!
    @IBOutlet weak var providerOrderButton: UIButton!
    
    // MARK: - IBOutlet Actions
    @IBAction func customerOrderListAction(sender: UIButton) {
        toggleOrderList(ORDER_ROLE_CUSTOMER)
    }
    @IBAction func providerOrderListAction(sender: UIButton) {
        toggleOrderList(ORDER_ROLE_PROVIDER)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.title = " "
    }
    
    
    // MARK: - life cycle
    override func viewWillAppear(animated: Bool) {
//        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer.delegate = nil
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleOrderList(initOrderRole)
    }
    
    // MARK: - utils
    func toggleOrderList(orderRole:String){
        if orderRole == ORDER_ROLE_CUSTOMER{
            customerOrderButton.selected = true
            providerOrderButton.selected = false
            customerOrderView.hidden = false
            providerOrderView.hidden = true
        }
        else if orderRole == ORDER_ROLE_PROVIDER{
            customerOrderButton.selected = false
            providerOrderButton.selected = true
            customerOrderView.hidden = true
            providerOrderView.hidden = false
        }
    }

}

class AIBaseOrderListViewController : UIViewController{
    
    var orderList = Array<AIOrderListItemModel>()
    //默认查询
    var orderStatus : Int = 0
    
    // MARK: - operButtonActions
    func addOperButton(buttonArray:[ButtonModel],buttonView:UIView,indexNumber : Int){
        buttonView.subviews.filter{
            let value:UIButton = $0 as UIButton
            value.removeFromSuperview()
            return true
        }
        
        var x:CGFloat = 20
        for buttonModel in buttonArray{
            
            let contentRect = caculateContentSize(buttonModel.title, fontSize: 14)
            var button = UIButton(frame: CGRectMake(x, 0, contentRect.size.width, 20))
            button.setTitle(buttonModel.title, forState: UIControlState.Normal)
            //扩展的直接读取rgba颜色的方法
            button.setTitleColor(UIColor(rgba: "#30D7CE"), forState: UIControlState.Normal)
            button.backgroundColor = UIColor.clearColor()
            button.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
            //use to mark cell row number
            //button.tag = indexNumber
            button.associatedName = "\(indexNumber)"
            buttonView.addSubview(button)
            
            
            button.addTarget(self, action: buttonModel.action, forControlEvents: UIControlEvents.TouchUpInside)
            x = x + 40
            
            
        }
    }
    
    
    func assignOrder(target:UIButton){
        SCLAlertView().showInfo("提示", subTitle: "派单", closeButtonTitle: "关闭", duration: 3)
    }
    
    func commentsOrder(target:UIButton){
        let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AICommentStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AISingleCommentViewController) as AISingleCommentViewController
        let buttonIndex = target.associatedName?.toInt() ?? 0
        let orderNumber = findOrderNumberByIndexNumber(buttonIndex)
        let serviceId = findOServiceIdByIndexNumber(buttonIndex)
        viewController.inputOrderId = orderNumber
        viewController.inputServiceId = serviceId
        viewController.commentOrder = orderList[buttonIndex]
        self.navigationController?.pushViewController(viewController, animated: true)

    }
    
    func excuteOrder(target:UIButton){
        let buttonIndex = target.associatedName?.toInt() ?? 0
        let orderNumber = findOrderNumberByIndexNumber(buttonIndex)
        AIOrderRequester().updateOrderStatus(orderNumber, orderStatus: OrderStatus.Executing.rawValue, completion: { (resultCode) -> Void in
                self.updateOrderStatusCompletion(resultCode, comments: "开始执行订单")
            }
        )
    }
    
    func changeOrder(target:UIButton){
        SCLAlertView().showInfo("提示", subTitle: "申请修改订单！", closeButtonTitle: "关闭", duration: 3)
    }
    
    func finishOrder(target:UIButton){
        let buttonIndex = target.associatedName?.toInt() ?? 0
        let orderNumber = findOrderNumberByIndexNumber(buttonIndex)
        AIOrderRequester().updateOrderStatus(orderNumber, orderStatus: OrderStatus.WaidForComment.rawValue, completion: { (resultCode) -> Void in
            self.updateOrderStatusCompletion(resultCode, comments: "订单结束")
            }
        )
    }
    
    func shareOrder(target:UIButton){
        let buttonIndex = target.associatedName?.toInt() ?? 0
        let serviceName = orderList[buttonIndex].service_name ?? ""
        //AIShareViewController *shareVC = [AIShareViewController shareWithText:@"分享是一种快乐~"];  [self presentViewController:shareVC animated:YES completion:nil];
        let shareText = "我刚刚使用了\(serviceName),非常不错，大家都来试试呀～"
        let shareViewController = AIShareViewController.shareWithText(shareText)
        self.presentViewController(shareViewController, animated: true, completion: nil)
    }
    
    // MARK: - statusButtons
    func addStatusButton(buttonArray:[StatusButtonModel],scrollView:UIScrollView){
        scrollView.subviews.filter{
            let value:UIView = $0 as UIView
            value.removeFromSuperview()
            return true
        }
        let statusButtonWidth:CGFloat = 50
        let buttonPadding:CGFloat = 20
        let statusLabelWidth:CGFloat = 10
        
        var x1:CGFloat = 0
        var x2:CGFloat = statusButtonWidth
        
        var isFirst = true
        
        for buttonModel in buttonArray{
            var button = UIButton(frame: CGRectMake(x1, 0, statusButtonWidth, 25))
            //button.tag = buttonModel.status
            button.associatedName = "\(buttonModel.status)"
            //给第一个默认选中
            if isFirst {
                button.selected = true
                isFirst = false
            }
            button.setTitle(buttonModel.title, forState: UIControlState.Normal)
            //扩展的直接读取rgba颜色的方法
            button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            button.setTitleColor(UIColor(rgba: "#30D7CE"), forState: UIControlState.Selected)
            button.backgroundColor = UIColor.clearColor()
            button.titleLabel?.font = UIFont.systemFontOfSize(16)
            
            //add click event
            button.addTarget(self, action: "filterOrderAction:", forControlEvents: UIControlEvents.TouchUpInside)
            scrollView.addSubview(button)
            x1 = x1 + statusButtonWidth + statusLabelWidth + buttonPadding
            
            var label = UILabel(frame: CGRectMake(x2, 0, statusLabelWidth, 25))
            label.font = UIFont.systemFontOfSize(16)
            label.textColor = UIColor(rgba: "#30D7CE")
            label.text = "\(buttonModel.amount)"
            scrollView.addSubview(label)
            x2 = x1 + statusButtonWidth
            
        }
    }
    
    func filterOrderAction(target:UIButton){
        target.superview!.subviews.filter{
            if let value:UIButton = $0 as? UIButton {
                value.selected = false
            }
            return true
        }
        target.selected = true
        //temp content
        
    }
    
    func updateOrderStatusCompletion(resultCode:Int,comments:String){
        if resultCode == 1{
             SCLAlertView().showInfo("提示", subTitle: comments + "成功", closeButtonTitle: "关闭", duration: 3)
        }
        else{
            SCLAlertView().showError("错误", subTitle: comments + "失败", closeButtonTitle: "关闭", duration: 3)
        }
    }
    
    func caculateContentSize(content:String,fontSize:CGFloat) -> CGRect{
        let size = CGSizeMake(150,100)
        let s:NSString = "\(content)"
        let contentSize = s.boundingRectWithSize(size, options: NSStringDrawingOptions.UsesLineFragmentOrigin , attributes: [NSFontAttributeName:UIFont.systemFontOfSize(fontSize)], context: nil)
        return contentSize
    }
    
    func findOrderNumberByIndexNumber(indexNumber : Int) -> Int {
        return orderList[indexNumber].order_number!
    }
    
    func findOServiceIdByIndexNumber(indexNumber : Int) -> Int {
        return orderList[indexNumber].service_id!
    }
}