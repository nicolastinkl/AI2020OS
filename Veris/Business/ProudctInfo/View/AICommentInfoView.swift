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

    @IBOutlet weak var commentName: UILabel!
    @IBOutlet weak var commentContent: UILabel!
    @IBOutlet weak var commentDate: UILabel!
    @IBOutlet weak var commentImages: UIView!
    @IBOutlet weak var commentControls: UIView!
    @IBOutlet weak var viewControlrsConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentlike: UIView!
    
    private var constant: CGFloat = 0
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func getheight() -> CGFloat {
        
        return commentImages.top + constant + 10
    }
    
    func fillDataWithModel(model: AICommentInfoModel) {
        
        let urls = model.images ?? []
        
        let imageViewWidth: CGFloat = 70
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
        let score: CGFloat = CGFloat(model.level)
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
        constant = viewControlrsConstraint.constant
        
        
        //评论图片
        commentDate.text = "\(model.time ?? 0)"
        commentName.text = model.providename ?? ""
        commentContent.text = model.descripation ?? ""
        
        //点赞
        let commentImageView = UIImageView(image: UIImage(named: "Zan")!)
        commentlike.addSubview(commentImageView)
        commentImageView.frame = CGRectMake(0, 5, 11, 11)
        
        
        let label = UILabel()
        label.text = "\(model.commentcount )"
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.whiteColor()
        label.frame = CGRectMake(commentImageView.right + 5, 1, 30, 20)
        commentlike.addSubview(label)

        //点赞
        let zanImageView = UIImageView(image: UIImage(named: "Zan")!)
        commentlike.addSubview(zanImageView)
        zanImageView.frame = CGRectMake(label.right + 5, 5, 11, 11)

        let zanlabel = UILabel()
        zanlabel.text = "\(model.like)"
        zanlabel.font = UIFont.systemFontOfSize(12)
        zanlabel.textColor = UIColor.whiteColor()
        zanlabel.frame = CGRectMake(zanImageView.right + 5, 1, 40, 20)
        commentlike.addSubview(zanlabel)



    }

}
