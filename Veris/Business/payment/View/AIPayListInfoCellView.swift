//
//  UIPayListInfoCellView.swift
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
import Cartography

class AIPayListInfoCellView: UITableViewCell {
    
    @IBOutlet weak var expendConstrint: NSLayoutConstraint!
    
    @IBOutlet weak var payName: UILabel!
    @IBOutlet weak var payPrice: UILabel!
    @IBOutlet weak var arrowDirectIcon: UIImageView!
    @IBOutlet weak var expendView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        payPrice.font = AITools.myriadLightWithSize(48/3)
        payName.font = AITools.myriadLightWithSize(48/3)
        
    }
    
    func setCellContent(item: AIPayInfoModel, isExpanded: Bool) {
        
        debugPrint(isExpanded)
        self.payName.text = item.servicename ?? ""
        self.payPrice.text = "\(item.price ?? 0)元"
        self.arrowDirectIcon.image = item.childList?.count > 0 ? UIImage(named: "AI_Search_Home_right") : nil
//        self.disclosureView.direction = isExpanded ? ArrowDirection.Top : ArrowDirection.Bottom
//        self.disclosureView.setNeedsDisplay()
        
        let expendListView = UIView()
        var topOffset: CGFloat = 0
        if let m = item.childList {
            for model in m {
                let name = UILabel()
                name.text = model.servicename ?? ""
                
                let price = UILabel()
                price.text = "\(model.price ?? 0)元"
                
                name.textColor = UIColor(hexString: "#fefefe", alpha: 0.76)
                price.textColor = UIColor(hexString: "#fefefe", alpha: 0.76)
                
                name.font = AITools.myriadLightWithSize(40/3)
                price.font = AITools.myriadLightWithSize(40/3)
                
                name.textAlignment = .Left
                price.textAlignment = .Right
                
                name.setWidth(100)
                price.setWidth(60)
                price.setRight(0)
                
                name.setTop(topOffset)
                price.setTop(topOffset)
                
                topOffset += 30
                
                expendListView.addSubview(name)
                expendListView.addSubview(price)
                
            }
        }
        
        expendConstrint.constant = topOffset
        
        expendView.addSubview(expendListView)
        
        constrain(expendListView) { (expendListViewProxy) in
            expendListViewProxy.left == expendListViewProxy.superview!.left
            expendListViewProxy.right == expendListViewProxy.superview!.right
            expendListViewProxy.top == expendListViewProxy.superview!.top
            expendListViewProxy.bottom == expendListViewProxy.superview!.bottom
        }
        
        expendView.setNeedsLayout()
        
        
    }
    /**
     获取高度
     */
    func cellContentHeight()->CGFloat {
        return self.expendView.intrinsicContentSize().height + 37.0
    }
    
}
