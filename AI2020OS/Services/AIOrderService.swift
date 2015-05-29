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
                completion(data: orders.orderArray!)
            }else{
                //这里的意义是强引用，
                
                func fakeData() -> [AIOrderListItemModel]{
                    let fM = NSFileManager()
                    
                    let json =  NSString(contentsOfFile: fM.currentDirectoryPath+"/jsonfile.json", encoding: NSUTF8StringEncoding, error: nil)
                    let responseJSON = NSData(contentsOfFile: "jsonfile.json")
                    
                    let responseJSONS = "[{\"order_id\": 1001,\"order_number\": \"2015052811234\",\"order_state\":\"3\",\"order_state_name\":\"待处理\",\"order_create_time\": \"2015-5-23 15:30\",\"service_id\":\"1002\",\"service_name\":\"地陪小王\",\"provider_id\":\"1003\",\"service_type\":1,\"provider_portrait_url\":\"http://xxxx/image\",\"service_time_duration\":\"3月１７日－３月２２日\"}]"
                    let orders =  AIOrderListModel(JSONDecoder(responseJSON as AnyObject))
                    return orders.orderArray!                    
                }
                
                completion(data: fakeData())
                
//                if let strongSelf = self{
//                    completion(data: strongSelf.fakeData())
//                }
//                else{
//                    return completion(data:[])
//                }
                
            }
        }
    }
    
    
}