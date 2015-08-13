
//
//  AITimelineViewController.swift
//  AI2020OS
//
//  Created by tinkl on 31/3/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

import UIKit

import Cartography

class AITimelineViewController: UITableViewController {
    
    private var currentTimeView = AITIMELINESDTITLEView.currentView()
    
    private var dateString:String!
    
    private var dataTimeLineArray:Array<AITimeLineModel>{
        var model =  AITimeLineModel()
        model.title = "瑞士凯斯瑜伽课"
        model.content = "Jeeny老师|印度特色课"
        model.currentTimeStamp = 1429426741
        
        var model1 =  AITimeLineModel()
        model1.title = "厨师培训课"
        model1.content = "Jeeny老师|印度特色课"
        model1.currentTimeStamp = 1438433741
        
        var model2 =  AITimeLineModel()
        model2.title = "雅典瑜伽课"
        model2.content = "Jeeny老师|印度特色课"
        model2.currentTimeStamp = 1439134741
        model2.type  = 1
        
        var model3 =  AITimeLineModel()
        model3.title = "教画画"
        model3.content = "Jeeny老师|印度特色课"
        model3.currentTimeStamp = 1439235741
        model3.type  = 2
        
        var model4 =  AITimeLineModel()
        model4.title = "圣托尼亚航班"
        model4.content = "中国航空 CA2393 | 330"
        model4.currentTimeStamp = 1439550715
        
        
        return [model,model1,model2,model3,model4]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "时间线"
        
        self.tableView.reloadData()
        
        var label = UILabel()
        //label.backgroundColor = UIColor(rgba: "#a7a7a7")
        self.view.insertSubview(label, atIndex: 0)

        layout(label) { view in
            view.width == 0.5
            view.height == view.superview!.height+10000
            view.centerY == view.superview!.centerY
            view.leading == view.superview!.leading + 42
        }
        label.addDashedBorder()
        
        refereshCurrentTime()
        
        let timer =  NSTimer(timeInterval: 60, target: self, selector: "refereshCurrentTime", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        
    }
    
    ///referesh current timer.
    func refereshCurrentTime(){
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateString = dateFormatter.stringFromDate(NSDate())
        
        self.currentTimeView.labelTime.text = dateString
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer.delegate = nil
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension AITimelineViewController: UITableViewDataSource,UITableViewDelegate{
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let currnetDicValue = dataTimeLineArray[section] as AITimeLineModel
        
        let timeSpan = currnetDicValue.currentTimeStamp!
        
        if timeSpan > NSDate().timeIntervalSince1970 {
            return 60
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return  self.currentTimeView
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 44.0
        }
        return 82.0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return dataTimeLineArray.count

    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currnetDicValue = dataTimeLineArray[indexPath.section] as AITimeLineModel

        let date = NSDate(timeIntervalSince1970: currnetDicValue.currentTimeStamp!)
        
        switch indexPath.row{

        case 0:
            //placeholder cell
            var avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITIMELINESDTimesViewCell) as? AITIMELINESDTimesViewCell
            //月份
            var  formatter = NSDateFormatter ()
            formatter.dateFormat = "MM-dd"
            avCell?.monthLabel?.text = formatter.stringFromDate(date)
            
            return avCell!
        case 1:
            //placeholder cell
            var avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITIMELINESDContentViewCell) as? AITIMELINESDContentViewCell
            //时间
           
            var  formatter = NSDateFormatter ()
            formatter.dateFormat = "HH:MM"
            avCell?.timeLabel?.text = formatter.stringFromDate(date)
            avCell?.titleLabel?.text = currnetDicValue.title
            avCell?.contentLabel?.text = currnetDicValue.content
            
            if let expend = currnetDicValue.expend {
                if expend == 1 {
                    if let imageview =  avCell?.contentFillView.subviews.first as UIImageView?{
                        imageview.image =  UIImage(named: "ziyouxing")
                    }else{
                        let imageview = UIImageView(image: UIImage(named: "ziyouxing"))
                        imageview.contentMode = UIViewContentMode.ScaleAspectFill
                        avCell?.contentFillView.addSubview(imageview)
                    }
                }
            }
            
            
            return avCell!
            
        default:
            break
        }
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

