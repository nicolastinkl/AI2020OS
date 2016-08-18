//
//  AIPayModel.swift
//  AIVeris
//
// Copyright (c) 2016 ___ASIAINFO___
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation


class AIPayInfoModel: JSONJoy {
    var orderid: String?
    var servicename: String?
    var serviceicon: String?
    var servicestars: String?
    var providerphone: String?
    var totalorders: String?
    var price: Double?

    var total_fee: String?
    var deduct_fee: String?
    var pay_fee: String?
    
    var paymentItem = Array<AIPaymentItemModel>()
    
    init() {}
    required init(_ decoder: JSONDecoder) {
        orderid = decoder["pre_paymentid"].string ?? ""
        servicename = decoder["service_name"].string ?? ""
        serviceicon = decoder["service_icon"].string ?? ""
        servicestars = decoder["servicestars"].string ?? ""
        providerphone = decoder["providerphone"].string ?? ""
        totalorders = decoder["total_orders"].string ?? ""
        if let array = decoder["total_orders"].array {
            for dec in array {
                let pro = AIPaymentItemModel(dec)
                paymentItem.append(pro)
            }
        }
        
        total_fee = decoder["total_fee"].string ?? ""
        deduct_fee = decoder["deduct_fee"].string ?? ""
        pay_fee = decoder["pay_fee"].string ?? ""
    }
}


struct AIPaymentItemModel: JSONJoy {
    var name: String?
    var amout: String?
    var details = Array<AIPaymentItemModel>()

    init(_ decoder: JSONDecoder) {
        name = decoder["name"].string ?? ""
        amout = decoder["amout"].string ?? ""
        
        if let array = decoder["details"].array {
            for dec in array {
                let pro = AIPaymentItemModel(dec)
                details.append(pro)
            }
        }
    }
}
 
