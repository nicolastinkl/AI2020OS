//
//  AIJobTableViewCell.swift
//  AIVeris
//
//  Created by 王坜 on 16/8/10.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit


protocol AIJobTableViewCellDelegate: class {
    func didTriggerJobActionToUploadStateParams(params: [String : AnyObject])
    func didTriggerJobActionToUploadInformation()
}

class AIJobTableViewCell: UITableViewCell {

    //MARK: Public

    weak var actionDelegate: AIJobTableViewCellDelegate?
    var curDataModel: AISubscribledJobModel!
    //MARK: Constants

    private let kCellMargin = 80.displaySizeFrom1242DesignSize()
    private let kIconMargin: CGFloat = 20.displaySizeFrom1242DesignSize()
    private let kStatusVerticalMargin: CGFloat = 56.displaySizeFrom1242DesignSize()
    private let kStatusHorizontalMarin: CGFloat = 95.displaySizeFrom1242DesignSize()
    private let kIconSize: CGFloat = 58.displaySizeFrom1242DesignSize()
    private let kDescriptionFontSize = 60.displaySizeFrom1242DesignSize()
    private let kCellWidth = UIScreen.mainScreen().bounds.size.width
    private let kTopViewHeight = 98.displaySizeFrom1242DesignSize()
    private let kContentWidth = UIScreen.mainScreen().bounds.size.width - 80.displaySizeFrom1242DesignSize()
    private let kRightSideMargin = 35.displaySizeFrom1242DesignSize()

    // Bottom
    private let kBottomViewHeight = 297.displaySizeFrom1242DesignSize()
    private let kBottomLabelWidth = (UIScreen.mainScreen().bounds.size.width - 95.displaySizeFrom1242DesignSize()) / 2
    private let kBottomIconSize = 42.displaySizeFrom1242DesignSize()
    private let kBottomLabelFontSize = 42.displaySizeFrom1242DesignSize()
    private let kBottomIcomMargin = 12.displaySizeFrom1242DesignSize()




    //MARK: Public Property
    var jobIconView: UIImageView!

    var jobDescriptionLabel: UPLabel!

    var jobActionButton: UIButton!

    private var topView: UIView!

    // TopView 

    var stateIconView: UIImageView!
    var gradientLayer: CAGradientLayer!

    // Bottom View
    private var bottomView: UIView!

    private var subscribledTimeLabel: UPLabel!

    private var jobDescLabel: UPLabel!

    private var statusLabel: UPLabel!

    private var subscribledTimeImageView: UIImageView!

    private var jobDescImageview: UIImageView!

