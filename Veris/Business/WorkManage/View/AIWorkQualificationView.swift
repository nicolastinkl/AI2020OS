//
//  AIWorkQualificationView.swift
//  AIVeris
//
//  Created by 刘先 on 8/9/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit
import iCarousel

class AIWorkQualificationView: UIView {
    
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var carousel: iCarousel!
    @IBOutlet weak var imageTitleLabel: UILabel!
    
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
        setRoundCorner(switchButton)
    }
    
    private func setRoundCorner(button: UIButton) {
        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
    }

}
