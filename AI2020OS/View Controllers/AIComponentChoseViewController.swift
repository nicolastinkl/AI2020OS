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
    
    // 参数数据 
    var movieDetailsResponse:AIServiceDetailModel?
    
    private let margeheight:CGFloat = 20
    
    var serviceId:String?
    
    private var selectedParams:NSMutableDictionary = NSMutableDictionary()
 
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cellHeigh:CGFloat = 0
        
        if let modelArray = self.movieDetailsResponse?.service_param_list {
            for newmodel in modelArray{
                // MARK TITLE
                var model = newmodel
                cellHeigh += margeheight
                var title = UILabel()
                title.text = model.param_key ?? ""
                title.setWidth(self.view.width)
                title.textColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlackColor)
                title.setHeight(30)
                title.setLeft(25)
                title.setTop(cellHeigh)
                self.contentScrollView.addSubview(title)
                
                cellHeigh += title.height   // Set Height...
                
                model.param_type = 7
                
                if NSString(string: model.param_key ?? "").containsString("时间") {
                    model.param_type = 1
                }
                
                if NSString(string: model.param_key ?? "").containsString("地址") {
                    model.param_type = 5
                }
                
                // MARK CONTENT
                //参数类型, 1-时间，2-int（选择商品数量），3-double, 4-bool(开关)，5-地址 ,6-子服务 , 7-多项单选, 8-多项多选
                
                if let type = model.param_type {
                    
                    switch type {
                    case 1: //时间
                        
                        var timePickerView = AIServerTimeView.currentView()
                        self.contentScrollView.addSubview(timePickerView)
                        timePickerView.setTop(cellHeigh)
                        cellHeigh += timePickerView.height + 50
                        timePickerView.viewChangeClosure({ (number) -> () in
                            let key = model.param_key ?? ""
                            let params = ["param_key":model.param_key_id ?? 0,"param_value":number,"formattime":true,"param_value_id":0]
                            self.selectedParams.setValue(params, forKey: key)
                            
                        })
                        
                        break
                    case 2: //选择数量
                        var selectNumebrView = AIServiceCountView.currentView()
                        self.contentScrollView.addSubview(selectNumebrView)
                        selectNumebrView.setTop(cellHeigh)
                        cellHeigh += selectNumebrView.height
                        selectNumebrView.viewChangeClosure({ (number) -> () in
                            let key = model.param_key ?? ""
                            let params = ["param_key":model.param_key_id ?? 0,"param_value":number,"param_value_id":0]
                            self.selectedParams.setValue(params, forKey: key)
                        })
                        break
                    case 3: //double
                        
                        break
                    case 4: //开关
                        
                        break
                    case 5: //地址
                        
                        var addressPickerView = AIServerInputView.currentView()
                        self.contentScrollView.addSubview(addressPickerView)
                        addressPickerView.setTop(cellHeigh)
                        cellHeigh += addressPickerView.height
                        addressPickerView.viewChangeClosure({ (text) -> () in
                            
                            let key = model.param_key ?? ""
                            let params = ["param_key":model.param_key_id ?? 0,"param_value":text,"param_value_id":0]
                            self.selectedParams.setValue(params, forKey: key)
                            
                        })
                        break
                    case 6: //子服务
                        
                        break
                    case 7: //多项单选
                        let scopeView =  AIServerScopeView.currentView()
                        
                        var scopeArray:Array<ServerScopeModel> = []
                        
                        if let chmodel =  model.param_value {
                            for ch in chmodel {
                                scopeArray.append(ServerScopeModel(outId: "\(ch.id ?? 0)", outContent: "\(ch.title!)"))
                            }
                        }
                        scopeView.initWithViewsArray(scopeArray, parentView: self.view)
                        self.contentScrollView.addSubview(scopeView)
                        scopeView.setTop(cellHeigh)
                        scopeView.setLeft(10)
                        cellHeigh += scopeView.height + margeheight
                        
                        scopeView.didSelectedItem({ ( index ) -> () in
                            let modelTwo = scopeArray[index] as ServerScopeModel
                            
                            let key = model.param_key ?? ""
                            
                            let params = ["param_key":model.param_key_id ?? 0,"param_value":modelTwo.content ?? "","param_value_id":modelTwo.id?.toInt() ?? 0,"param_value_type":"1"]
                            self.selectedParams.setValue(params, forKey: key)
                            
                            // self.selectedParams.setValue(modelTwo.content, forKey: key)
                            
                        })
                        
                        break
                    case 8: //多项多选
                        
                        break
                    default:
                        break
                    }

                }
                
                // MARK LINE
                var line2 =  UILabel()
                line2.setWidth(self.view.width*0.9)
                line2.setHeight(0.5)
                line2.setTop(cellHeigh)
                line2.setLeft((self.view.width - line2.width)/2)
                line2.backgroundColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlackColor)
                self.contentScrollView.addSubview(line2)
                cellHeigh += line2.height
            }
        }
        
        self.contentScrollView.contentSize = CGSizeMake(self.view.width, cellHeigh + 100)
        
        
        var object: AnyObject =  UIButton.buttonWithType(UIButtonType.Custom)
        var button = object as UIButton
    
        button.layer.borderColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor).CGColor
        
        // TODO: title Color
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        // TODO: Background Image
        button.setBackgroundImage(UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor).imageWithColor(), forState: UIControlState.Normal)
        
        button.layer.borderColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor).CGColor
        button.layer.borderWidth = 1
        
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        
        self.view.addSubview(button)
        button.setTop(self.view.height - 50)
        //button.setTop(line3.top + line3.height + 5)
        button.setWidth(self.view.width)
        button.setHeight(50)
        button.setTitle("提交订单", forState: UIControlState.Normal)
        button.addTarget(self, action: "submitOrder", forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    func submitOrder(){
        
        // Step 1: 处理选择参数
        // Step 2: 处理参数拼接
        let sParams = self.selectedParams
        
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIOrderSubmitViewController) as AIOrderSubmitViewController
        viewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        viewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        viewController.serviceId = self.movieDetailsResponse?.service_id ?? 0
        viewController.selectedParams = sParams
        self.presentViewController(viewController, animated: true, completion: nil)
        
        viewController.label_title.text = self.movieDetailsResponse?.service_name ?? ""
         
        
        if self.movieDetailsResponse?.service_param_list?.count == sParams.allKeys.count && sParams.allKeys.count  > 0 {
            
            let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIOrderSubmitViewController) as AIOrderSubmitViewController
            viewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            viewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
            viewController.serviceId = self.movieDetailsResponse?.service_id ?? 0
            viewController.selectedParams = sParams
            self.presentViewController(viewController, animated: true, completion: nil)
            
            viewController.label_title.text = self.movieDetailsResponse?.service_name ?? ""
            
        }else{
            
            SCLAlertView().showWarning("提示", subTitle: "参数没选完就提交订单，你在逗我吗?", closeButtonTitle: "关闭", duration: 4)
            
        }

        
        // Step 3: 发送通知
        
        if let pid = movieDetailsResponse?.provider_id {
            var notification = [kAPNS_Alert : "您有一个新的订单,请查收!", kAPNS_ProviderID : pid];
            AIPushNotificationHandler.pushRemoteNotification(notification)
        }
        
    }
    
    // MARK: event response
    @IBAction func disMissViewController(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}