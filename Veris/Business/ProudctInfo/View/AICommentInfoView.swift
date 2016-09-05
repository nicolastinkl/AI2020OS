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

/// 评论Cell信息
class AICommentInfoView: UIView {
    private let offSetWidth: CGFloat = 5
    @IBOutlet weak var commentName: UILabel!
    @IBOutlet weak var commentContent: UILabel!
    @IBOutlet weak var commentDate: UILabel!
    @IBOutlet weak var commentImages: UIView!
    @IBOutlet weak var commentControls: UIView!
    @IBOutlet weak var viewControlrsConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentlike: UIView!
    @IBOutlet weak var bgView: UIView!
    
    private var constant: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentDate.font = AITools.myriadLightWithSize(14)
        //commentContent.font = AITools.myriadLightWithSize(14)
    }
    
    func initSubviews() {
        self.setWidth(UIScreen.mainScreen().bounds.width)
        self.layoutSubviews()
        self.bgView.backgroundColor = UIColor(hexString: "#393448", alpha: 0.3)
        //content
        
        commentContent.textColor = UIColor(hexString: "#FFFFFF", alpha: 0.6)
        
        //评论
        let commentImageView = UIImageView(image: UIImage(named: "aicomment_comment")!)
        commentlike.addSubview(commentImageView)
        commentImageView.tag = 1
        commentImageView.frame = CGRectMake(0, 5, 11, 11)
        
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor(hexString: "#FFFFFF", alpha: 0.7)
        label.frame = CGRectMake(commentImageView.right + 5, 1, 30, 20)
        label.tag = 2
        commentlike.addSubview(label)
        
        //点赞
        let zanImageView = UIImageView(image: UIImage(named: "aicomment_like")!)
        commentlike.addSubview(zanImageView)
        zanImageView.tag = 3
        zanImageView.frame = CGRectMake(label.right + 5, 5, 11, 11)
        
        let zanlabel = UILabel()
        zanlabel.text = ""
        zanlabel.font = UIFont.systemFontOfSize(12)
        zanlabel.textColor = UIColor(hexString: "#FFFFFF", alpha: 0.7)
        zanlabel.frame = CGRectMake(zanImageView.right + 5, 1, 40, 20)
        zanlabel.tag = 4
        commentlike.addSubview(zanlabel)
        
        
        let starRateView = StarRateView(frame: CGRect(x: 0, y: 5, width: 66, height: 12), numberOfStars: 5, foregroundImage: "star_rating_results_highlight", backgroundImage: "star_rating_results_normal" )
        
        starRateView.userInteractionEnabled = false
        let score: CGFloat = 0
        starRateView.scorePercent = score / 10
        starRateView.tag = 1
        commentControls.addSubview(starRateView)
        
        let imageViewWidth: CGFloat = 70
        var yHeight: CGFloat = 10
        var offWidth: CGFloat = 0
        for _ in 0...15 {
            let imageview = AIImageView()
            if (offWidth + (imageViewWidth + offSetWidth)) > UIScreen.mainScreen().bounds.width {
                offWidth =  offSetWidth
                yHeight += imageViewWidth + offSetWidth
            } else {
                offWidth =  offWidth  + offSetWidth
            }
            imageview.frame = CGRectMake(offWidth, yHeight, imageViewWidth, imageViewWidth)
            imageview.contentMode = UIViewContentMode.ScaleAspectFill
            commentImages.addSubview(imageview)
            imageview.clipsToBounds = true
            imageview.hidden = true
            offWidth += imageview.width
        }
    }
    
    func getheight() -> CGFloat {
        return commentImages.top + constant + 10
    }
    
    func fillDataWithModel(model: AICommentInfoModel) {
        
        commentImages.subviews.forEach { (imageview) in
            imageview.hidden = true
        }
        let photos: [[String: String]] = model.images ?? [] //model.photos as? [[String: String]] ?? []
        
        let imageViewWidth: CGFloat = 70
        var index = 0
        for photo in photos {
            /*if let imageview = commentImages.subviews[index] as? AIImageView, url = photo["url"] {
                imageview.setURL(NSURL(string: url), placeholderImage: smallPlace(), showProgress: true)
                imageview.hidden = false
            }*/
            
            if let imageview = commentImages.subviews[index] as? AIImageView {
                imageview.setURL(NSURL(string: photo["url"]!), placeholderImage: smallPlace(), showProgress: true)
                imageview.hidden = false
            }
            index += 1
        }
        
        let intPers = Int(UIScreen.mainScreen().bounds.width/imageViewWidth)
        let pers = CGFloat(photos.count) / CGFloat(intPers)
        let persInt = Int(photos.count) / intPers
        if pers > CGFloat(persInt) {
            viewControlrsConstraint.constant = (imageViewWidth + offSetWidth) * (CGFloat)(persInt + 1)
        } else {
            viewControlrsConstraint.constant = (imageViewWidth + offSetWidth) * (CGFloat)(persInt)
        }
        
        self.setNeedsUpdateConstraints()
        constant = viewControlrsConstraint.constant
        
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let destDateString = dateFormat.stringFromDate(NSDate(timeIntervalSinceNow: model.time ?? 0))
         
        //评论图片
        commentDate.font = AITools.myriadCondWithSize(13)
        commentDate.text = destDateString
        commentName.text = model.providename ?? ""
        commentContent.text = model.descripation ?? ""
        
        if let label = commentlike.viewWithTag(2) as? UILabel {
            label.text = "\(model.like)"
        }
        if let label = commentlike.viewWithTag(4) as? UILabel {
            label.text = "\(model.commentcount)"
        }
        
        if let star = commentControls.viewWithTag(1) as? StarRateView {
            star.scorePercent = CGFloat(model.level) / 10
        }

    }

}
