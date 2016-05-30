//
//  AIOrderModel.swift
//  AI2020OS
//
//  Created by 刘先 on 15/5/28.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import JSONJoy

// MARK: - model wrapper
class AIOrderMessageWrapper : AIMessageWrapper{
    class func getOrderDetail(orderId : Int) -> AIMessage{
        var message : AIMessage = AIMessage()
        
        let body = [
            "data":["order_id":orderId],
            "desc":[
                "data_mode":"0",
                "digest":""
            ]]
        
        message.body = NSMutableDictionary(dictionary:body)
        message.url = AIHttpEngine.baseURL + AIHttpEngine.ResourcePath.GetOrderDetail.description
        return message
    }
    
    class func updateOrderStatus(orderId:Int,orderStatus:Int) -> AIMessage{
        var message : AIMessage = AIMessage()
        
        let body = [
            "data":["order_number":orderId,"status":orderStatus],
            "desc":[
                "data_mode":"0",
                "digest":""
        ]]
        
        message.body = NSMutableDictionary(dictionary:body)
        message.url = AIHttpEngine.baseURL + AIHttpEngine.ResourcePath.UpdateOrderStatus.description
        return message

    }
    
    class func getOrderNumber(orderState : Int,orderRole : Int)
       -> AIMessage{
            var message : AIMessage = AIMessage()
            
            let body = [
                "data":["order_state":orderState,"order_role":orderRole],
                "desc":[
                    "data_mode":"0",
                    "digest":""
            ]]
            
            message.body = NSMutableDictionary(dictionary:body)
            message.url = AIHttpEngine.baseURL + AIHttpEngine.ResourcePath.QueryOrderNumber.description
            return message
    }
}

// MARK: - models
//订单列表model
struct AIOrderListModel : JSONJoy {
    var orderArray: Array<AIOrderListItemModel>?
    init(_ decoder: JSONDecoder) {
        if let addrs = decoder.array {
            orderArray = Array<AIOrderListItemModel>()
            for orderItem in addrs {
                orderArray?.append(AIOrderListItemModel(orderItem))
            }
        }
    }
}

//订单列表项model
struct AIOrderListItemModel : JSONJoy{
//    "order_id": 1001,
//    "order_number": "2015052811234",
//    "order_state": 3,
//    "order_state_name": “待处理”,
//    " order_create_time ": "2015-5-23 15:30",
//	   "service_id": 1002,
//    "service_name": "地陪小王",
//	   “provider_id”: 1003
//    “service_type”:1
//    “provider_portrait_url”:http://xxxx/image
//    “service_time_duration”:”3月１７日－３月２２日”
    var order_id : Int?
    var order_number : Int?
    var order_state : Int?
    var order_state_name : String?
    var order_create_time : String?
    var service_id : Int?
    var service_name : String?
    var provider_id : Int?
    var service_type : Int?
    var provider_portrait_url : String?
    var service_time_duration : String?
    var order_price : String?
    var customer_id : Int?
    
    var provider_name : String?
    var customer_portrait_url : String?
    var customer_name : String?
    
    init(){
    
    }
    
    init(_ decoder: JSONDecoder) {
        order_id = decoder["order_id"].integer
        order_number = decoder["order_number"].integer
        order_state = decoder["order_state"].integer
        order_state_name = decoder["order_state_name"].string
        order_create_time = decoder["order_create_time"].string
        service_id = decoder["service_id"].integer
        service_name = decoder["service_name"].string
        provider_id = decoder["provider_id"].integer
        service_type = decoder["service_type"].integer
        provider_portrait_url = decoder["provider_portrait_url"].string
        service_time_duration = decoder["service_time_duration"].string
        order_price = decoder["order_price"].string
        customer_id = decoder["customer_id"].integer
    }
}



// 服务参数数据模型
struct ServiceParam {
    var paramKey : Int?
    var paramValue : String?
    var paramName : String?
    
    init(){
        
    }
}


struct ButtonModel{
    var title = ""
    var action:Selector = ""
    
    init(title:String,action:Selector){
        self.title = title
        self.action = action
    }
}

struct StatusButtonModel {
    var title = ""
    var amount = 0
    var status:Int!
    
    init(title:String,amount:Int,status:Int){
        self.title = title
        self.amount = amount
        self.status = status
    }
}

// MARK: - enums
enum OrderStatus:Int{
    case WaitForExe = 101,
    Executing = 100,
    WaitForPay = 11,
    Commented = 102,
    Finished = 14,
    Default = 0
}

enum OrderRole : Int{
    case Customer = 1,Provider
}

//服务参数的固定charTypeId
enum CharTypeId : Int{
    case ServiceTimeCharTypeId = 25042660,
    ServiceAddressCharTypeId = 12
}
