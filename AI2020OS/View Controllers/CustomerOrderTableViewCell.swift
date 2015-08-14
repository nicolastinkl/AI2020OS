//
//  CustomerOrderTableViewCell.swift
//  AI2020OS
//
//  Created by 刘先 on 15/8/12.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class CustomerOrderTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupLayer(){
        if let customerIconImg = self.viewWithTag(140) as? UIImageView{
            var layer = customerIconImg.layer
            layer.cornerRadius = 15
            layer.masksToBounds = true
        }
    }
    
}
