//
//  AITimelineTableViewCell.swift
//  AIVeris
//
//  Created by 刘先 on 16/6/20.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AITimelineTableViewCell: UITableViewCell {

    // MARK: -> IB properties
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var timeContentLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var timeLabel: UILabel!

    var viewModel: AITimelineViewModel?
    var imageContainerViewHeight: CGFloat = 0
    var delegate: AITimelineTableViewCellDelegate?
    var needComputeHeight = true
    let cellWidth = UIScreen.mainScreen().bounds.width - AITools.displaySizeFrom1242DesignSize(220)

    // MARK: -> override methods
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    func setupViews() {
        self.backgroundColor = UIColor.clearColor()
        timeLabel.textColor = CustomerCenterConstants.Colors.TimeLabelColor
        timeLabel.font = CustomerCenterConstants.Fonts.TimeLabelNormal
        timeContentLabel.font = CustomerCenterConstants.Fonts.TimelineButton
        dotView.backgroundColor = CustomerCenterConstants.Colors.TimelineDotColor
        dotView.layer.cornerRadius = dotView.bounds.width / 2
        dotView.layer.masksToBounds = true
    }

    func buildImageContainerView() {
        var lastView: UIView?
        var curView: UIView?
        guard let viewModel = viewModel else {return}
        //清空subView
        for subView in imageContainerView.subviews {
            subView.removeFromSuperview()
        }
        //重置变化的高度计算
        imageContainerViewHeight = 0
        
        let viewModelContentsCount = viewModel.contents!.count
        for (index, timeContentModel) in (viewModel.contents)!.enumerate() {
            switch timeContentModel.contentType! {
            case AITimelineContentTypeEnum.Image:
                let imageView = buildImageContentView(timeContentModel.contentUrl!)
                curView = imageView
            case AITimelineContentTypeEnum.LocationMap: break
                
                
            case AITimelineContentTypeEnum.Voice: break
                
            }
            guard let curView = curView else {return}
            if index == 0 {
                curView.snp_makeConstraints(closure: { (make) in
                    make.top.equalTo(curView.superview!)
                })
            }
            if index != 0 && index != viewModelContentsCount - 1 {
                if let lastView = lastView {
                    curView.snp_makeConstraints(closure: { (make) in
                        make.bottom.equalTo(lastView).offset(5)
                    })
                    
                }
            }
            lastView = curView
        }
    }
    
    

    func buildButtonContainerView() {
        
        if let viewModel = viewModel {
            //清空subView
            for subView in buttonContainerView.subviews {
                subView.removeFromSuperview()
            }
            
            switch viewModel.layoutType! {
            case .ConfirmServiceComplete:
                let confirmButton = UIButton()
                confirmButton.setTitle(CustomerCenterConstants.textContent.confirmButton, forState: UIControlState.Normal)
                confirmButton.titleLabel?.font = CustomerCenterConstants.Fonts.TimelineButton
                confirmButton.backgroundColor = UIColor.blueColor()
                confirmButton.layer.cornerRadius = 8
                confirmButton.layer.masksToBounds = true
                buttonContainerView.addSubview(confirmButton)
                
                let buttonWidth = CustomerCenterConstants.textContent.confirmButton.sizeWithFont(CustomerCenterConstants.Fonts.TimelineButton, forWidth: 500).width + 20
                confirmButton.snp_makeConstraints(closure: { (make) in
                    make.leading.top.bottom.equalTo(buttonContainerView)
                    make.width.equalTo(buttonWidth)
                })
            default:
                break
            }
        }

    }

    func buildImageContentView(url: String) -> UIImageView {
        let imageView = UIImageView()
        self.imageContainerView.addSubview(imageView)
        imageView.snp_makeConstraints { (make) in
            make.leading.trailing.equalTo(self.imageContainerView)
            make.height.equalTo(40)
        }
        //加载图片以后根据图片高度决定约束高度
        //通过在这里赋值形成一个强引用
        let cacheModel = viewModel!
        
        imageView.sd_setImageWithURL(NSURL(string: url ), placeholderImage: CustomerCenterConstants.defaultImages.timelineImage, options: SDWebImageOptions.RetryFailed) { (image, error, cacheType, url) in
            let height = self.getCompressedImageHeight(image)
            self.imageContainerViewHeight = height
            imageView.snp_updateConstraints { (make) in
                make.height.equalTo(height)
            }
            if self.viewModel?.cellHeight == 0 {
                if let delegate = self.delegate {
                    let height = self.getHeight()
                    self.viewModel?.cellHeight = height
                    delegate.cellImageDidLoad(viewModel: cacheModel, cellHeight: height)
                }
            }
        }
        return imageView
    }

    func loadData(viewModel: AITimelineViewModel) {
        self.viewModel = viewModel

        timeLabel.text = viewModel.timeModel?.time
        buildImageContainerView()
        buildButtonContainerView()
    }
    
    //通过图片的实际宽度和view宽度计算出来的压缩比例计算展现的高度
    func getCompressedImageHeight(image: UIImage) -> CGFloat {
        let compressedRate = cellWidth / image.size.width
        return image.size.height * compressedRate
    }
    
    //计算view高度，如果还没有loadData则返回0
    func getHeight() -> CGFloat {
        let baseTimelineContentLabelHeight: CGFloat = 33
        let cellMargin: CGFloat = 20
        let subViewMargin: CGFloat = 11
        let baseButtonsHeight: CGFloat = 26
        
        var totalHeight: CGFloat = 0
        
        if let viewModel = viewModel {
            switch viewModel.layoutType! {
            case AITimelineLayoutTypeEnum.Normal:
                totalHeight = baseTimelineContentLabelHeight + cellMargin
            case .Authoration, .ConfirmOrderComplete, .ConfirmServiceComplete:
                totalHeight = baseTimelineContentLabelHeight + subViewMargin * 2 + baseButtonsHeight + cellMargin + imageContainerViewHeight
                
            }
        }
        return totalHeight
    }

}


protocol AITimelineTableViewCellDelegate {
    func cellImageDidLoad(viewModel viewModel: AITimelineViewModel, cellHeight: CGFloat)
}
