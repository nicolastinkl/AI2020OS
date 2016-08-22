//
//  AIServiceOverview.swift
//  AIVeris
//
//  Created by 王坜 on 16/8/17.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIServiceOverview: UIView {

    //MARK: Constants

    let Margin: CGFloat = 28.displaySizeFrom1242DesignSize()


    //MARK: Properties

    var serviceModel: AICommentSeviceModel!
    var serviceIcon: UIImageView!
    var serviceDescription: UPLabel!
    var iconSize: CGFloat!
    var descriptionWidth: CGFloat!


    //MARK: init

    init(frame: CGRect, service: AICommentSeviceModel) {
        super.init(frame: frame)
        serviceModel = service
        makeProperties()
        makeServiceIcon()
        makeServiceDescription()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Functions

    func makeProperties() {
        iconSize =  CGRectGetHeight(frame)
        descriptionWidth = CGRectGetWidth(frame) - iconSize - Margin
    }


    func makeServiceIcon() {

        let imageName = serviceModel.serviceIcon ?? "default"
        let url = NSURL(string: imageName)
        let frame = CGRect(x: 0, y: 0, width: iconSize, height: iconSize)
        serviceIcon = UIImageView(frame: frame)
        serviceIcon.frame = frame
        serviceIcon.backgroundColor = UIColor.redColor()
        serviceIcon.sd_setImageWithURL(url, placeholderImage: nil)
        self.addSubview(serviceIcon)
    }

    func makeServiceDescription() {
        let x = CGRectGetWidth(frame) - descriptionWidth
        let desFrame = CGRect(x: x, y: 0, width: descriptionWidth, height: iconSize)
        serviceDescription = AIViews.wrapLabelWithFrame(desFrame, text: serviceModel.serviceName, fontSize: 60.displaySizeFrom1242DesignSize(), color: UIColor.whiteColor())
        self.addSubview(serviceDescription)
    }

}
