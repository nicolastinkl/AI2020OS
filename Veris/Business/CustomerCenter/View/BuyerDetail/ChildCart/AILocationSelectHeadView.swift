//
//  AILocationSelectHeadView.swift
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
import Spring

/// 搜索头部View定制
class AILocationSelectHeadView: UIView {
    
    @IBOutlet weak var nearView: UIView!
    
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for index in 0...2 {
            let imageView = DesignableImageView()
            let label = UILabel()
            
            imageView.frame = CGRectMake(CGFloat((15 + 80) * index), 5, 65, 65)
            label.frame = CGRectMake(imageView.left, 70, 65, 20)
            scrollview.addSubview(imageView)
            scrollview.addSubview(label)
            
            label.text = "Beijing"
            label.textColor = UIColor.whiteColor()
            label.font = AITools.myriadLightWithSize(14)
            label.textAlignment  = .Center
            imageView.image = UIImage(named: "icon-mia")
        }        
    }
    
    
    @IBAction func openSearchView(){
        AIApplication().SendAction("showSearchViewController", ownerName: self)
    }
    
    
}