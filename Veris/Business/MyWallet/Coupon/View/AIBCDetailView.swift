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
    
    func setupViews() {
        buildScrollView()
    }
    
    func buildScrollView() {
        let containerView = UIView()
        //containerView
        containerView.backgroundColor = UIColor.clearColor()
        contentScrollView.addSubview(containerView)
        containerView.snp_makeConstraints { (make) in
            make.edges.equalTo(contentScrollView)
            make.width.equalTo(self.snp_width)
        }
        //contentLabel
        contentLabel = UILabel()
        contentLabel.font = CONTENT_FONT
        contentLabel.textColor = CONTENT_TEXT_COLOR
        contentLabel.text = "四姑娘山长年被冰雪覆盖，四季有雪。因其有四座美丽的山峰相连，最高最美的那座山峰就是第四峰，故称四姑娘山。从北到南分别为四姑娘山、巴郎山，有很多个景点双桥沟、长坪沟、海子沟都可以进山，门票60-80不等,双桥沟可以做观光大巴直达山上摸雪，海子沟只能徒步或是骑马到第二峰，第二峰脚下有个海子，都挺美的。只要是晴天，沿途随时可见四姑娘山美丽的面容，山下遍地野花、山上白雪皑皑，天空蓝的很不真实，变幻万千的云雾很是震撼人心"
        contentLabel.numberOfLines = 0
        contentScrollView.addSubview(contentLabel)
        contentLabel.snp_makeConstraints { (make) in
            make.edges.equalTo(containerView)
        }

        //titleLabel
        titleLabel.textColor = TITLE_TEXT_COLOR
        titleLabel.font = TITLE_FONT
    }

}
