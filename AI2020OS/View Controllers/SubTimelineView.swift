//
//  SubTimelineView.swift
//  AI2020OS
//
//  Created by 刘先 on 15/8/19.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

let CELL_HEIGHT : CGFloat = 60

struct SubTimelineLabelModel {
    var position:Int!
    var currentTime:String!
    var label:String!
    var status:Int!
    
    init(position:Int,currentTime:String,label:String,status:Int){
        self.position = position
        self.currentTime = currentTime
        self.label = label
        self.status = status
    }
}

enum SubTimelinePosition : Int{
    case Top = 1,Middle,Bottom
}

enum SubTimelineStatus : Int{
    case Past = 1,Now,Future
}

class SubTimelineView: UIView {
    let CELL_HEIGHT : CGFloat = 60
    
    private var scrollView:UIScrollView!
    var timelineDatas:[SubTimelineLabelModel] = []
    var orderId : String!
    var partyRoleId : Int!
    
    override init(){
        super.init()
        scrollView = UIScrollView()
        scrollView.frame = self.bounds
        self.addSubview(scrollView)
        
        buildViewContent()

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        println("init by code")
        scrollView = UIScrollView()
        scrollView.frame = self.bounds
        self.addSubview(scrollView)
        fakeModelData()
        buildViewContent()
    }
    
    func fakeModelData(){
        timelineDatas = [SubTimelineLabelModel(position: 1, currentTime: "13:50", label: "到达别人家",status : 3),SubTimelineLabelModel(position: 2, currentTime: "12:30", label: "已出发",status: 2),SubTimelineLabelModel(position: 2, currentTime: "12:00", label: "等待出发",status: 1),SubTimelineLabelModel(position: 2, currentTime: "11:30", label: "准备指甲油准备指甲油准备指甲油",status: 1),SubTimelineLabelModel(position: 2, currentTime: "11:00", label: "清洁用具清洁用具清洁用具",status:1),SubTimelineLabelModel(position: 3, currentTime: "10:30", label: "准备用具准备用具准备用具",status:1)]
    }
    
    func retryNetworkingAction(){
        Async.utility {
            AITimeLineServices().queryAllTimeData("",orderId : self.orderId, completion: { (data: [AITimeLineModel]) -> () in
                self.hideProgressViewLoading()
                if data.count > 0  {
                    //trans from AITimeLineModel to SubTimelineLabelModel
                    self.timelineDatas.removeAll(keepCapacity: true)
                    //build date
                    for var index = 0; index < data.count; ++index {
                        let aiTimeLineModel = data[index]
                        let currentTimeStamp = aiTimeLineModel.currentTimeStamp ?? 0
                        let currentTime = currentTimeStamp.dateStringFromTimestamp()
                        let title = aiTimeLineModel.title ?? ""
                        let status = self.compareDateFromNow(currentTimeStamp)
                        var position:SubTimelinePosition!
                        if index == 0 {
                            
                            position = SubTimelinePosition.Top
                        }
                        else if index == data.count - 1{
                            position = SubTimelinePosition.Bottom
                        }
                        else {
                            position = SubTimelinePosition.Middle
                        }
                         self.timelineDatas.append(SubTimelineLabelModel(position: position.rawValue, currentTime: currentTime, label: title, status: position.rawValue))
                        //build content
                        self.buildViewContent()
                    }
                    self.hideErrorView()
                }else if data.count == 0{
                    self.showErrorView("没有数据,使用fakeData")
                    self.fakeModelData()
                    self.buildViewContent()
                }
                
            })
        }

    }
    
    func buildViewContent(){
        var i:CGFloat = 0
        
        //clear all data
        scrollView.subviews.filter{
            let value:UIView = $0 as UIView
            value.removeFromSuperview()
            return true
        }

        for timelineData in timelineDatas{
            let y = i * CELL_HEIGHT
            let cellFrame = CGRectMake(0, y, self.bounds.size.width, CELL_HEIGHT)
            var cell = SubTimelineCellView(frame: cellFrame)
            cell.buildCell(timelineData)
            scrollView.addSubview(cell)
            i++
        }
        scrollView.contentSize = CGSizeMake(self.bounds.size.width, i * CELL_HEIGHT)
    }

    func compareDateFromNow(destDate : Double) -> SubTimelineStatus{
        let nowDate = NSDate()
        let nowTimeStamp = nowDate.timeIntervalSince1970
        if nowTimeStamp > destDate {
            return SubTimelineStatus.Past
        }
        else if nowTimeStamp == destDate{
            return SubTimelineStatus.Now
        }
        else{
            return SubTimelineStatus.Future
        }
    }
    
}