    private var statusImageView: UIImageView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.backgroundColor = UIColor.clearColor()
        self.selectionStyle = .None
        makeSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        resetContentView()
    }


    func resetContentView() {
        let x = (CGRectGetWidth(self.contentView.frame) - kContentWidth) / 2
        self.contentView.frame = CGRect(x: x, y: 0, width: kContentWidth, height: kTopViewHeight + kBottomViewHeight)
        self.contentView.layer.cornerRadius = 8
        self.contentView.clipsToBounds = true
        self.contentView.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
    }
    //MARK: Constructure
    func makeSubViews() {


        makeTopView()
        makeBottomView()
    }

    // MARK: Top View

    func makeTopView() {
        let frame = CGRect(x: 0, y: 0, width: kContentWidth, height: kTopViewHeight)
        topView = UIView(frame: frame)
        topView.backgroundColor = UIColor(white: 0.1, alpha: 0.2)

        self.contentView.addSubview(topView)

        makeJobIcon()
        makeJobDescription()
    }


    func makeGradientColorForTopView() {
        if let curDataModel = curDataModel {
            switch curDataModel.work_state {
            case "0": // 资料不齐
                makeGradientColorsForView(topView, lightColor: AITools.colorWithHexString("b32b1d"), darkColor: UIColor.clearColor())
                makeStateIcon("Job_Question")
                break
            case "1": // 接单中
                makeGradientColorsForView(topView, lightColor: AITools.colorWithHexString("41ac3d"), darkColor: UIColor.clearColor())
                makeStateIcon("Job_Oneline")
                break
            case "2": // 休息中
                makeGradientColorsForView(topView, lightColor: AITools.colorWithHexString("ff8e1f"), darkColor: UIColor.clearColor())
                makeStateIcon("Job_Offline")
                break
            default:
                break
            }
        }
    }

    func makeGradientColorsForView(view: UIView, lightColor: UIColor, darkColor: UIColor) {

        if let layer = gradientLayer {
            layer.removeFromSuperlayer()
        }

        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [lightColor.CGColor, darkColor.CGColor]
        let width = 422.displaySizeFrom1242DesignSize()
        let height = CGRectGetHeight(topView.frame)
        let x = CGRectGetWidth(topView.frame) - width
        gradientLayer.frame = CGRect(x: x, y: 0, width: width, height: height)
        gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)

        topView.layer.insertSublayer(gradientLayer, atIndex: 0)
    }


    func makeStateIcon(iconName: String) {

        if stateIconView == nil {
            let width = 59.displaySizeFrom1242DesignSize()
            let height = 54.displaySizeFrom1242DesignSize()
            let x = CGRectGetWidth(topView.frame) - width - kRightSideMargin
            let y = (kTopViewHeight - height) / 2

            let iconFrame = CGRect(x: x, y: y, width: width, height: height)
            stateIconView = UIImageView(frame: iconFrame)
        }

        stateIconView.image = UIImage(named: iconName)

        topView.addSubview(stateIconView)
    }

    func makeJobIcon() {
        jobIconView = UIImageView(frame: CGRect(x: kIconMargin, y: kIconMargin, width: kIconSize, height: kIconSize))
        topView.addSubview(jobIconView)
    }

    func makeJobDescription() {
        let x = CGRectGetMaxX(jobIconView!.frame) + kIconMargin
        let width: CGFloat = 300
        jobDescriptionLabel = AIViews.normalLabelWithFrame( CGRect(x: x, y: kIconMargin, width: width, height: kDescriptionFontSize), text: "", fontSize: kDescriptionFontSize, color: UIColor.whiteColor())
        topView.addSubview(jobDescriptionLabel)
    }




    //MARK: Bottom View

    func makeBottomView() {
        let y = CGRectGetMaxY(topView.frame)
        let frame = CGRect(x: 0, y: y, width: kContentWidth, height: kBottomViewHeight)
        bottomView = UIView(frame: frame)
        self.contentView.addSubview(bottomView)
        bottomView.backgroundColor = UIColor(white: 0.5, alpha: 0.4)
        //

        makeSubscribledTimeView()
        makeServedConsumerView()
        makeStatusView()
        makeJobActionButton()
    }

    func makeJobActionButton() {
        let width = 349.displaySizeFrom1242DesignSize()
        let height = 74.displaySizeFrom1242DesignSize()
        let x = kContentWidth - width - kRightSideMargin
        let y = (kBottomViewHeight - height) / 2
        let frame = CGRect(x: x, y: y, width: width, height: height)
        jobActionButton = AIViews.baseButtonWithFrame(frame, normalTitle: "")
        jobActionButton.layer.cornerRadius = height / 2
        jobActionButton.layer.masksToBounds = true
        jobActionButton.layer.borderWidth = 1
        jobActionButton.layer.borderColor = UIColor.whiteColor().CGColor
        jobActionButton.titleLabel?.font = AITools.myriadSemiCondensedWithSize(40.displaySizeFrom1242DesignSize())
        jobActionButton.addTarget(self, action: #selector(AIJobTableViewCell.jobAction), forControlEvents: .TouchUpInside)
        jobActionButton.alpha = curDataModel == nil ? 0 : 1
        bottomView.addSubview(jobActionButton)
    }

    // Button Action
    func jobAction() {
        switch curDataModel.work_state {
        case "0": // 资料不齐
            actionDelegate?.didTriggerJobActionToUploadInformation()
            break
        case "1": // 接单中
            actionDelegate?.didTriggerJobActionToUploadStateParams(["work_id" : curDataModel.work_id, "work_state": curDataModel.work_state])
            break
        case "2": // 休息中
            actionDelegate?.didTriggerJobActionToUploadStateParams(["work_id" : curDataModel.work_id, "work_state": curDataModel.work_state])
            break
        default:
            break

        }
    }

    func makeCommonDescView(iconName: String, descText: String, originalY: CGFloat) -> (UIImageView, UPLabel) {


        var x = kStatusHorizontalMarin

        let iconFrame = CGRect(x: x, y: originalY, width: kBottomIconSize, height: kBottomIconSize)
        let imageView = UIImageView(image: UIImage(named: iconName))
        imageView.frame = iconFrame

        x += kBottomIcomMargin + kBottomIconSize

        let frame = CGRect(x: x, y: originalY, width: kBottomLabelWidth, height: kBottomLabelFontSize)
        let label: UPLabel = AIViews.normalLabelWithFrame(frame, text: descText, fontSize: kBottomLabelFontSize, color: UIColor.whiteColor())


        return (imageView, label)
    }

    func makeSubscribledTimeView() {

        let (imageView, label) = makeCommonDescView("", descText: "", originalY: kStatusVerticalMargin)
        bottomView.addSubview(imageView)
        bottomView.addSubview(label)

        subscribledTimeImageView = imageView
        subscribledTimeLabel = label
    }


    func makeServedConsumerView() {

        let y = CGRectGetMaxY(subscribledTimeLabel.frame) + 27.displaySizeFrom1242DesignSize()
        let (imageView, label) = makeCommonDescView("", descText: "", originalY: y)
        bottomView.addSubview(imageView)
        bottomView.addSubview(label)

        jobDescImageview = imageView
        jobDescLabel = label
    }


    func makeStatusView() {
        let y = CGRectGetMaxY(jobDescLabel.frame) + 27.displaySizeFrom1242DesignSize()
        let (imageView, label) = makeCommonDescView("", descText: "", originalY: y)
        bottomView.addSubview(imageView)
        bottomView.addSubview(label)

        statusImageView = imageView
        statusLabel = label

    }




    //MARK: Reset Cell

    func jobDescImage(state: String) -> UIImage {
        switch state {
        case "0": // 资料不齐
            return UIImage(named: "Job_Question")!
        case "1": // 接单中
            return UIImage(named: "Job_Corperation")!
        case "2": // 休息中
            return UIImage(named: "Job_Corperation")!

        default:
            return UIImage(named: "Job_Question")!
        }
    }


    func jobDesc(desc: String, state: String) -> String {

        switch state {
        case "0": // 资料不齐
            return "AIWorkManageViewController.NeedUpload".localized
        case "1": // 接单中
            return String(format: "AIWorkManageViewController.ServedFormat".localized, desc)
        case "2": // 休息中
            return String(format: "AIWorkManageViewController.ServedFormat".localized, desc)

        default:
            return "AIWorkManageViewController.NeedUpload".localized
        }

    }

    func statusImage(state: String) -> UIImage {
        switch state {
        case "0": // 资料不齐
            return UIImage(named: "Job_Earn")!
        case "1": // 接单中
            return UIImage(named: "Job_Oneline")!
        case "2": // 休息中
            return UIImage(named: "Job_Offline")!

        default:
            return UIImage(named: "Job_Question")!
        }
    }

    func statusText(state: String, model: AISubscribledJobModel) -> String {
        switch state {
        case "0": // 资料不齐
            return String(format: "AIWorkManageViewController.OnlineCountFormat".localized, model.online_count ?? "")
        case "1": // 接单中
            return String(format: "AIWorkManageViewController.OnlineTimeFormat".localized, model.online_date ?? "")
        case "2": // 休息中
            return String(format: "AIWorkManageViewController.OfflineTimeFormat".localized, model.offline_date ?? "")

        default:
            return "AIWorkManageViewController.NeedUpload".localized
        }

    }

    func jobActionTitle(state: String) -> String {
        switch state {
        case "0": // 资料不齐
            return "AIWorkManageViewController.UploadInformationTitle".localized
        case "1": // 接单中
            return "AIWorkManageViewController.GoOfflineTitle".localized
        case "2": // 休息中
            return "AIWorkManageViewController.GoOnlineTitle".localized

        default:
            return "..."
        }
    }

    func formatedDate(date: String) -> String {
        return ""
    }

    func resetCellModel(model: AISubscribledJobModel) {
        curDataModel = model
        makeGradientColorForTopView()
        // title
        jobIconView.sd_setImageWithURL(NSURL(string:model.work_thumbnail), placeholderImage: UIImage(named: "defaultIcon"))
        jobDescriptionLabel.text = model.work_name
        // line1

        subscribledTimeImageView.image = UIImage(named: "Job_Subscrible")
        subscribledTimeLabel.text = String(format: "AIWorkManageViewController.SubscribledTimeFormat".localized, model.subscribed_date)

        // line2
        jobDescImageview.image = jobDescImage(model.work_state)
        jobDescLabel.text = jobDesc(model.service_counts, state: model.work_state)

        // line3
        statusImageView.image = statusImage(model.work_state)
        statusLabel.text = statusText(model.work_state, model: model)

        // button
        jobActionButton.setTitle(jobActionTitle(model.work_state), forState: .Normal)
        jobActionButton.alpha = 1
    }


}
