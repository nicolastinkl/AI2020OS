//
//  AIComponentChoseViewController.swift
//  AI2020OS
//
//  Created by tinkl on 22/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import SCLAlertView

class AIComponentChoseViewController: UIViewController {
    
    // MARK: swift controls
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    private let margeheight:CGFloat = 20
    
    var serviceId:String?
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK TITLE
        localCode {
            
        }
        
        var title = UILabel()
        title.text = "服务范围"
        title.setWidth(self.view.width)
        title.textColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlackColor)
        title.setHeight(30)
        title.setLeft(25)
        title.setTop(20)
        self.contentScrollView.addSubview(title)
        
        // MARK CONTENT
        let scopeView =  AIServerScopeView.currentView()
        scopeView.initWithViewsArray([
            ServerScopeModel(outId: "2", outContent: "90元一次"),
            ServerScopeModel(outId: "6", outContent: "120元一次"),
            ServerScopeModel(outId: "3", outContent: "190元一次"),
            ServerScopeModel(outId: "5", outContent: "190元两次"),
            ServerScopeModel(outId: "7", outContent: "190元三次")], parentView: self.view)
        self.contentScrollView.addSubview(scopeView)
        scopeView.setTop(title.height + title.top)
        
        // MARK LINE
        var line =  UILabel()
        line.setWidth(self.view.width*0.9)
        line.setHeight(0.5)
        line.setTop(scopeView.height + scopeView.top)
        line.setLeft((self.view.width - line.width)/2)
        line.backgroundColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlackColor)
        self.contentScrollView.addSubview(line)
        
        // MARK TITLE
        var title2 = UILabel()
        title2.text = "服务时间"
        title2.setWidth(self.view.width)
        title2.textColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlackColor)
        title2.setHeight(30)
        title2.setLeft(25)
        title2.setTop(line.top+margeheight)
        self.contentScrollView.addSubview(title2)
        
        // MARK CONTENT
        
        var timePickerView = AIServerTimeView.currentView()
        self.contentScrollView.addSubview(timePickerView)
        timePickerView.setTop(title2.height + title2.top)
        
        // MARK LINE
        var line2 =  UILabel()
        line2.setWidth(self.view.width*0.9)
        line2.setHeight(0.5)
        line2.setTop(timePickerView.height + timePickerView.top + 50)
        line2.setLeft((self.view.width - line2.width)/2)
        line2.backgroundColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlackColor)
        self.contentScrollView.addSubview(line2)
        
        // MARK TITLE
        var title3 = UILabel()
        title3.text = "服务地址"
        title3.setWidth(self.view.width)
        title3.textColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlackColor)
        title3.setHeight(30)
        title3.setLeft(25)
        title3.setTop(line2.top+margeheight)
        self.contentScrollView.addSubview(title3)

        var addressPickerView = AIServerAddressView.currentView()
        self.contentScrollView.addSubview(addressPickerView)
        addressPickerView.setTop(title3.height + title3.top)
        
        // MARK LINE
        var line3 =  UILabel()
        line3.setWidth(self.view.width*0.9)
        line3.setHeight(0.5)
        line3.setTop(addressPickerView.height + addressPickerView.top + 50)
        line3.setLeft((self.view.width - line3.width)/2)
        //line3.backgroundColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlackColor)
        self.contentScrollView.addSubview(line3)
        
        var object: AnyObject =  UIButton.buttonWithType(UIButtonType.Custom)
        var button = object as UIButton
        
        button.layer.borderColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor).CGColor
        
        // TODO: title Color
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        // TODO: Background Image
        button.setBackgroundImage(UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor).imageWithColor(), forState: UIControlState.Normal)
        //button.setBackgroundImage(UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor).imageWithColor(), forState: UIControlState.Highlighted)
        //button.addTarget(self, action: Selector("buttonDownAction:"), forControlEvents: UIControlEvents.TouchDown)
        
        button.layer.borderColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor).CGColor
        button.layer.borderWidth = 1
        
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        
        self.contentScrollView.addSubview(button)
        button.setTop(line3.top + line3.height + 5)
        button.setWidth(self.view.width)
        button.setHeight(50)
        button.setTitle("提交订单", forState: UIControlState.Normal)
        button.addTarget(self, action: "submitOrder", forControlEvents: UIControlEvents.TouchUpInside)
        self.contentScrollView.contentSize = CGSizeMake(self.view.width, button.top+button.height)
        
    }
    
    func submitOrder(){
        if let serverid = self.title?.toInt() {
            if serverid > 0 {
                self.view.showLoading()
                Async.userInitiated { () -> Void in
                    AIOrderRequester().submitOrder(serverid, completion: { (success) -> Void in
                        self.view.hideLoading()
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                }
            }else{
                SCLAlertView().showError("提交失败", subTitle: "参数有误", closeButtonTitle: "关闭", duration: 2)
            }
            
        }
        
    }
    
    // MARK: event response
    @IBAction func disMissViewController(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}