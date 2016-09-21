//
//  AITimelineNowTableViewCell.swift
//  AIVeris
//
//  Created by 刘先 on 16/7/5.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AITimelineNowTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var nowLabel: UILabel!
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupViews()
    }
    
    func setupViews() {
        dotView.backgroundColor = UIColor(hexString: "#ffffff")
        dotView.layer.cornerRadius = dotView.height / 2
        dotView.layer.masksToBounds = true
        dotView.layer.borderColor = UIColor(hexString: "#000000", alpha: 0.15).CGColor
        dotView.layer.borderWidth = 2
        let nowDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        timeLabel.text = dateFormatter.stringFromDate(nowDate)
        timeLabel.font = AITools.myriadSemiCondensedWithSize(40.displaySizeFrom1242DesignSize())
    }
    
}
