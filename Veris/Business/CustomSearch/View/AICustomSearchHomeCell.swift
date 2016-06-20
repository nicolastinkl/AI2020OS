//
//  AICustomSearchHomeCell.swift
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

class AICustomSearchHomeCell: UITableViewCell {
    
    @IBOutlet weak var imageview: AIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var desLabel: UILabel!
    
    @IBOutlet weak var nameTwiceLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        desLabel.textColor = UIColor(hexString: "#FFFFFF", alpha: 0.7)
        
        priceLabel.font = UIFont.systemFontOfSize(16)
        priceLabel.textColor = AITools.colorWithR(253, g: 225, b: 50)
    }
    
    func initData(model: AISearchResultItemModel) {
        imageview.setURL(NSURL(string: ""), placeholderImage: smallPlace())
        nameLabel.text = model.service_name as String
        nameTwiceLabel.text = model.service_second_name as String
        desLabel.text = model.service_description as String
        priceLabel.text = model.service_price as String
    }
}