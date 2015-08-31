
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
    
    private var dataTimeLineArray:NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "时间线"
        
        dataTimeLineArray = NSMutableArray()
        
        var label = UILabel()
        label.tag = 2
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

        
        retryNetworkingAction()
        
    }
    
    func retryNetworkingAction(){
        let viewLabel = self.view.viewWithTag(2)

        self.view.hideProgressViewLoading()
        self.view.showProgressViewLoading()
        
        Async.utility {
            AITimeLineServices().queryAllTimeData("1",orderId : "1", completion: { (data: [AITimeLineModel]) -> () in
                self.view.hideProgressViewLoading()
                if data.count > 0  {
                    self.dataTimeLineArray = NSMutableArray(array: data)
                    self.view.hideErrorView()
                    viewLabel?.hidden = false
                }else if data.count == 0{
                    self.view.showErrorView("没有数据")
                    viewLabel?.hidden = true
                }
                self.tableView.reloadData()
                
            })
        }
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
        
        let timeSpan = currnetDicValue.order_create_time ?? 0
        
        if Double(timeSpan) > NSDate().timeIntervalSince1970 {
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
        let currnetDicValue = dataTimeLineArray[indexPath.section] as AITimeLineModel
        
        if let expend =  currnetDicValue.expend {
            if expend == 1 {
                let heights = currnetDicValue.expendData!.count
                let ah = heights*41
                return CGFloat(ah)+82
            }
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
        let time:Double =   NSDate().timeIntervalSince1970
        let timeValue = currnetDicValue.order_create_time ?? Int(time)
        switch indexPath.row{
        case 0:
            //placeholder cell
            var avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITIMELINESDTimesViewCell) as? AITIMELINESDTimesViewCell
            //月份
            var  formatter = NSDateFormatter ()
            formatter.dateFormat = "MM-dd"
            
            let model = currnetDicValue.expendData?.first as AIOrderTaskListModel?
            if let m = model {
                let date = Double(m.currentTimeStamp ?? time)+Double(timeValue)
                let dateString = NSDate(timeIntervalSince1970: date)
                avCell?.monthLabel?.text = formatter.stringFromDate(dateString)
            }else{
                 avCell?.monthLabel?.text = ""
            }
            return avCell!
        case 1:
            //placeholder cell
            var avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITIMELINESDContentViewCell) as? AITIMELINESDContentViewCell
            //时间
            
            var  formatter = NSDateFormatter ()
            formatter.dateFormat = "HH:MM"
            
            /*let model = currnetDicValue.expendData?.first as AIOrderTaskListModel?
            if let m = model {
                avCell?.titleLabel?.text = m.title ?? ""
                avCell?.contentLabel?.text = m.content ?? ""
                let date = Double(m.currentTimeStamp ?? time)+Double(timeValue)
                let dateString = NSDate(timeIntervalSince1970: date)
                avCell?.timeLabel?.text = formatter.stringFromDate(dateString)
            }else{
                avCell?.titleLabel?.text = currnetDicValue.service_name ?? ""
                avCell?.contentLabel?.text = ""
                avCell?.timeLabel?.text = ""
            }*/
            
            avCell?.titleLabel?.text = currnetDicValue.service_name ?? ""
            avCell?.contentLabel?.text = ""
            avCell?.timeLabel?.text = formatter.stringFromDate(NSDate(timeIntervalSince1970: 0))
            
            for cView in avCell?.contentFillView.subviews as [UIView] {
                cView.removeFromSuperview()
            }
            
            if let expend = currnetDicValue.expend {
                
                if expend == 1 {
                    avCell?.contentFillView.hidden = false
                    
                    if currnetDicValue.expendData?.count > 0 {
                        let width: CGFloat = avCell?.contentFillView.width ?? 0
                        
                        var expendArray = NSMutableArray()
                        for model in currnetDicValue.expendData! {
                            let newData:AIOrderTaskListModel = model
                            
                            expendArray.addObject(["HyperText":newData.title ?? "","HyperKeys":newData.title ?? "","IndicatorColor":"","IndicatorImage":""])
                            
                        }
                        
                        let cardView = AICardView(frame: CGRectMake(0, 0, width, 0), cards: expendArray )
                        
                        avCell?.contentFillView.addSubview(cardView)
                    }
                    
                }else{
                    avCell?.contentFillView.hidden = true
                    
                }
            }
            
            return avCell!
            
        default:
            break
        }
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
        var currnetDicValue = dataTimeLineArray[indexPath.section] as AITimeLineModel

        if currnetDicValue.expendData?.count > 0 {
            
            if let expend = currnetDicValue.expend {
                if expend == 1 {
                    currnetDicValue.expend = 0
                }else if expend == 0 {
                    currnetDicValue.expend = 1
                }
            }else{
                currnetDicValue.expend = 1
            }
            dataTimeLineArray[indexPath.section] = currnetDicValue
            
            self.tableView.beginUpdates()
            self.tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Automatic)
            self.tableView.endUpdates()
        }
        
        
    }
}

