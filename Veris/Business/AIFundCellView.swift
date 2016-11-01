//
//  AIFundCellView.swift
//  AIVeris
//
//  Created by asiainfo on 11/1/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

class AIFundCellView: UIView {
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var round: UIView!
    @IBOutlet weak var des: UILabel!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.round.layer.cornerRadius = 5
        self.round.layer.masksToBounds = true
    }
}
