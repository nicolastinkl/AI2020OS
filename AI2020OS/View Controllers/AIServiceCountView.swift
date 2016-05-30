//
//  AIServiceCountView.swift
//  AI2020OS
//
//  Created by admin on 8/21/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIServiceCountView : UIView {
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var silderView: UISlider!
    
    typealias viewChangeCloseure = (Int)->()
    var myClosure:viewChangeCloseure?
    
    @IBAction func viewChange(sender: AnyObject) {
        valueLabel.text = "\(Int(self.silderView.value))"
        if let closure = myClosure {
            closure(Int(self.silderView.value))
        }
    }
    
    func viewChangeClosure(changeClosure:viewChangeCloseure){
        
        myClosure = changeClosure
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func currentView() -> AIServiceCountView {
        return NSBundle(forClass: self).loadNibNamed("AIServiceCountView", owner: self, options: nil).first as AIServiceCountView
    }
    
}