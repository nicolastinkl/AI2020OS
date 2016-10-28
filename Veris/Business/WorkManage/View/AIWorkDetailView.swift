//
//  AIWorkDetailView.swift
//  AIVeris
//
//  Created by 刘先 on 8/2/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIWorkDetailView: UIView {

    //MARK: -> IB vars
    @IBOutlet weak var acceptTitleLabel: UILabel!
    @IBOutlet weak var detailScrollView: UIScrollView!
    @IBOutlet weak var showAllButton: UIButton!
    @IBOutlet weak var jobDetailTitleLabel: UILabel!
    @IBOutlet weak var acceptTermTitleLabel: UILabel!
    
    @IBOutlet weak var acceptCheckbox: UIButton!
    var contentLabel: UILabel!
    var delegate: AIWorkDetailViewDelegate?
    
    @IBAction func showAllAction(sender: UIButton) {
        
    }
    
    @IBAction func acceptAction(sender: UIButton) {
        acceptCheckbox.selected = !acceptCheckbox.selected
        if let delegate = delegate {
            delegate.acceptTerm(acceptCheckbox.selected)
        }
    }
    
    
    //MARK: -> Contants
    let QUOTE_LEFT_MARGIN = 56.displaySizeFrom1242DesignSize()
    let QUOTE_CONTENT_MARGIN = 20.displaySizeFrom1242DesignSize()
    let CONTENT_TOP_MARGIN = 56.displaySizeFrom1242DesignSize()
    
    let CONTENT_FONT = AITools.myriadLightSemiCondensedWithSize(42.displaySizeFrom1242DesignSize())
    let BUTTON_FONT = AITools.myriadLightSemiExtendedWithSize(32.displaySizeFrom1242DesignSize())
    let TERM_TITLE_FONT = AITools.myriadLightSemiExtendedWithSize(36.displaySizeFrom1242DesignSize())
    
    var workDetailModel: AIWorkOpportunityDetailViewModel? {
        didSet {
            if let workDetailModel = workDetailModel {
                contentLabel.text = workDetailModel.opportunityBusiModel?.work_desc
            }
        }
    }
    
    //MARK: -> overrides
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initSelfFromXib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    func setupViews() {
        setRoundCorner(showAllButton)
        buildScrollView()
        acceptTitleLabel.text = "AIWorkInfoViewController.descriptionInfoDesc".localized
        acceptTermTitleLabel.text = "AIWorkInfoViewController.AcceptTermsTitle".localized
        acceptTermTitleLabel.font = TERM_TITLE_FONT
        showAllButton.setTitle("AIWorkInfoViewController.ReadAll".localized, forState: .Normal)
        showAllButton.titleLabel?.font = BUTTON_FONT
    }
    
    private func buildScrollView() {
        let containerView = UIView()
        //containerView
        containerView.backgroundColor = UIColor.clearColor()
        detailScrollView.addSubview(containerView)
        containerView.snp_makeConstraints { (make) in
            make.edges.equalTo(detailScrollView)
            make.width.equalTo(self.snp_width)
        }
        //quates
        let leftQuoteImageView = UIImageView()
        leftQuoteImageView.image = UIImage(named: "yinhaoUp")
        containerView.addSubview(leftQuoteImageView)
        leftQuoteImageView.snp_makeConstraints { (make) in
            make.leading.top.equalTo(containerView).offset(QUOTE_LEFT_MARGIN)
        }
        let rightQuoteImageView = UIImageView()
        rightQuoteImageView.image = UIImage(named: "yinhaoDown")
        containerView.addSubview(rightQuoteImageView)
        rightQuoteImageView.snp_makeConstraints { (make) in
            make.trailing.bottom.equalTo(containerView).offset(-QUOTE_LEFT_MARGIN)
        }
        //contentLabel
        contentLabel = UILabel()
        contentLabel.font = CONTENT_FONT
        contentLabel.text = ""
        contentLabel.numberOfLines = 0
        contentLabel.textColor = UIColor(hexString: "#ffffff", alpha: 0.6)
        containerView.addSubview(contentLabel)
        contentLabel.snp_makeConstraints { (make) in
            make.top.equalTo(leftQuoteImageView)
            make.bottom.equalTo(rightQuoteImageView)
            make.leading.equalTo(leftQuoteImageView.snp_trailing).offset(QUOTE_CONTENT_MARGIN)
            make.trailing.equalTo(rightQuoteImageView.snp_leading).offset(-QUOTE_CONTENT_MARGIN)
        }
    }

    private func setRoundCorner(button: UIButton) {
        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
    }
}

protocol AIWorkDetailViewDelegate {
    func acceptTerm(isAccept: Bool)
}