class SubTimelineCellView : UIView{
    // MARK: - local vars
    let TOP_PADDING:CGFloat = 10
    let LEFT_PADDING:CGFloat = 10
    let POINT_LABEL_PADDING:CGFloat = 5
    let TIME_LABEL_X:CGFloat = 50
    let TIME_LABEL_RELATED_Y:CGFloat = 10
    let TIME_LABEL_SIZE:CGSize = CGSizeMake(40, 15)
    //TODO size need caculate
    let INFO_LABEL_SIZE:CGSize = CGSizeMake(300, 20)
    let INFO_LABEL_RELATED_Y:CGFloat = 25
    let IMAGE_X:CGFloat = 15
    let IMAGE_RELATED_Y:CGFloat = 0
    let IMAGE_SIZE:CGSize = CGSizeMake(1, 60)
    //image cycle size
    let CYCLE_SIZE_SMALL:CGFloat = 6
    let CYCLE_SIZE_BIG:CGFloat = 12
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        println("init by code")
    }
    
    //重新分三段构造左边的竖线
    func buildLineImage(subTimelineModel:SubTimelineLabelModel){
        // connection_line
        let lineImage = UIImage(named: "Tabbar_background")
        let status = SubTimelineStatus(rawValue: subTimelineModel.status)
        let position = SubTimelinePosition(rawValue: subTimelineModel.position)
        
        let cycleSize = status == SubTimelineStatus.Now ? CYCLE_SIZE_BIG : CYCLE_SIZE_SMALL
        let cycleFrame = CGRectMake(IMAGE_X - cycleSize/2 + 0.5, (CELL_HEIGHT - cycleSize) / 2, cycleSize, cycleSize)
        var cycleColor:UIColor
        
        switch status!{
        case .Future:
            cycleColor = UIColor.lightGrayColor()
        case .Now:
            cycleColor = UIColor.greenColor()
        case .Past:
            cycleColor = UIColor.blackColor()
        default:
            cycleColor = UIColor.blackColor()
        }
        
        func buildTopLine(){
            let imageFrame = CGRectMake(IMAGE_X, IMAGE_RELATED_Y, IMAGE_SIZE.width, (CELL_HEIGHT - cycleSize) / 2)
            var topLineView = UIImageView(frame: imageFrame)
            topLineView.image = lineImage
            self.addSubview(topLineView)
        }
        
        func buildCycleView(){
            var cycleView = UIView(frame: cycleFrame)
            cycleView.backgroundColor = cycleColor
            cycleView.layer.cornerRadius = cycleSize / 2
            self.addSubview(cycleView)
        }
        
        func buildBottomLine(){
            let imageFrame = CGRectMake(IMAGE_X, CGRectGetMaxY(cycleFrame), IMAGE_SIZE.width, (CELL_HEIGHT - cycleSize) / 2)
            var buttomLineView = UIImageView(frame: imageFrame)
            buttomLineView.image = lineImage
            self.addSubview(buttomLineView)
        }
        
        
        
        switch position!{
        case .Top:
            buildBottomLine()
        case .Bottom:
            buildTopLine()
        default:
            buildTopLine()
            buildBottomLine()
        }
        
        buildCycleView()
    }

    func buildCell(subTimelineModel:SubTimelineLabelModel){
        
        var timeLabel = UILabel(frame: CGRectMake(TIME_LABEL_X,  TIME_LABEL_RELATED_Y, TIME_LABEL_SIZE.width, TIME_LABEL_SIZE.height))
        timeLabel.text = subTimelineModel.currentTime
        timeLabel.textColor = UIColor.lightGrayColor()
        timeLabel.font = UIFont.systemFontOfSize(10)
        
        var infoLabel = UILabel(frame: CGRectMake(TIME_LABEL_X,  INFO_LABEL_RELATED_Y, INFO_LABEL_SIZE.width, INFO_LABEL_SIZE.height))
        infoLabel.text = subTimelineModel.label
        infoLabel.font = UIFont.systemFontOfSize(13)
        
        switch subTimelineModel.status{
            case 1 :
                infoLabel.textColor = UIColor.blackColor()
            case 2 :
                infoLabel.textColor = UIColor.greenColor()
                infoLabel.font = UIFont.boldSystemFontOfSize(15)
            case 3 :
                infoLabel.textColor = UIColor.lightGrayColor()
            default: infoLabel.textColor = UIColor.blackColor()
        }
        
        //self.addSubview(imageView)
        self.addSubview(infoLabel)
        self.addSubview(timeLabel)
        
        buildLineImage(subTimelineModel)
    }
}