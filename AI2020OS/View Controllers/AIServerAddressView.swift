//
//  AIServerAddressView.swift
//  AI2020OS
//
//  Created by tinkl on 25/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIServerAddressView: UIView {
    
    @IBOutlet weak var datePickerView: UIPickerView!
    
    private var currentLocation:AITSLocation?
    
    private var provinces:Array<AnyObject> = {
        let provincesFile = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("ProvincesAndCities.plist", ofType: nil)!)
            return provincesFile as Array<AnyObject>
    }()
    
    private var citys:Array<AnyObject> = {
        let provincesFile = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("ProvincesAndCities.plist", ofType: nil)!)
        let citys = provincesFile?.firstObject as Dictionary<String,AnyObject>
        
        return citys["Cities"]  as Array<AnyObject>
        }()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
        let stateDic = self.provinces.first as Dictionary<String,AnyObject>
        let cityDic = self.citys.first as Dictionary<String,AnyObject>
        let state = stateDic["State"] as String
        let city = cityDic["city"] as String
        currentLocation = AITSLocation(state: state, city: city)
    }
    
    class func currentView()->AIServerAddressView{
        var cell = NSBundle.mainBundle().loadNibNamed(AIApplication.MainStoryboard.ViewIdentifiers.AIServerAddressView, owner: self, options: nil).last  as AIServerAddressView
        cell.datePickerView.setValue(UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor), forKeyPath: "textColor")
        //cell.datePickerView.reloadAllComponents()
        return cell
    }
    
}

extension AIServerAddressView:UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return self.provinces.count
        }
        return self.citys.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        let stateDic = self.provinces[row] as Dictionary<String,AnyObject>
       
        let state = stateDic["State"] as String
        
        if component == 0{
            return state
        }
        
        let cityDic = self.citys[row] as Dictionary<String,AnyObject>
        let city = cityDic["city"] as String
        
        return city
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            let stateDic = self.provinces[row] as Dictionary<String,AnyObject>
            self.citys = stateDic["Cities"] as Array<AnyObject>
            self.datePickerView .selectRow(0, inComponent: 1, animated: false)
            self.datePickerView.reloadComponent(1)
            
            let state = stateDic["State"] as String
            self.currentLocation?.state = state
            
            
            let cityDic = self.citys[0] as Dictionary<String,AnyObject>
            let city = cityDic["city"] as String
            
            self.currentLocation?.city = city
            
            
        }else{
            
            let cityDic = self.citys[row] as Dictionary<String,AnyObject>
            let city = cityDic["city"] as String
            self.currentLocation?.city = city
        }
        
        
    }
    
}