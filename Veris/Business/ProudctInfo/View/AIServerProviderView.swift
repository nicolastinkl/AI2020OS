//
//  AIServerProviderView.swift
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

/// 服务者详细信息介绍
class AIServerProviderView: UIView {
 
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var des: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var radio: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        image.layer.cornerRadius = image.width/2
        image.layer.masksToBounds = true
    }
    
    func fillDataWithModel(model: AIPublicProviderModel?) {
        if let model = model {
            name.text = model.name ?? ""
            des.text = model.desc ?? ""
            number.text = String(format: "AIServerProviderView.ServiceCustomerFormat".localized, model.service_times ?? "")
            let str = "AIServerProviderView.ServiceRateFormat".localized
            radio.text = String(format: str, model.good_rate ?? "")

            image.sd_setImageWithURL(NSURL(string: model.icon ?? ""), placeholderImage: smallPlace())
            image.userInteractionEnabled = true
        }
        
    }
    
    
}
