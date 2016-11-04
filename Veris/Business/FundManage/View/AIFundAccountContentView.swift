//
//  AIFundAccountContentView.swift
//  
//
//  Created by zx on 11/3/16.
//
//

import UIKit

class AIFundAccountContentView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var fakeData: [String: UIColor] = [
        "招商银行": UIColor(hexString: "#b6241e", alpha: 0.2),
        "建设银行": UIColor(hexString: "#136fcb", alpha: 0.2),
        "支付宝": UIColor(hexString: "#17b1ef", alpha: 0.2)
    ]
    
    var imageName: String? {
        didSet {
            imageView.image = UIImage(named: imageName ?? "")
        }
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var subtitle: String? {
        didSet {
            subtitleLabel.text = subtitle
            if let key = subtitle {
                backgroundColor = fakeData[key]
            }
        }
    }
    
    var detail: String? {
        didSet {
            detailLabel.text = detail
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
        layer.cornerRadius = 10
        titleLabel.font = AITools.myriadRegularWithSize(52.displaySizeFrom1242DesignSize())
        titleLabel.textColor = UIColor.whiteColor()
    
        subtitleLabel.font = AITools.myriadRegularWithSize(48.displaySizeFrom1242DesignSize())
        subtitleLabel.textColor = UIColor(hexString: "#ffffff", alpha: 0.6)
        
        detailLabel.font = AITools.myriadSemiCondensedWithSize(60.displaySizeFrom1242DesignSize())
        detailLabel.textColor = UIColor(hexString: "#ffffff", alpha: 0.8)
        
    }

}
