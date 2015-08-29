//
//  AICustomerOrderDetailViewController.swift
//  AI2020OS
//
//  Created by 刘先 on 15/8/18.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import SCLAlertView

class AICustomerOrderDetailViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var timeLineView: SubTimelineView!

    @IBOutlet weak var serviceAddr: UILabel!
    @IBOutlet weak var serviceTimeDuration: UILabel!
    @IBOutlet weak var orderName: UILabel!
    
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var orderCreateTime: UILabel!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var serviceDesc: UILabel!
    
    @IBOutlet weak var serviceIntroImage: AIImageView!
    @IBOutlet weak var servicePrice: UILabel!
    
    var orderId:Int!
    var serviceId:Int!
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var backItem = UIBarButtonItem(image: UIImage(named: "ico_back"), style: UIBarButtonItemStyle.Plain, target: self, action: "leftAction")
        self.navigationItem.leftBarButtonItem = backItem
        
        self.title = "订单详情"
        // request networking.
        retryNetworkingAction()
        // request timeline data
        //timeLineView.orderId = "\(orderId)"
        //timeLineView.retryNetworkingAction()
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.interactivePopGestureRecognizer.delegate = nil
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - utils
    func retryRequest() {
        retryNetworkingAction()
    }
    
    func retryNetworkingAction(){
        self.view.hideProgressViewLoading()
        self.view.showProgressViewLoading()
        //后台请求数据
        Async.background(){
            // Do any additional setup after loading the view, typically from a nib.
            AIOrderRequester().queryOrderDetail(self.orderId, completion: {
                (data:OrderDetailModel,error:Error?) ->() in
                self.view.hideProgressViewLoading()
                self.bindOrderData(data)
            })
        }
        
        Async.background(){
            let servicesRequester = AIServicesRequester()
            AIServicesRequester().loadServiceDetail(self.serviceId, service_type: 0) { [weak self](data) -> () in
                if let strongSelf = self{
                    strongSelf.bindServiceData(data)
                }
            }
            
//            servicesRequester.loadServiceDetail(self.serviceId, service_type: 0, completion:
//                { (data) -> () in
//                    self.bindServiceData(data)
//                }
//            )
        }
    }
    
    func leftAction()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }

    //bind service data to view
    func bindOrderData(orderDetailModel : OrderDetailModel){
        let serviceNameValue = orderDetailModel.service_name ?? "no name"
        let orderPriceValue = orderDetailModel.order_price ?? "0"
        let orderCreateTimeValue = orderDetailModel.order_create_time ?? "2015-1-1"
        var serviceTimeDurationValue = orderDetailModel.service_time_duration ?? "0"
        serviceTimeDurationValue = serviceTimeDurationValue.imestampStringToDateString()
        
        orderNumber.text = orderDetailModel.order_number ?? "0"
        orderName.text = "\(serviceNameValue) \(orderPriceValue)"
        orderCreateTime.text = orderCreateTimeValue
        serviceTimeDuration.text = serviceTimeDurationValue
    }
    
    func bindServiceData(serviceDetailModel : AIServiceDetailModel){
        serviceIntroImage.setURL(NSURL(string: serviceDetailModel.service_intro_url ?? ""), placeholderImage: UIImage(named: "Placeholder"))
        servicePrice.text = serviceDetailModel.service_price ?? "0"
        serviceName.text = serviceDetailModel.service_name ?? "no name"
        serviceDesc.text = serviceDetailModel.service_intro ?? ""
    }
}

 // MARK: - operator buttons view
class AICustomerOrderDetailOperViewController : UIViewController{
    
    @IBAction func changeOrderAction(sender: UIButton) {
        SCLAlertView().showInfo("提示", subTitle: "申请修改订单", closeButtonTitle: "关闭", duration: 3)
    }
    @IBAction func commentOrderAction(sender: UIButton) {
        let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AICommentStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AISingleCommentViewController) as AISingleCommentViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func payOrderAction(sender: UIButton) {
        SCLAlertView().showInfo("提示", subTitle: "支付消息", closeButtonTitle: "关闭", duration: 3)
    }
    @IBAction func openIMAction(sender: UIButton) {
        SCLAlertView().showInfo("提示", subTitle: "打开电子白板", closeButtonTitle: "关闭", duration: 3)
    }
}
