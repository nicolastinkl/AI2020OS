//
//  AICustomerOrderDetailViewController.swift
//  AI2020OS
//
//  Created by 刘先 on 15/8/18.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AICustomerOrderDetailViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var timeLineView: UIView!

    @IBOutlet weak var serviceAddr: UILabel!
    @IBOutlet weak var serviceTimeDuration: UILabel!
    @IBOutlet weak var orderName: UILabel!
    
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var orderCreateTime: UILabel!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var serviceDesc: UILabel!
    @IBOutlet weak var serviceThumbnailUrl: UIImageView!
    
    @IBOutlet weak var servicePrice: UILabel!
    
    var orderId:String!
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var backItem = UIBarButtonItem(image: UIImage(named: "ico_back"), style: UIBarButtonItemStyle.Plain, target: self, action: "leftAction")
        self.navigationItem.leftBarButtonItem = backItem
        
        self.title = "订单详情"
        
        orderId = "100000013149"
        retryNetworkingAction()
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.interactivePopGestureRecognizer.delegate = nil
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - utils
    func retryNetworkingAction(){
        self.view.hideProgressViewLoading()
        self.view.showProgressViewLoading()
        //后台请求数据
        Async.background(){
            // Do any additional setup after loading the view, typically from a nib.
            AIOrderRequester().queryOrderDetail(self.orderId, completion: {
                (data:OrderDetailModel,error:Error?) ->() in
                self.view.hideProgressViewLoading()
                println("order_detail_data : \(data)")
            })
        }
    }
    
    func leftAction()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func buildTimeLineView(){
        
    }
}
