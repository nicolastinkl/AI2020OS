//
//  OrderAndBuyerInfoView.swift
//  AIVeris
//
//  Created by Rocky on 16/3/9.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AITimelineTopView: UIView {

    //var delegate: OrderAndBuyerInfoViewDelegate?

    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var messageNumber: UILabel!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var serviceDesc: UILabel!
    @IBOutlet weak var percentageNumber: UILabel!
    @IBOutlet weak var progressBar: YLProgressBar!

    static func createInstance() -> AITimelineTopView {
        let viewThis = NSBundle.mainBundle().loadNibNamed("AITimelineTopView", owner: self, options: nil).first  as! AITimelineTopView

        return viewThis
    }

    var model: AICustomerOrderDetailTopViewModel? {
        didSet {
            if let m = model {

                if let name = m.serviceName {
                    serviceName.text = name
                }
                if let service = m.serviceDesc {
                    serviceDesc.text = service
                }
                setProgress(m.completion != nil ? CGFloat(m.completion!) : 0)
                price.text = m.price != nil ? m.price! : "0"
                if let number = m.messageNumber {
                    if number > 0 {
                        messageNumber.hidden = false
                        messageNumber.text = String(number)
                    } else {
                        messageNumber.hidden = true
                    }
                }
                if let serviceIconString = m.serviceIcon {
                    serviceIcon.sd_setImageWithURL(NSURL(string: serviceIconString))
                }
            }
        }
    }

    override func awakeFromNib() {

        messageNumber.layer.cornerRadius = messageNumber.frame.width / 2
        messageNumber.layer.masksToBounds = true
        let offSet: CGFloat = 4
        serviceName.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(68))
        price.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(70))
        messageNumber.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(40-offSet))
        serviceDesc.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(36))
        percentageNumber.font = AITools.myriadLightWithSize(AITools.displaySizeFrom1242DesignSize(36))

        let barColors = [UIColor(hex: "#0b82c5"), UIColor(hex: "#10c2dd")]
        progressBar.progressTintColors = barColors


        serviceIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(OrderAndBuyerInfoView.buyerIconClicked(_:))))
    }

    func setProgress(progress: CGFloat) {
        progressBar.setProgress(progress, animated: true)


        let percentage: Int = Int(progress * 100 + CGFloat(0.5))
        percentageNumber.text = NSString(format: "%d%%", percentage) as String
    }


    func buyerIconClicked(sender: UIGestureRecognizer) {
        //delegate?.buyerIconClicked?()
    }

}

//@objc protocol OrderAndBuyerInfoViewDelegate {
//    optional func buyerIconClicked()
//}
