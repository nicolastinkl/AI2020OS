//
//  WeatherModel.swift
//  AI2020OS
//
//  Created by tinkl on 21/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

/*!
*  @author tinkl, 15-04-21 19:04:35
*
*  解析天气 JSON
*/
struct WeatherModel{
    
    
    let city: String?
    let date_y: String?
    let week: String?
    let weather1: String?
    let index_d: String?
    init() {
        
    }
    
    init(_ decoder: NSDictionary) {
        let weatherinfo : NSDictionary = decoder["weatherinfo"] as? NSDictionary ?? NSDictionary()
        self.city = weatherinfo["city"]  as? String ?? ""
        self.date_y = weatherinfo["date_y"] as? String ?? ""
        self.week = weatherinfo["week"] as? String ?? ""
        self.weather1 = weatherinfo["weather1"] as? String ?? ""
        self.index_d = weatherinfo["index_d"] as? String ?? ""
    }
}