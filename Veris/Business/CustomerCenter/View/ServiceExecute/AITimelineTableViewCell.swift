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

    // MARK: -> override methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupViews()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
        //清空subView
        for subView in imageContainerView.subviews {
            subView.removeFromSuperview()
        }
        let viewModelContentsCount = viewModel?.contents?.count
        for (index, timeContentModel) in (viewModel?.contents)!.enumerate() {
            switch timeContentModel.contentType! {
            case AITimelineContentTypeEnum.Image:
                let imageView = buildImageContentView(timeContentModel.contentUrl!)
                lastView = imageView
            case AITimelineContentTypeEnum.LocationMap: break


            case AITimelineContentTypeEnum.Voice: break


            default: break

            }

            if index == 0 {
                lastView?.snp_updateConstraints(closure: { (make) in
                    make.top.equalTo(imageContainerView)
                })
            }
            if index == viewModelContentsCount! - 1 {
                lastView?.snp_updateConstraints(closure: { (make) in
                    make.bottom.equalTo(imageContainerView)
                })
            }
        }
    }

    func buildButtonContainerView() {
        if let viewModel = viewModel {
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
        imageView.sd_setImageWithURL(NSURL(string: url))
        imageContainerView.addSubview(imageView)

        imageView.snp_makeConstraints { (make) in
            make.leading.trailing.equalTo(imageContainerView)
            make.height.equalTo(30)
        }

        return imageView
    }

    func loadData(viewModel: AITimelineViewModel) {
        self.viewModel = viewModel

        timeLabel.text = viewModel.timeModel?.time
        buildImageContainerView()
        buildButtonContainerView()
    }

}
