//
//  AIJobTableViewCell.swift
//  AIVeris
//
//  Created by 王坜 on 16/8/10.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIJobTableViewCell: UITableViewCell {
    //MARK: Constants

    let IconMargin: CGFloat = 15
    let StatusVerticalMargin: CGFloat = 25
    let StatusHorizontalMarin: CGFloat = 35
    let IconSize: CGFloat = 60.displaySizeFrom1242DesignSize()
    let DescriptionFontSize = 60.displaySizeFrom1242DesignSize()

    //MARK: Public Property
    var jobIconView: UIImageView?

    var jobDescriptionLabel: UPLabel?

    var jobActionButton: UIButton?


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.backgroundColor = UIColor.clearColor()

        makeSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Constructure
    func makeSubViews() {
        makeJobIcon()
        makeJobDescription()
    }


    func makeJobIcon() {
        jobIconView = UIImageView(frame: CGRect(x: IconMargin, y: IconMargin, width: IconSize, height: IconSize))
        self.contentView.addSubview(jobIconView!)
    }

    func makeJobDescription() {
        let x = CGRectGetMaxX(jobIconView!.frame) + IconMargin
        let width = CGRectGetHeight(self.contentView.bounds) - x - IconMargin
        jobDescriptionLabel = AIViews.normalLabelWithFrame( CGRect(x: x, y: IconMargin, width: width, height: DescriptionFontSize), text: "", fontSize: DescriptionFontSize, color: UIColor.whiteColor())
        self.contentView.addSubview(jobDescriptionLabel!)
    }


    func resetCellModel(model: AIJobSurveyModel) {

        jobIconView?.sd_setImageWithURL(NSURL(string: model.jobIcon!), placeholderImage: nil)
        jobDescriptionLabel?.text = model.jobDescription
    }


}
