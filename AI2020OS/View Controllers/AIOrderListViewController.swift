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
    
    // MARK: - Local var
    let ORDER_ROLE_CUSTOMER = "Customer"
    let ORDER_ROLE_PROVIDER = "Provider"

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
        toggleOrderList(ORDER_ROLE_CUSTOMER)
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
        
        for buttonModel in buttonArray{
            var button = UIButton(frame: CGRectMake(x1, 0, statusButtonWidth, 33))
            
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
            
            var label = UILabel(frame: CGRectMake(x2, 0, statusLabelWidth, 33))
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
    }
}