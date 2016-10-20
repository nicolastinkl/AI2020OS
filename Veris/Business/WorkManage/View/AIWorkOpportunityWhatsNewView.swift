//
//  AIWorkOpportunityWhatsNewView.swift
//  AIVeris
//
//  Created by zx on 10/18/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIWorkOpportunityWhatsNewView: UIView {

    var services: [AISearchServiceModel]!
    private var icons = [VerticalIconLabel]()
    
    var titleLabel: UILabel!
    
    let iconWidth = 304.displaySizeFrom1242DesignSize()
    let iconHeight = (304 + 33 + 48).displaySizeFrom1242DesignSize()
    let marginLeft = 48.displaySizeFrom1242DesignSize()
    let vSpaceBetweenIcons = 102.displaySizeFrom1242DesignSize()

    init(services: [AISearchServiceModel]) {
        super.init(frame: .zero)
        self.services = services
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        titleLabel = UILabel()
        titleLabel.font = AITools.myriadSemiCondensedWithSize(60.displaySizeFrom1242DesignSize())
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = "What's New"
        addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) in
            make.leading.equalTo(marginLeft)
            make.top.equalTo(self)
        }
        
        let count = services.count
        let hSpaceBetweenIcons = (screenWidth - marginLeft * 2 - iconWidth * 3) / 2
        for (i, service) in services.enumerate() {
            let icon = VerticalIconLabel()
            icon.imageWidth = iconWidth
            icon.font = AITools.myriadLightSemiCondensedWithSize(48.displaySizeFrom1242DesignSize())
            icon.tag = i
            icon.text = service.name
            icon.imageSpaceToLabel = 33.displaySizeFrom1242DesignSize()
            icon.imageView.sd_setImageWithURL(NSURL(string: service.icon ?? ""))
            addSubview(icon)
            icons.append(icon)
        }
        // setup icons constraints
        
        var previousView: VerticalIconLabel!
        for (i, icon) in icons.enumerate() {
            // first
            if i == 0 {
                icon.snp_makeConstraints(closure: { (make) in
                    make.width.equalTo(iconWidth)
                    make.height.equalTo(iconHeight)
                    make.leading.equalTo(marginLeft)
                    make.top.equalTo(titleLabel.snp_bottom).offset(64.displaySizeFrom1242DesignSize())
                    if i == count - 1 {
                        // last one
                        make.bottom.equalTo(self)
                    }
                })
            } else {
                
                switch i % 3 {
                case 0:
                    icon.snp_makeConstraints(closure: { (make) in
                        make.top.equalTo(previousView.snp_bottom).offset(vSpaceBetweenIcons)
                        make.width.equalTo(iconWidth)
                        make.height.equalTo(iconHeight)
                        make.leading.equalTo(marginLeft)
                        if i == count - 1 {
                            // last one
                            make.bottom.equalTo(self)
                        }
                    })
                case 1: fallthrough
                case 2:
                    icon.snp_makeConstraints(closure: { (make) in
                        make.leading.equalTo(previousView.snp_trailing).offset(hSpaceBetweenIcons)
                        make.top.height.width.equalTo(previousView)
                        if i == count - 1 {
                            // last one
                            make.bottom.equalTo(self)
                        }
                    })
                default: break
                    }
                    
            }
            previousView = icon
        }
    }
    
}
