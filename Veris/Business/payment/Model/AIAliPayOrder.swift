//
//  MyOrder.swift
//  AppPayDemo
//
//  Created by Leon King on 1/29/16.
//  Copyright © 2016 QinYejun. All rights reserved.
//

import Foundation

struct AIAliPayOrder {
    var id: Int
    var title: String
    var content: String
    var url: String
    var createdAt: String
    var price: Double
    var paid: Bool
    var productID: Int
    
    init(id: Int,
        title: String,
        content: String,
        url: String,
        createdAt: String,
        price: Double,
        paid: Bool,
        productID: Int) {
            self.id = id
            self.title = title
            self.content = content
            self.url = url
            self.createdAt = createdAt
            self.price = price
            self.paid = paid
            self.productID = productID
    }
    
}
