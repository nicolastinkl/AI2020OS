//
//  AICommentInfoView.swift
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

class AICommentInfoView: UIView {

    @IBOutlet weak var commentAvator: AIImageView!
    @IBOutlet weak var commentName: UILabel!
    @IBOutlet weak var commentContent: UILabel!
    @IBOutlet weak var commentDate: UILabel!
    @IBOutlet weak var commentImages: UIView!
    @IBOutlet weak var commentControls: UIView!
    @IBOutlet weak var viewControlrsConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func fillDataWithModel() {

        let imageViewWidth: CGFloat = 70
        
        
        let urls = ["http://7q5dv2.com1.z0.glb.clouddn.com/Kelvin%20-%20Bootstrap%203%20Resume%20Theme.png",
                    "http://7q5dv2.com1.z0.glb.clouddn.com/tinkl1.pic.jpg",
                    "http://7q5dv2.com1.z0.glb.clouddn.com/tinkl2D57E5A9-8BCE-4A3E-8C9C-E84C40825D89.png",
                    "http://7q5dv2.com1.z0.glb.clouddn.com/tinkl2H%7BC17WUNL%2503%291%605ANKYL6.jpg",
                    "http://7q5dv2.com1.z0.glb.clouddn.com/tinkl7711C941-BD7C-47A3-97EA-192AD2B63B87.png",
                    "http://7q5dv2.com1.z0.glb.clouddn.com/tinklSamsung-Galaxy-Gear-Smartwatch%20%E5%89%AF%E6%9C%AC.PNG",
                    "http://7q5dv2.com1.z0.glb.clouddn.com/tinklUpload_4.pic.jpg",
                    "http://7q5dv2.com1.z0.glb.clouddn.com/tinklUpload_64ADD30A-2F22-4E39-8FF0-DCE5ADFCC9B9.png",
                    "http://7q5dv2.com1.z0.glb.clouddn.com/tinklUpload_9.pic.jpg",
                    "http://7q5dv2.com1.z0.glb.clouddn.com/tinklUpload_EC78563D-64FF-4F15-B1C5-2495931006C3.png",
                    "http://7q5dv2.com1.z0.glb.clouddn.com/tinklUpload_Placehold@2x.png",
                    "http://7q5dv2.com1.z0.glb.clouddn.com/tinklUpload_Seller_Warning@2x.png"]

        var yHeight: CGFloat = 0
        var offWidth: CGFloat = 0
        for url in urls {
            let imageview = AIImageView()
            if (offWidth + (imageViewWidth + 2)) > self.width {
                offWidth =  2
                yHeight += imageViewWidth + 2
            } else {
                offWidth =  offWidth  + 2
            }
            imageview.frame = CGRectMake(offWidth, yHeight, imageViewWidth, imageViewWidth)
            imageview.contentMode = UIViewContentMode.ScaleAspectFill
            commentImages.addSubview(imageview)
            imageview.clipsToBounds = true
            imageview.setURL(NSURL(string: url), placeholderImage: smallPlace(), showProgress: true)
            offWidth += imageview.width
        }

        let starRateView = StarRateView(frame: CGRect(x: 0, y: 5, width: 100, height: 17), numberOfStars: 5, foregroundImage: "star_rating_results_highlight", backgroundImage: "star_rating_results_normal" )
        
        starRateView.userInteractionEnabled = false
        let score: CGFloat = 5
        starRateView.scorePercent = score / 10
        commentControls.addSubview(starRateView)

        let wPers = self.width/imageViewWidth
        let intPers = Int(self.width/imageViewWidth)
        let pers = CGFloat(urls.count) / wPers
        let persInt = Int(urls.count) / intPers
        if pers > CGFloat(persInt) {
            viewControlrsConstraint.constant = (imageViewWidth + 2) * (pers + 1)
        } else {
            viewControlrsConstraint.constant = (imageViewWidth + 2) * pers
        }
        self.setNeedsUpdateConstraints()
        
        /*let label = UILabel()
        label.text = "\(score)"
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = AITools.colorWithR(253, g: 225, b: 50)
        label.frame = CGRectMake(starRateView.right + 5, 1, 40, 20)
        commentControls.addSubview(label)

        //点赞
        let zanImageView = UIImageView(image: UIImage(named: "Zan")!)
        commentControls.addSubview(zanImageView)
        zanImageView.frame = CGRectMake(label.right + 5, 5, 11, 11)

        let zanlabel = UILabel()
        zanlabel.text = "12345"
        zanlabel.font = UIFont.systemFontOfSize(12)
        zanlabel.textColor = UIColor.whiteColor()
        zanlabel.frame = CGRectMake(zanImageView.right + 5, 1, 40, 20)
        commentControls.addSubview(zanlabel)

        */


    }

}
