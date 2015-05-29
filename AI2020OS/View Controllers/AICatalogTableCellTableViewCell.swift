//
//  AICatalogTableCellTableViewCell.swift
//  AI2020OS
//
//  Created by admin on 15/5/28.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AICatalogTableCellTableViewCell: UITableViewCell {


    // MARK: swift controls
    @IBOutlet weak var showIcon: UIView!
    @IBOutlet weak var catalogName: UILabel!
    @IBOutlet weak var trailLine: UIView!
    
    var name :String! {
        get {
            return catalogName.text
        }
        
        set(name) {
            catalogName.text = name
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
        setColor(selected)
   
    }
    
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        setColor(highlighted)
    }
    
    // MARK: private methods
    private func setColor(seletced: Bool) {
        if selected {
            showIcon.hidden = false
            trailLine.hidden = true
            showIcon.backgroundColor = UIColor(rgba: "#03C7B8")
            catalogName.backgroundColor =  UIColor.whiteColor()
        } else {
            showIcon.hidden = true
            trailLine.hidden = false
            trailLine.backgroundColor = UIColor(rgba: "#D2D3D6")
            catalogName.backgroundColor =  UIColor(rgba: "#EFF1F4")
        }
    }
    
}
