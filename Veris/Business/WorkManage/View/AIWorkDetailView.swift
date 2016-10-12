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
    @IBOutlet weak var checkboxImage: UIImageView!
    @IBOutlet weak var detailScrollView: UIScrollView!
    @IBOutlet weak var showAllButton: UIButton!
    @IBOutlet weak var jobDetailTitleLabel: UILabel!
    var contentLabel: UILabel!
    
    @IBAction func showAllAction(sender: UIButton) {
        
    }
    
    //MARK: -> Contants
    let QUOTE_LEFT_MARGIN = 56.displaySizeFrom1242DesignSize()
    let QUOTE_CONTENT_MARGIN = 20.displaySizeFrom1242DesignSize()
    let CONTENT_TOP_MARGIN = 56.displaySizeFrom1242DesignSize()
    let CONTENT_FONT = AITools.myriadLightSemiCondensedWithSize(48.displaySizeFrom1242DesignSize())
    
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
        contentLabel.text = "To help maintain the health of patients, instruments and Grooming: When a patient for personal reasons can not complete their own personal hygiene, organize themselves, to help their carers should be completed, such as the face, hair, oral hygiene, denture care, brush, dressing, to assist the use the potty or toilet, potty and so on. To help patients meet the nutritional needs such as feeding, water, meals and other assistance. Safeguard patient safety: to help the patient get out.To help maintain the health of patients, instruments and Grooming: When a patient for personal reasons can not complete their own personal hygiene, organize themselves, to help their carers should be completed, such as the face, hair, oral hygiene, denture care, brush, dressing, to assist the use the potty or toilet, potty and so on. To help patients meet the nutritional needs such as feeding, water, meals and other assistance. Safeguard patient safety: to help the patient get out.To help maintain the health of patients, instruments and Grooming: When a patient for personal reasons can not complete their own personal hygiene, organize themselves, to help their carers should be completed, such as the face, hair, oral hygiene, denture care, brush, dressing, to assist the use the potty or toilet, potty and so on. To help patients meet the nutritional needs such as feeding, water, meals and other assistance. Safeguard patient safety: to help the patient get out.To help maintain the health of patients, instruments and Grooming: When a patient for personal reasons can not complete their own personal hygiene, organize themselves, to help their carers should be completed, such as the face, hair, oral hygiene, denture care, brush, dressing, to assist the use the potty or toilet, potty and so on. To help patients meet the nutritional needs such as feeding, water, meals and other assistance. Safeguard patient safety: to help the patient get out."
        contentLabel.numberOfLines = 0
        contentLabel.textColor = UIColor.whiteColor()
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
