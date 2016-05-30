//
//  AIServerTimeView.swift
//  AI2020OS
//
//  Created by tinkl on 25/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIServerTimeView: UIView {
    
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    typealias viewChangeCloseure = (Double)->()
    var myClosure:viewChangeCloseure?
    
    @IBAction func viewChange(sender: AnyObject) {
        
        if let closure = myClosure {
            closure(self.datePickerView.date.timeIntervalSince1970)
        }
    }
    
    func viewChangeClosure(changeClosure:viewChangeCloseure){
        
        myClosure = changeClosure
    }
    
    class func currentView()->AIServerTimeView{
        var cell = NSBundle.mainBundle().loadNibNamed(AIApplication.MainStoryboard.ViewIdentifiers.AIServerTimeView, owner: self, options: nil).last  as AIServerTimeView
        cell.datePickerView.setValue(UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor), forKeyPath: "textColor")
        return cell
    }
    

}