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

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func fillDataWithModel() {

        let imageViewWidth: CGFloat = 75
        for index in 0...2 {
            let imageview = AIImageView()
            imageview.frame = CGRectMake(CGFloat(index) * (imageViewWidth + 2), 2, imageViewWidth, imageViewWidth)
            imageview.contentMode = UIViewContentMode.ScaleAspectFill
            commentImages.addSubview(imageview)
            imageview.clipsToBounds = true
            imageview.setURL(NSURL(string: "http://ww2.sinaimg.cn/bmiddle/9fe1d9e1gw1f4ht3tkwp8j20ss0hsgpa.jpg"), placeholderImage: smallPlace())
        }

        let starRateView = StarRateView(frame: CGRect(x: 0, y: 5, width: 60, height: 11), numberOfStars: 5, foregroundImage: "star_rating_results_highlight", backgroundImage: "star_rating_results_normal" )
        
        starRateView.userInteractionEnabled = false
        let score: CGFloat = 5
        starRateView.scorePercent = score / 10
        commentControls.addSubview(starRateView)

        let label = UILabel()
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

        


    }

}
