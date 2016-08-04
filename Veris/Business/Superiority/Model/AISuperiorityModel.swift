//
//  AISuperiorityModel.swift
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

class AIPricePublicModel: JSONJoy {
    
    var price: Double?
    var unit: Double?
    var billing_mode: Double?
    var price_show: String?
    
    init() {}
    
    required init(_ decoder: JSONDecoder) {
        price = decoder["price"].double ?? 0
        unit = decoder["unit"].double ?? 0
        billing_mode = decoder["billing_mode"].double ?? 0
        price_show = decoder["price_show"].string ?? ""
    }
    
}

class AISuperiorityModel: JSONJoy {

    var serviceID: Int?
    var name: String?
    var icon: String?
    var type: String?
    var desc: String?
    var advantage: [String]?  // 服务优势List
    var price: AIPricePublicModel?
    var serviceExecList: [AISuperiorityIconModel]?

    init() {}

    required init(_ decoder: JSONDecoder) {
        if let decoderDic = decoder["base_info"].dictionary {
            
            name = decoderDic["name"]?.string ?? ""
            icon = decoderDic["icon"]?.string ?? ""
            type = decoderDic["type"]?.string ?? ""
            desc = decoderDic["desc"]?.string ?? ""
            decoderDic["advantage"]?.getArray(&advantage)
            if let pr = decoderDic["price"] {
                price = AIPricePublicModel(pr)
            }
            
            guard let process = decoder["process"].array else {return}
            var collect = [AISuperiorityIconModel]()
            for addrDecoder in process {
                collect.append(AISuperiorityIconModel(addrDecoder))
            }
            serviceExecList = collect
            
            
        }
        
    }


    class AISuperiorityIconModel: JSONJoy {

        var iconstep: String?
        var iconName: String?
        var iconURL: String?

        init() {}
        required init(_ decoder: JSONDecoder) {
            iconstep = decoder["step"].string ?? ""
            iconName = decoder["desc"].string ?? ""
            iconURL = decoder["icon"].string ?? ""
            
        }
    }
}
