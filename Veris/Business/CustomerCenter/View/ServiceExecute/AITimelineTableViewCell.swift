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
    
    @IBOutlet weak var timelineContentContainterView: UIView!
    @IBOutlet weak var dateLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeContentLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    var viewModel: AITimelineViewModel?
    var imageContainerViewHeight: CGFloat = 0
    var delegate: AITimelineTableViewCellDelegate?
    var needComputeHeight = true
    var timelineContentView: AITimelineContentContainerView?
    
    // MARK: -> static constants
    static let cellWidth = UIScreen.mainScreen().bounds.width - AITools.displaySizeFrom1242DesignSize(220)
    static let baseTimelineContentLabelHeight: CGFloat = 40
    static let cellMargin: CGFloat = 20
    static let subViewMargin: CGFloat = 11
    static let baseButtonsHeight: CGFloat = 26

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
        self.clipsToBounds = true
    }

    
    func loadData(viewModel: AITimelineViewModel, delegate: AITimelineContentContainerViewDelegate) {
        self.viewModel = viewModel

        timeLabel.text = viewModel.timeModel?.time
        timeContentLabel.text = viewModel.desc
        
        //处理是否显示天数
        if let timeModel = viewModel.timeModel {
            if timeModel.shouldShowDate {
                dateLabelTopConstraint.constant = 5
            } else {
                dateLabelTopConstraint.constant = -20
            }
        }
        dateLabel.text = viewModel.timeModel?.date
        
        for subView in timelineContentContainterView.subviews {
            subView.removeFromSuperview()
        }
        timelineContentView = AITimelineContentContainerView(viewModel: viewModel, delegate: delegate)
        timelineContentContainterView.addSubview(timelineContentView!)
        timelineContentView!.snp_makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalTo(timelineContentContainterView)
        }
    }
    
    
    // MARK: -> util methods
    //通过图片的实际宽度和view宽度计算出来的压缩比例计算展现的高度
    func getCompressedImageHeight(image: UIImage) -> CGFloat {
        let compressedRate = AITimelineTableViewCell.cellWidth / image.size.width
        return image.size.height * compressedRate
    }
    
    //计算view高度，如果还没有loadData则返回0
    func getHeight(containerHeight: CGFloat) -> CGFloat {
        var totalHeight: CGFloat = 0
        if let viewModel = viewModel {
            switch viewModel.layoutType! {
            case AITimelineLayoutTypeEnum.Normal:
                totalHeight = AITimelineTableViewCell.baseTimelineContentLabelHeight + AITimelineTableViewCell.cellMargin + containerHeight
            case .Authoration, .ConfirmOrderComplete, .ConfirmServiceComplete:
                totalHeight = AITimelineTableViewCell.baseTimelineContentLabelHeight + AITimelineTableViewCell.subViewMargin + containerHeight
            default: break
            }
            if viewModel.timeModel?.shouldShowDate == true {
                totalHeight += 25
            }
        }
        AILog("totalHeight : \(totalHeight)")
        return totalHeight
    }
    
    class func caculateHeightWidthData(viewModel: AITimelineViewModel) -> CGFloat {
        var totalHeight: CGFloat = 0
        switch viewModel.layoutType! {
        case AITimelineLayoutTypeEnum.Normal:
            totalHeight = baseTimelineContentLabelHeight + cellMargin
        case .Authoration, .ConfirmOrderComplete, .ConfirmServiceComplete:
            totalHeight = baseTimelineContentLabelHeight + subViewMargin + baseButtonsHeight + cellMargin
        default: break
        }
        if viewModel.timeModel?.shouldShowDate == true {
            totalHeight += 25
        }
        return totalHeight
    }
}

protocol AITimelineTableViewCellDelegate: AITimelineContentContainerViewDelegate {
    func cellImageDidLoad(viewModel viewModel: AITimelineViewModel, cellHeight: CGFloat)
}
