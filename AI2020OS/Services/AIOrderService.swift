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
    typealias OrderListRequesterCompletion = (data:[AIOrderListModel]) ->()
    private var isLoading : Bool = false
    
    //查询订单列表 
    func queryOrderList(page :Int=1,completion:OrderListRequesterCompletion){
        
        if isLoading {
            return
        }
        isLoading = true
        
        AIHttpEngine.postRequestWithParameters(AIHttpEngine.ResourcePath.GetOrderList, parameters: ["page_num":"1","order_state":"1"]) {  [weak self] (response, error) -> () in
            if let strongSelf = self{
                strongSelf.isLoading = false
            }
            if let responseJSON: AnyObject = response{
                let orders =  AIOrderListModel(JSONDecoder(responseJSON))
                completion(data: orders.orderArray)
            }else{
                completion(data: [])
            }
        }
    }
}