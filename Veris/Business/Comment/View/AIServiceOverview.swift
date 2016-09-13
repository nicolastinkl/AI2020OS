//
//  AIServiceOverview.swift
//  AIVeris
//
//  Created by 王坜 on 16/8/17.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

public enum ServiceOverviewType {
    case ServiceOverviewTypeSingalLast
    case ServiceOverviewTypeSingalFresh
    case ServiceOverviewTypeGroup
}

class AIServiceOverview: UIView {


    //MARK: Constants

    var Margin: CGFloat!


    //MARK: Properties
    var overviewType: ServiceOverviewType!
    var serviceModel: AICommentSeviceModel!
    var serviceIcon: UIImageView!
    var serviceDescription: UPLabel!
    var iconSize: CGFloat!
    var descriptionWidth: CGFloat!
    var fontSize: CGFloat!
    var textColor: UIColor!

    //MARK: init

    init(frame: CGRect, service: AICommentSeviceModel, type: ServiceOverviewType) {
        super.init(frame: frame)
        serviceModel = service
        overviewType = type
        makeProperties()
        makeServiceIcon()
        makeServiceDescription()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Functions

    func makeProperties() {
        iconSize = CGRectGetHeight(self.frame)
        switch overviewType as ServiceOverviewType {
        case ServiceOverviewType.ServiceOverviewTypeSingalLast:
            Margin = 20.displaySizeFrom1242DesignSize()
            fontSize = 48.displaySizeFrom1242DesignSize()
            textColor = AITools.colorWithR(0xfe, g: 0xfe, b: 0xfe)
            break

        case ServiceOverviewType.ServiceOverviewTypeSingalFresh:
            Margin = 28.displaySizeFrom1242DesignSize()
            fontSize = 60.displaySizeFrom1242DesignSize()
            textColor = AITools.colorWithR(0xff, g: 0xff, b: 0xff)
            break

        case ServiceOverviewType.ServiceOverviewTypeGroup:
            Margin = 20.displaySizeFrom1242DesignSize()
            fontSize = 48.displaySizeFrom1242DesignSize()
            textColor = AITools.colorWithR(0xfe, g: 0xfe, b: 0xfe)
            break

        }

        descriptionWidth = CGRectGetWidth(frame) - iconSize - Margin
    }


    func makeServiceIcon() {

        let imageName = serviceModel.serviceIcon ?? "default"
        let url = NSURL(string: imageName)
        let frame = CGRect(x: 0, y: 0, width: iconSize, height: iconSize)
        serviceIcon = UIImageView(frame: frame)
        serviceIcon.sd_setImageWithURL(url, placeholderImage: nil)
        serviceIcon.layer.cornerRadius = iconSize / 2
        serviceIcon.layer.masksToBounds = true
        self.addSubview(serviceIcon)
    }

    func makeServiceDescription() {

        let x = CGRectGetMaxX(serviceIcon.frame) + Margin
        let desFrame = CGRect(x: x, y: 0, width: descriptionWidth, height: iconSize)
        serviceDescription = AIViews.wrapLabelWithFrame(desFrame, text: serviceModel.serviceName, fontSize: fontSize, color: textColor)
        self.addSubview(serviceDescription)
    }

    func resizeSelf() {
        var frame = self.frame
        frame.size.height = iconSize
        self.frame = frame
    }

}
