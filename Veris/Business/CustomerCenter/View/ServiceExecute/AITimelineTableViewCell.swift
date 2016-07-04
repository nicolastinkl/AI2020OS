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
    weak var delegate: AITimelineTableViewCellDelegate?
    var needComputeHeight = true
    let cellWidth = UIScreen.mainScreen().bounds.width - AITools.displaySizeFrom1242DesignSize(220)

    // MARK: -> override methods
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    
    // MARK: -> build and layout view methods
    func setupViews() {
        self.backgroundColor = UIColor.clearColor()
        timeLabel.textColor = CustomerCenterConstants.Colors.TimeLabelColor
        timeLabel.font = CustomerCenterConstants.Fonts.TimeLabelNormal
        timeContentLabel.font = CustomerCenterConstants.Fonts.TimelineButton
        dotView.backgroundColor = CustomerCenterConstants.Colors.TimelineDotColor
        dotView.layer.cornerRadius = dotView.bounds.width / 2
        dotView.layer.masksToBounds = true
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
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
        
        if (viewModel.contents?.count) != nil{
            for (index, timeContentModel) in (viewModel.contents)!.enumerate() {
                switch timeContentModel.contentType! {
                case AITimelineContentTypeEnum.Image:
                    let imageView = buildImageContentView(timeContentModel.contentUrl!)
                    curView = imageView
                case AITimelineContentTypeEnum.LocationMap: break
                    
                    
                case AITimelineContentTypeEnum.Voice:
                    let voiceView = buildVoiceContentView(timeContentModel.contentUrl!, time: 2)
                    curView = voiceView
                    
                }
                guard let curView = curView else {return}
                if index == 0 {
                    curView.snp_makeConstraints(closure: { (make) in
                        make.top.equalTo(curView.superview!)
                    })
                }
                if index != 0 {
                    if let lastView = lastView {
                        curView.snp_makeConstraints(closure: { (make) in
                            make.top.equalTo(lastView.snp_bottom).offset(5)
                        })
                        
                    }
                }
                lastView = curView
            }
        }
        
    }
    
    func buildButtonContainerView() {
        
        if let viewModel = viewModel {
            //清空subView
            for subView in buttonContainerView.subviews {
                subView.removeFromSuperview()
            }
            
            switch viewModel.layoutType! {
            case .ConfirmServiceComplete, .ConfirmOrderComplete:
                let confirmButton = UIButton()
                confirmButton.setTitle(CustomerCenterConstants.textContent.confirmButton, forState: UIControlState.Normal)
                confirmButton.titleLabel?.font = CustomerCenterConstants.Fonts.TimelineButton
                let backImage = UIColor(hex: "#0f86e8").imageWithColor()
                confirmButton.setBackgroundImage(backImage, forState: UIControlState.Normal)
                confirmButton.layer.cornerRadius = 13
                confirmButton.layer.masksToBounds = true
                buttonContainerView.addSubview(confirmButton)
                confirmButton.addTarget(self, action: #selector(AITimelineTableViewCell.confirmServiceCompleteAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
                let buttonWidth = CustomerCenterConstants.textContent.confirmButton.sizeWithFont(CustomerCenterConstants.Fonts.TimelineButton, forWidth: 500).width + 30
                confirmButton.snp_makeConstraints(closure: { (make) in
                    make.leading.top.bottom.equalTo(buttonContainerView)
                    make.width.equalTo(buttonWidth)
                })
            case .Authoration: break
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
        

        imageView.sd_setImageWithURL(NSURL(string: url ), placeholderImage: CustomerCenterConstants.defaultImages.timelineImage, options: SDWebImageOptions.RetryFailed) {[weak self] (image, error, cacheType, url) in
            let imageHeight = self?.getCompressedImageHeight(image)
            if let imageHeight = imageHeight {
                self?.imageContainerViewHeight += imageHeight
                imageView.snp_updateConstraints { (make) in
                    make.height.equalTo(imageHeight)
                }
                if self?.viewModel?.cellHeight == 0 {
                    if let delegate = self?.delegate {
                        //TODO: 因为第二次进入从缓存加载图片太快，cell的第一次load还没完成就触发reload，结果展现就错乱了
                        //暂时通过加延迟的方式解决
                        Async.main(after: 0.1, block: { 
                            let height = self?.getHeight()
                            if let height = height {
                                self?.viewModel?.cellHeight = height
                                delegate.cellImageDidLoad(viewModel: cacheModel, cellHeight: height)
                            }
                        })
                        
                        
                    }
                }
            }
        }
        return imageView
    }
    
    func buildVoiceContentView(url: String, time: Int?) -> AIAudioMessageView {
        let audioModel = AIProposalServiceDetailHopeModel()
        audioModel.audio_url = url
        audioModel.time = time ?? 0
        let audio1 = AIAudioMessageView.currentView()
        imageContainerView.addSubview(audio1)
        
        imageContainerViewHeight += 22
        
        //audio1.tag = 11
        audio1.fillData(audioModel)
        audio1.snp_makeConstraints { (make) in
            make.leading.equalTo(self.imageContainerView)
            make.trailing.equalTo(self.imageContainerView).offset(-40 / 3)
            make.height.equalTo(22)
        }
        audio1.smallMode()
        return audio1
    }

    func loadData(viewModel: AITimelineViewModel) {
        self.viewModel = viewModel

        timeLabel.text = viewModel.timeModel?.time
        buildImageContainerView()
        buildButtonContainerView()
    }
    
    // MARK: -> events handle
    func confirmServiceCompleteAction(sender: UIButton) {
        if let delegate = delegate {
            delegate.cellConfirmButtonDidClick(viewModel: viewModel!)
        }
    }
    
    func authorizeAction(sender: UIButton) {
        
    }
    
    func rejectAuthorizeAction(sender: UIButton) {
        
    }
    
    // MARK: -> util methods
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


protocol AITimelineTableViewCellDelegate: NSObjectProtocol {
    func cellImageDidLoad(viewModel viewModel: AITimelineViewModel, cellHeight: CGFloat)
    
    func cellConfirmButtonDidClick(viewModel viewModel: AITimelineViewModel)
    
}
