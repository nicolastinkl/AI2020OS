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
    typealias OrderDetailRequesterCompletion = (data:OrderDetailModel,error:Error?) ->()
    typealias OrderNumberRequesterCompletion = (data:[OrderNumberModel],error:Error?) ->()
    
    typealias SubmitOrderCompletion = (success:Bool) -> Void
    
    private var isLoading : Bool = false
    
    //查询订单列表 
    func queryOrderList(page :Int=1,orderRole : Int,orderState : Int,completion:OrderListRequesterCompletion){
        
        if isLoading {
            return
        }
        isLoading = true
        
        let paras = [
            "page_num": "1",
            "order_role": "\(orderRole)",
            "order_state": "\(orderState)"
        ]
        
        AIHttpEngine.postRequestWithParameters(AIHttpEngine.ResourcePath.GetOrderList, parameters: paras) {  [weak self] (response, error) -> () in

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
                if let data = orders.orderArray {
                    completion(data: data)
                }
                else{
                    return completion(data:[])
                }
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
    func submitOrder(serviceId : Int,serviceParams: NSMutableArray,completion : SubmitOrderCompletion){
        if isLoading {
            return
        }
        isLoading = true

        let timeStamp: Int = Int(NSDate().timeIntervalSince1970)
        let paras = ["service_id": serviceId,
            "service_exectime":timeStamp,
            "order_role":1,
            "service_param_list":serviceParams
        ]
        
        AIHttpEngine.postRequestWithParameters(AIHttpEngine.ResourcePath.SubmitOrder, parameters: paras) {  [weak self] (response, error) -> () in
            if let strongSelf = self{
                strongSelf.isLoading = false
            }
            
            if let res = response as NSDictionary? {
                
                if let reCode = res.valueForKey("result_code") as String?{
                    if let responseCode = reCode.toInt() {
                        if responseCode == 1 {
                            completion(success: true)
                        }
                    }
                    
                }
            }
            
            return completion(success: false)
        }
    }
    
    //订购方法
    func submitOrder(serviceId : Int,completion : SubmitOrderCompletion){
        if isLoading {
            return
        }
        isLoading = true
        
        let paras = [
            "data":[
                "service_id": serviceId,
                "service_exectime":"123456",
                "service_param_list":[]
            ],
            "desc":[
                "data_mode": 0,
                "digest": ""
            ]
        ]
        
        AIHttpEngine.postRequestWithParameters(AIHttpEngine.ResourcePath.SubmitOrder, parameters: paras) {  [weak self] (response, error) -> () in
            if let strongSelf = self{
                strongSelf.isLoading = false
            }
            return completion(success: response != nil)
        }
    }
    
    func queryOrderDetail(orderId : Int , completion : OrderDetailRequesterCompletion){
        let requestMessage = AIOrderMessageWrapper.getOrderDetail(orderId)
        var orderDetailModel : OrderDetailModel!
        AINetEngine.defaultEngine().postMessage(requestMessage, success:
            { (response) -> Void in
                let responseArray : NSArray = AIMessageWrapper.jsonModelsFromArray(response as NSArray, withModelClass: OrderDetailModel.self)
                orderDetailModel = responseArray.firstObject as? OrderDetailModel
                completion(data: orderDetailModel, error: nil)

            }, fail: { (error:AINetError, errorDes:String!) -> Void in
                
                completion(data: OrderDetailModel(), error: Error(message: errorDes, code: error.rawValue))
        })
    }
    
    func updateOrderStatus(orderId : Int,orderStatus : Int,completion : (resultCode : Int) -> Void) {
        let requestMessage = AIOrderMessageWrapper.updateOrderStatus(orderId, orderStatus: orderStatus)
        AINetEngine.defaultEngine().postMessage(requestMessage, success:
            { (response) -> Void in
                completion(resultCode: 1)
                
            }, fail: { (error:AINetError, errorDes:String!) -> Void in
                
                completion(resultCode: 0)
        })

    }
    
    func queryOrderNumber(orderRole : Int, orderStatus : Int , completion : OrderNumberRequesterCompletion){
        let requestMessage = AIOrderMessageWrapper.getOrderNumber(orderStatus, orderRole: orderRole)
        var orderNumberModel : OrderNumberModel!
        AINetEngine.defaultEngine().postMessage(requestMessage, success:
            { (response) -> Void in
                let responseArray : NSArray = AIMessageWrapper.jsonModelsFromArray(response as NSArray, withModelClass: OrderNumberModel.self)
                let orderNumberList = responseArray as [OrderNumberModel]
                completion(data: orderNumberList, error: nil)
                
            }, fail: { (error:AINetError, errorDes:String!) -> Void in
                
                completion(data: [], error: Error(message: errorDes, code: error.rawValue))
        })
    }
}