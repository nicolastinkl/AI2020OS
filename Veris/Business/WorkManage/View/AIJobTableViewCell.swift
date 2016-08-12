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

    let cellMargin = 80.displaySizeFrom1242DesignSize()
    let IconMargin: CGFloat = 20.displaySizeFrom1242DesignSize()
    let StatusVerticalMargin: CGFloat = 50.displaySizeFrom1242DesignSize()
    let StatusHorizontalMarin: CGFloat = 90.displaySizeFrom1242DesignSize()
    let IconSize: CGFloat = 60.displaySizeFrom1242DesignSize()
    let DescriptionFontSize = 60.displaySizeFrom1242DesignSize()
    let cellWidth = UIScreen.mainScreen().bounds.size.width
    let topViewHeight = 40.displaySizeFrom1242DesignSize() + 60.displaySizeFrom1242DesignSize()
    let bottomViewHeight = 200.displaySizeFrom1242DesignSize()

    //MARK: Public Property
    var jobIconView: UIImageView!

    var jobDescriptionLabel: UPLabel!

    var jobActionButton: UIButton!

    var topView: UIView!

    var bottomView: UIView!


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.backgroundColor = UIColor.clearColor()

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
        self.contentView.frame = CGRect(x: IconMargin, y: 0, width: cellWidth-IconMargin*2, height: topViewHeight + bottomViewHeight)
        self.contentView.layer.cornerRadius = 4
        self.contentView.clipsToBounds = true
        self.contentView.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
    }
    //MARK: Constructure
    func makeSubViews() {


        makeTopView()
        makeBottomView()
    }


    func makeTopView() {
        let frame = CGRect(x: 0, y: 0, width: cellWidth-IconMargin*2, height: topViewHeight)
        topView = UIView(frame: frame)
        topView.backgroundColor = UIColor(white: 0.1, alpha: 0.15)

        self.contentView.addSubview(topView)

        makeJobIcon()
        makeJobDescription()
    }

    func makeBottomView() {
        let frame = CGRect(x: 0, y: 0, width: cellWidth, height: bottomViewHeight)
        bottomView = UIView(frame: frame)
        self.contentView.addSubview(bottomView)
    }



    func makeJobIcon() {
        jobIconView = UIImageView(frame: CGRect(x: IconMargin, y: IconMargin, width: IconSize, height: IconSize))
        topView.addSubview(jobIconView)
    }

    func makeJobDescription() {
        let x = CGRectGetMaxX(jobIconView!.frame) + IconMargin
        let width: CGFloat = 300
        jobDescriptionLabel = AIViews.normalLabelWithFrame( CGRect(x: x, y: IconMargin, width: width, height: DescriptionFontSize), text: "", fontSize: DescriptionFontSize, color: UIColor.whiteColor())
        topView.addSubview(jobDescriptionLabel)
    }


    func resetCellModel(model: AIJobSurveyModel) {
        jobIconView.sd_setImageWithURL(NSURL(string: model.jobIcon!), placeholderImage: UIImage(named: "defaultIcon"))
        jobDescriptionLabel.text = model.jobDescription
    }


}
