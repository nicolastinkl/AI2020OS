//
//  AIBCDetailView.swift
//  AIVeris
//
//  Created by 刘先 on 16/10/25.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIBCDetailView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    var contentLabel: UILabel!
    var containerView: UIView!
    
    //MARK: -> Constants
    let CONTENT_FONT = AITools.myriadLightSemiCondensedWithSize(42.displaySizeFrom1242DesignSize())
    let CONTENT_TEXT_COLOR = UIColor(hexString: "#272727", alpha: 0.8)
    let TITLE_TEXT_COLOR = UIColor(hexString: "#272727")
    let TITLE_FONT = AITools.myriadLightSemiCondensedWithSize(56.displaySizeFrom1242DesignSize())

    static func createInstance() -> AIBCDetailView {
        let viewThis = NSBundle.mainBundle().loadNibNamed("AIBCDetailView", owner: self, options: nil)!.first  as! AIBCDetailView
        
        return viewThis
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.snp_updateConstraints { (make) in
            make.width.equalTo(contentScrollView.snp_width)
        }
    }
    
    func setupViews() {
        buildScrollView()
    }
    
    func buildScrollView() {
        containerView = UIView()
        //containerView
        containerView.backgroundColor = UIColor.clearColor()
        contentScrollView.addSubview(containerView)
        containerView.snp_makeConstraints { (make) in
            make.edges.equalTo(contentScrollView)
            make.width.equalTo(contentScrollView.snp_width)
        }
        //contentLabel
        contentLabel = UILabel()
        contentLabel.font = CONTENT_FONT
        contentLabel.textColor = CONTENT_TEXT_COLOR
        contentLabel.text = "  商家币是商家的虚拟货币。您可以使用商家币兑换部分或全部服务产品；也可以参与抽奖得到免费的商品或者现金红包，也可以进行线上线下商家的积分兑入。商家币的使用解释权归各商户所有。\n  商家币是商家的虚拟货币。您可以使用商家币兑换部分或全部服务产品；也可以参与抽奖得到免费的商品或者现金红包，也可以进行线上线下商家的积分兑入。商家币的使用解释权归各商户所有。\n  商家币是商家的虚拟货币。您可以使用商家币兑换部分或全部服务产品；也可以参与抽奖得到免费的商品或者现金红包，也可以进行线上线下商家的积分兑入。商家币的使用解释权归各商户所有。"
        contentLabel.numberOfLines = 0
        contentScrollView.addSubview(contentLabel)
        contentLabel.snp_makeConstraints { (make) in
            make.edges.equalTo(containerView).offset(0)
        }

        //titleLabel
        titleLabel.textColor = TITLE_TEXT_COLOR
        titleLabel.font = TITLE_FONT
    }

}
