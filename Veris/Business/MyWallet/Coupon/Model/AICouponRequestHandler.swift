//
//  AICouponRequestHandler.swift
//  AIVeris
//
//  Created by 刘先 on 16/11/1.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AICouponRequestHandler: NSObject {
    
    struct AINetErrorDescription {
        static let FormatError = "BusinessModel data error."
        static let BusinessError = "Backend data error."
        static let BusinessFail = "Backend business fail."
    }
    
    //单例变量
    static let sharedInstance = AICouponRequestHandler()
    
    /**
     查询我的优惠券
     
     - parameter type:  工作机会id
     - parameter locationModel: gps信息
     - parameter success:
     - parameter fail:
     */
    func queryMyCoupons(type: NSString,locationModel: AIGPSViewModel?, success: (busiModel: AICouponsViewModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message = AIMessage()
        //多层次的话，body类型必须显示指定
        var body: NSMutableDictionary = ["data": ["type": type], "desc": ["data_mode": "0", "digest": ""]]
        if let locationModel = locationModel {
            let latitude: NSString = NSString(string: "\(locationModel.latitude!)")
            let longitude: NSString = NSString(string: "\(locationModel.longitude!)")
            let gpsType: NSString = NSString(string: "BAIDU")
            body = ["data": ["type": type, "location": ["latidute": latitude, "longidute": longitude, "type": gpsType]], "desc": ["data_mode": "0", "digest": ""]]
        }
        message.body.addEntriesFromDictionary(body as [NSObject: AnyObject])
        message.url = AIApplication.AIApplicationServerURL.queryMyVoucher.description as String
        
        //weak var weakSelf = self
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            let dic = response as! [NSObject: AnyObject]
            if let vouchers = dic["vouchers"] as? [AnyObject] {
                let couponsViewModel = AICouponsViewModel()
                let vouchersBusiModel = AIVoucherBusiModel.arrayOfModelsFromDictionaries(vouchers) as NSArray as! [AIVoucherBusiModel]
                couponsViewModel.couponsModel = vouchersBusiModel
                success(busiModel: couponsViewModel)
            } else {
                fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
            }
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes)
        }
    }
    
    /**
     查询我的商家币
     - parameter success:
     - parameter fail:
     */
    func queryMyCurrencys(success: (busiModel: AICurrencysViewModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        let message = AIMessage()
        let body = ["data": [], "desc": ["data_mode": "0", "digest": ""]]
        message.body.addEntriesFromDictionary(body as [NSObject: AnyObject])
        message.url = AIApplication.AIApplicationServerURL.queryMyCoins.description as String
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            let dic = response as! [NSObject: AnyObject]
            if let coins = dic["coins"] as? [AnyObject] {
                let currencyViewModel = AICurrencysViewModel()
                let coinsBusiModel = AICoinBusiModel.arrayOfModelsFromDictionaries(coins) as NSArray as! [AICoinBusiModel]
                currencyViewModel.currencysModel = coinsBusiModel
                success(busiModel: currencyViewModel)
            } else {
                fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
            }
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes)
        }

    }
}
