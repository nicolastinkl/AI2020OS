//
//  AIWishVowViewController.swift
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
import UIKit
import Spring
import Cartography
import AIAlertView
import SnapKit

/// 许愿视图
class AIPaymentViewController: UIViewController {
    
    @IBOutlet weak var providerIcon: AIImageView!
    
    @IBOutlet weak var providerName: UILabel!
    
    @IBOutlet weak var providerLevel: UIView!
    @IBOutlet weak var weixinButton: UIButton!
    @IBOutlet weak var alipayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let navi = AINavigationBar.initFromNib() as? AINavigationBar {
            view.addSubview(navi)
            navi.holderViewController = self
            constrain(navi, block: { (layout) in
                layout.left == layout.superview!.left
                layout.top == layout.superview!.top
                layout.right == layout.superview!.right
                layout.height == 44.0 + 10.0
            })
        }
        
        layoutSubView()
    }
    
    func layoutSubView(){
        
        providerName.text = "孕检无忧"
        
        if let starRateView = CWStarRateView(frameAndImage: CGRect(x: 0, y: 5, width: 60, height: 11), numberOfStars: 5, foreground: "star_rating_results_highlight", background: "star_rating_results_normal" ) {
            starRateView.userInteractionEnabled = false
            let score: CGFloat = 5
            starRateView.scorePercent = score / 10
            providerLevel.addSubview(starRateView)
            
            let label = UILabel()
            label.text = "\(score)"
            label.font = UIFont.systemFontOfSize(12)
            label.textColor = AITools.colorWithR(253, g: 225, b: 50)
            label.frame = CGRectMake(starRateView.right + 5, 1, 40, 20)
            providerLevel.addSubview(label)
            
            let zanlabel = UILabel()
            zanlabel.text = "12345"
            zanlabel.font = UIFont.systemFontOfSize(12)
            zanlabel.textColor = UIColor.whiteColor()
            zanlabel.frame = CGRectMake(label.right + 5, 1, 40, 20)
            providerLevel.addSubview(zanlabel)
            
        }
    }
    
    @IBAction func callPhone(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "tel:13888888888")!)
    }
    
    @IBAction func wechatAction(sender: AnyObject) {
        
        
        
    }
    
    @IBAction func alipayAction(sender: AnyObject) {
        
        
    }
    
    

}
