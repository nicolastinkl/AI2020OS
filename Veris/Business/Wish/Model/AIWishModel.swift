//
//  AIWishModel.swift
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

///心愿推荐和心愿最热列 气泡
class AIWishHotModel: JSONJoy {
    
    var hot_wish_list: [AIWishHotChildModel]?
    var recommended_wish_list: [AIWishHotChildModel]?
    
    required init(_ decoder: JSONDecoder) {
        
        if let ArrayHot = decoder["hot_wish_list"].array {
            hot_wish_list = Array<AIWishHotChildModel>()
            for decHot in ArrayHot {
                hot_wish_list?.append(AIWishHotChildModel(decHot))
            }
        }
        
        if let ArrayHot = decoder["recommended_wish_list"].array {
            recommended_wish_list = Array<AIWishHotChildModel>()
            for decHot in ArrayHot {
                recommended_wish_list?.append(AIWishHotChildModel(decHot))
            }
        }
        
        
    }

}

/// 最新许愿model
class AIWishHotChildModel: JSONJoy {
    
    var type_id: Int = 0
    var name: String = ""
    var contents: String = ""
    var already_wish: Int = 0
    var target_wish: Int = 0
    var money_unit: String = ""
    var money_type: String = ""
    var money_avg: Double = 0.0
    var money_adv: Double = 0.0
    init(){}
    required init(_ decoder: JSONDecoder) {
        type_id = decoder["type_id"].integer ?? 0
        name = decoder["name"].string ?? ""
        contents = decoder["contents"].string ?? ""
        already_wish = decoder["already_wish"].integer ?? 0
        target_wish = decoder["target_wish"].integer ?? 0
        money_unit = decoder["money_unit"].string ?? ""
        money_type = decoder["money_type"].string ?? ""
        money_avg = decoder["money_avg"].double ?? 0.0
        money_adv = decoder["money_adv"].double ?? 0.0
    }
}










