//
//  AIOrderService.swift
//  AI2020OS
//
//  Created by 刘先 on 15/5/28.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import JSONJoy

class AIOrderRequester {
    typealias OrderListRequesterCompletion = (data:[AIOrderListItemModel]) ->()
    
    typealias SubmitOrderCompletion = (success:Bool) -> Void
    
    private var isLoading : Bool = false
    
    //查询订单列表 
    func queryOrderList(page :Int=1,completion:OrderListRequesterCompletion){
        
        if isLoading {
            return
        }
        isLoading = true
        
        AIHttpEngine.postRequestWithParameters(AIHttpEngine.ResourcePath.GetOrderList, parameters: ["page_num":"1","order_role":1,"order_state":11]) {  [weak self] (response, error) -> () in
            if let strongSelf = self{
                strongSelf.isLoading = false
            }
            
            func fakeData() -> [AIOrderListItemModel]{

                let json = "[{order_id:5,order_number:12345}]"
                let data = NSString(string: json).dataUsingEncoding(NSUTF8StringEncoding)
                 
                let orders =  AIOrderListModel(JSONDecoder(data as AnyObject))
                return orders.orderArray!
            }
            
            if let responseJSON: AnyObject = response{
                let orders =  AIOrderListModel(JSONDecoder(responseJSON))
                completion(data: orders.orderArray!)
            }else{
             
                if let strongSelf = self{
                    return completion(data: fakeData())
                }
                else{
                    return completion(data:[])
                }
                
            }
        }
    }
    

 //订购方法
    func submitOrder(serviceId : Int,completion : SubmitOrderCompletion){
        if isLoading {
            return
        }
        isLoading = true
        
        let paras = ["service_id": serviceId,
            "service_exectime":"123456",
            "service_param_list":[]
        ]
        
        AIHttpEngine.postRequestWithParameters(AIHttpEngine.ResourcePath.SubmitOrder, parameters: paras) {  [weak self] (response, error) -> () in
            if let strongSelf = self{
                strongSelf.isLoading = false
            }
            return completion(success: response != nil)
        }
    }
    
}