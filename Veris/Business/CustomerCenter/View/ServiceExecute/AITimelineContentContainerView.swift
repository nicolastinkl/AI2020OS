//
//  AITimelineContentContainerView.swift
//  AIVeris
//
//  Created by 刘先 on 7/13/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AITimelineContentContainerView: UIView {

    //可能没有button，先建一个高度为0的，如果有了再updateConstraint
    var buttonContainerView: UIView!
    var imageContainerView: UIView!
    
    var imageContainerViewHeight: CGFloat = 0
    var viewModel: AITimelineViewModel?
    var delegate: AITimelineContentContainerViewDelegate?
    
    //MARK: -> Constants
    let acceptButtonBgColor = UIColor(hexString: "#0f86e8")
    let acceptButtonTextColor = UIColor.whiteColor()
    let buttonTextFont = AITools.myriadSemiCondensedWithSize(60 / 3)
    let buttonContainterHeight: CGFloat = 26
    let acceptButtonWidth: CGFloat = AITools.displaySizeFrom1242DesignSize(220)
    let voiceHeight: CGFloat = 22
    let subViewMargin: CGFloat = 11
    let defaultImageHeight: CGFloat = 118
    let defaultMapHeight: CGFloat = 130
    
    //MARK: -> overrides
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(viewModel: AITimelineViewModel, delegate: AITimelineContentContainerViewDelegate?) {
        self.init(frame: CGRect.zero)
        setupViews()
        self.delegate = delegate
        loadData(viewModel)
    }
    
    //MARK: -> public methods
    func getCaculateViewHeight() -> CGFloat {
        return self.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
    }
    
    func setupViews() {
        buttonContainerView = UIView()
        imageContainerView = UIView()
        self.addSubview(imageContainerView)
        self.addSubview(buttonContainerView)
        imageContainerView.snp_makeConstraints { (make) in
            make.top.leading.trailing.equalTo(self)
        }
        buttonContainerView.snp_makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self)
            //初始化不知道有没有button时，高度先设置为0
            make.height.equalTo(0)
            make.top.equalTo(imageContainerView.snp_bottom)
        }
    }
    
    func loadData(viewModel: AITimelineViewModel) {
        self.viewModel = viewModel
        buildImageContainerView()
        buildButtonContainerView()
    }
    
    //MARK: -> private methods
    func buildImageContainerView() {
        var containerSubViews = [UIView]()
        guard let viewModel = viewModel else {return}
        //清空subView
        for subView in imageContainerView.subviews {
            subView.removeFromSuperview()
        }
        //重置变化的高度计算
        imageContainerViewHeight = 0
        if (viewModel.contents?.count) != nil {
            for (index, timeContentModel) in (viewModel.contents)!.enumerate() {
                
                switch timeContentModel.contentType! {
                case AITimelineContentTypeEnum.Image:
                    let imageView = buildImageContentView(timeContentModel.contentUrl!)
                    containerSubViews.append(imageView)
                case AITimelineContentTypeEnum.LocationMap:
                    let mapView = buildMapContentView()
                    mapView.setupView()
                    containerSubViews.append(mapView)
                case AITimelineContentTypeEnum.Voice:
                    let voiceView = buildVoiceContentView(timeContentModel.contentUrl!, time: 2)
                    containerSubViews.append(voiceView)
                    
                }
                if index == 0 {
                    containerSubViews[0].snp_makeConstraints(closure: { (make) in
                        make.top.equalTo(containerSubViews[0].superview!)
                    })
                } else {
                    //两个subview之间的间隔
                    imageContainerViewHeight += AITimelineTableViewCell.subViewMargin
                    
                    containerSubViews[index].snp_makeConstraints(closure: { (make) in
                        make.top.equalTo(containerSubViews[index - 1].snp_bottom).offset(AITimelineTableViewCell.subViewMargin)
                    })
                }
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
            //需要确认按钮的
            case .ConfirmServiceComplete, .ConfirmOrderComplete:
                let confirmButton = UIButton()
                
                confirmButton.setTitle(getOperationButtonText(viewModel), forState: UIControlState.Normal)
                confirmButton.titleLabel?.font = CustomerCenterConstants.Fonts.TimelineButton
                let backImage = UIColor(hex: "#0f86e8").imageWithColor()
                confirmButton.setBackgroundImage(backImage, forState: UIControlState.Normal)
                confirmButton.layer.cornerRadius = buttonContainterHeight / 2
                confirmButton.layer.masksToBounds = true
                buttonContainerView.addSubview(confirmButton)
                if viewModel.layoutType == .ConfirmServiceComplete {
                    confirmButton.addTarget(self, action: #selector(AITimelineContentContainerView.confirmServiceCompleteAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                } else if viewModel.layoutType == .ConfirmOrderComplete {
                    confirmButton.addTarget(self, action: #selector(AITimelineContentContainerView.confirmOrderCompleteAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                }
                
                let buttonWidth = CustomerCenterConstants.textContent.confirmButton.sizeWithFont(CustomerCenterConstants.Fonts.TimelineButton, forWidth: 500).width + 30
                confirmButton.snp_makeConstraints(closure: { (make) in
                    make.leading.top.bottom.equalTo(buttonContainerView)
                    make.width.equalTo(buttonWidth)
                })
                buttonContainerView.snp_updateConstraints(closure: { (make) in
                    make.height.equalTo(buttonContainterHeight)
                    make.top.equalTo(imageContainerView.snp_bottom).offset(15)
                })
            //需要接受和拒绝按钮的
            case .Authoration:
                
                let acceptButton = UIButton()
                acceptButton.setBackgroundImage(acceptButtonBgColor.imageWithColor(), forState: UIControlState.Normal)
                acceptButton.setTitleColor(acceptButtonTextColor, forState: UIControlState.Normal)
                acceptButton.setTitle("授权", forState: UIControlState.Normal)
                acceptButton.setTitle("已授权", forState: UIControlState.Disabled)
                acceptButton.titleLabel?.font = CustomerCenterConstants.Fonts.TimelineButton
                acceptButton.layer.cornerRadius = buttonContainterHeight / 2
                acceptButton.layer.masksToBounds = true
                acceptButton.addTarget(self, action: #selector(AITimelineContentContainerView.acceptAuthorationAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                buttonContainerView.addSubview(acceptButton)
                acceptButton.snp_makeConstraints(closure: { (make) in
                    make.top.bottom.leading.equalTo(buttonContainerView)
                    make.width.equalTo(acceptButtonWidth)
                })
                
                
                let ignoreButton = UIButton()
                ignoreButton.setBackgroundImage(UIColor.clearColor().imageWithColor(), forState: UIControlState.Normal)
                ignoreButton.setTitleColor(acceptButtonBgColor, forState: UIControlState.Normal)
                ignoreButton.setTitle("忽略", forState: UIControlState.Normal)
                ignoreButton.titleLabel?.font = CustomerCenterConstants.Fonts.TimelineButton
                ignoreButton.layer.cornerRadius = buttonContainterHeight / 2
                ignoreButton.layer.borderWidth = 1
                ignoreButton.layer.borderColor = acceptButtonBgColor.CGColor
                ignoreButton.layer.masksToBounds = true
                ignoreButton.addTarget(self, action: #selector(AITimelineContentContainerView.refuseAuthorationAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                buttonContainerView.addSubview(ignoreButton)
                ignoreButton.snp_makeConstraints(closure: { (make) in
                    make.top.bottom.equalTo(buttonContainerView)
                    make.leading.equalTo(acceptButton.snp_trailing).offset(11)
                    make.width.equalTo(acceptButtonWidth)
                })
                
                buttonContainerView.snp_updateConstraints(closure: { (make) in
                    make.height.equalTo(buttonContainterHeight)
                    make.top.equalTo(imageContainerView.snp_bottom).offset(15)
                })
                //add by liux at 20160914 针对是否已经授权，修改按钮状态
                if viewModel.operationType == AITimelineOperationTypeEnum.confirmed {
                    acceptButton.enabled = false
                    ignoreButton.hidden = true
                } else {
                    acceptButton.enabled = true
                    ignoreButton.hidden = false

                }
            //没有按钮的
            case .Normal:
                buttonContainerView.snp_updateConstraints(closure: { (make) in
                    make.height.equalTo(0)
                    make.top.equalTo(imageContainerView.snp_bottom)
                })
            default:
                break
            }
        }
    }
    
    func buildImageContentView(url: String) -> UIImageView {
        let imageView = UIImageView()
        //imageView.contentMode = .ScaleAspectFill
        self.imageContainerView.addSubview(imageView)
        imageView.snp_makeConstraints { (make) in
            make.leading.trailing.equalTo(self.imageContainerView)
            make.height.equalTo(defaultImageHeight)
        }
        //加载图片以后根据图片高度决定约束高度
        //通过在这里赋值形成一个强引用
        let cacheModel = viewModel!
        
        imageView.sd_setImageWithURL(NSURL(string: url ), placeholderImage: CustomerCenterConstants.defaultImages.timelineImage, options: SDWebImageOptions.RetryFailed) {[weak self] (image, error, cacheType, url) in
            if image == nil {
                return
            }
            //实现了代理，才能触发reload，才需要重新计算高度，否则里面都不需要执行
            if let delegate = self?.delegate {
                let imageHeight = self?.getCompressedImageHeight(image)
                if let imageHeight = imageHeight {
                    self?.imageContainerViewHeight += imageHeight
                    imageView.snp_updateConstraints { (make) in
                        make.height.equalTo(imageHeight)
                    }
                    if self?.viewModel?.cellHeight == 0 {
                        //因为第二次进入从缓存加载图片太快，cell的第一次load还没完成就触发reload，结果展现就错乱了
                        //暂时通过加延迟的方式解决
                        Async.main(after: 0.1, block: {
                            let height = self?.getHeight()
                            if let height = height {
                                
                                delegate.containerImageDidLoad(viewModel: cacheModel, containterHeight: height)
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
        audio1.audioBg.backgroundColor = UIColor(hexString: "#18b9c3")
        imageContainerView.addSubview(audio1)
        
        imageContainerViewHeight += voiceHeight
        
        //audio1.tag = 11
        audio1.fillData(audioModel)
        audio1.snp_makeConstraints { (make) in
            make.leading.equalTo(self.imageContainerView).offset(-14)
            make.trailing.equalTo(self.imageContainerView).offset(-40 / 3)
            make.height.equalTo(voiceHeight)
        }
        audio1.smallMode()
        return audio1
    }
    
    func buildMapContentView() -> AIMapView {
        let mapView = AIMapView.sharedInstance
        imageContainerView.addSubview(mapView)
        imageContainerViewHeight += defaultMapHeight
        mapView.snp_makeConstraints { (make) in
            make.leading.trailing.equalTo(self.imageContainerView)
            make.height.equalTo(defaultMapHeight)
        }
//        if viewModel?.cellHeight == 0 {
//            if let delegate = delegate {
//                //因为第二次进入从缓存加载图片太快，cell的第一次load还没完成就触发reload，结果展现就错乱了
//                //暂时通过加延迟的方式解决
//                Async.main(after: 0.1, block: {
//                    let height = self.getHeight()
//                        delegate.containerImageDidLoad(viewModel: self.viewModel!, containterHeight: height)
//                })
//            }
//        }
        return mapView
    }
    
    //根据操作类型决定按钮文字
    private func getOperationButtonText(viewModel: AITimelineViewModel) -> String {
        var buttonText = ""
        //判断决定按钮文字
        switch viewModel.operationType! {
        case .unConfirm:
            buttonText = CustomerCenterConstants.textContent.confirmButton
        case .confirmed:
            buttonText = CustomerCenterConstants.textContent.confirmButtonComment
        case .commentted:
            buttonText = CustomerCenterConstants.textContent.confirmButtonShowComment
        }
        return buttonText
    }
    
    // MARK: -> event methods
    func confirmServiceCompleteAction(sender: UIButton) {
        if let delegate = delegate {
            delegate.confirmServiceButtonDidClick(viewModel: viewModel!)
        }
    }
    
    func confirmOrderCompleteAction(sender: UIButton) {
        if let delegate = delegate {
            delegate.confirmOrderButtonDidClick(viewModel: viewModel!)
        }
    }
    func acceptAuthorationAction(sender: UIButton) {
        if let delegate = delegate {
            delegate.acceptButtonDidClick(viewModel: viewModel!)
        }
    }
    func refuseAuthorationAction(sender: UIButton) {
        if let delegate = delegate {
            delegate.refuseButtonDidClick(viewModel: viewModel!)
        }
    }

    // MARK: -> util methods
    //通过图片的实际宽度和view宽度计算出来的压缩比例计算展现的高度
    func getCompressedImageHeight(image: UIImage) -> CGFloat {
        let compressedRate = AITimelineTableViewCell.cellWidth / image.size.width
        return image.size.height * compressedRate
    }

    //计算view高度，如果还没有loadData则返回0
    func getHeight() -> CGFloat {
        var totalHeight: CGFloat = 0
        if let viewModel = viewModel {
            switch viewModel.layoutType! {
            case AITimelineLayoutTypeEnum.Normal:
                totalHeight = imageContainerViewHeight
            case .Authoration, .ConfirmOrderComplete, .ConfirmServiceComplete:
                totalHeight = AITimelineTableViewCell.baseButtonsHeight + imageContainerViewHeight
            default: break
            }
        }
        AILog("totalHeight : \(totalHeight)")
        return totalHeight
    }
    
    /**
     根据传入的模型计算高度
     
     - returns: <#return value description#>
     */
    func getCaculateHeight() -> CGFloat {
        var totalHeight: CGFloat = 0
        if let viewModel = viewModel {
            if let contents = viewModel.contents {
                for content: AITimeContentViewModel in contents {
                    totalHeight += subViewMargin
                    switch content.contentType! {
                    case .Image, .LocationMap:
                        totalHeight += defaultImageHeight
                    case .Voice:
                        totalHeight += voiceHeight
                    }
                }
            }
            switch viewModel.layoutType! {
            case AITimelineLayoutTypeEnum.Normal:
                totalHeight += AITimelineTableViewCell.cellMargin
            case .Authoration, .ConfirmOrderComplete, .ConfirmServiceComplete:
                totalHeight += AITimelineTableViewCell.baseButtonsHeight + AITimelineTableViewCell.cellMargin * 2
            default: break
            }
        }
//        AILog("totalHeight : \(totalHeight)")
        return totalHeight
    }

}

protocol AITimelineContentContainerViewDelegate: NSObjectProtocol {
    func containerImageDidLoad(viewModel viewModel: AITimelineViewModel, containterHeight: CGFloat)
    func confirmServiceButtonDidClick(viewModel viewModel: AITimelineViewModel)
    func confirmOrderButtonDidClick(viewModel viewModel: AITimelineViewModel)
    func refuseButtonDidClick(viewModel viewModel: AITimelineViewModel)
    func acceptButtonDidClick(viewModel viewModel: AITimelineViewModel)
}
