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
    var timelineDatas:[SubTimelineLabelModel]?
    
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
        timelineDatas = [SubTimelineLabelModel(position: 4, currentTime: "12:50", label: "到达别人家",status : 2),SubTimelineLabelModel(position: 1, currentTime: "12:30", label: "已出发",status: 1),SubTimelineLabelModel(position: 1, currentTime: "12:00", label: "等待出发",status: 1),SubTimelineLabelModel(position: 1, currentTime: "12:30", label: "已出发",status: 1),SubTimelineLabelModel(position: 1, currentTime: "12:00", label: "等待出发",status:1),SubTimelineLabelModel(position: 3, currentTime: "11:30", label: "等待出发",status:1)]
    }
    
    func buildViewContent(){
        var i:CGFloat = 0
        for timelineData in timelineDatas!{
            let y = i * CELL_HEIGHT
            let cellFrame = CGRectMake(0, y, self.bounds.size.width, CELL_HEIGHT)
            var cell = SubTimelineCellView(frame: cellFrame)
            cell.buildCell(timelineData)
            scrollView.addSubview(cell)
            i++
        }
        scrollView.contentSize = CGSizeMake(self.bounds.size.width, i * CELL_HEIGHT)
    }

    
}

class SubTimelineCellView : UIView{
    // MARK: - local vars
    let TOP_PADDING:CGFloat = 10
    let LEFT_PADDING:CGFloat = 10
    let POINT_LABEL_PADDING:CGFloat = 5
    let TIME_LABEL_X:CGFloat = 50
    let TIME_LABEL_RELATED_Y:CGFloat = 20
    let TIME_LABEL_SIZE:CGSize = CGSizeMake(30, 20)
    //TODO size need caculate
    let INFO_LABEL_SIZE:CGSize = CGSizeMake(100, 40)
    let INFO_LABEL_RELATED_Y:CGFloat = 50
    let IMAGE_X:CGFloat = 10
    let IMAGE_RELATED_Y:CGFloat = 0
    let IMAGE_SIZE:CGSize = CGSizeMake(7, 60)
    //image cycle size
    let CYCLE_SIZE_SMALL:CGFloat = 10
    let CYCLE_SIZE_BIG:CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        println("init by code")
    }
    
    //重新分三段构造左边的竖线
    func buildImage(){
        let lineImage = UIImage(named: "connection_line")
        
        func buildTopLine(){
            let imageFrame = CGRectMake(IMAGE_X, IMAGE_RELATED_Y, IMAGE_SIZE.width, (CELL_HEIGHT - CYCLE_SIZE_SMALL) / 2)
            var topLineView = UIImageView(frame: imageFrame)
            self.addSubview(topLineView)
        }
        
        func buildCycleView(){
            
        }
        
        func buildBottomLine(){
            
        }
    }

    func buildCell(subTimelineModel:SubTimelineLabelModel){
        var imageString:String
        let imagePrefix = "timeline_line_"
        switch subTimelineModel.position {
        case 1:
            imageString = "\(imagePrefix)1"
        case 2:
            imageString = "\(imagePrefix)2"
        case 3:
            imageString = "\(imagePrefix)3"
        case 4:
            imageString = "\(imagePrefix)4"
        default:
            imageString = "cc"
        }
        let image = UIImage(named: imageString)
        var imageView = UIImageView(frame: CGRectMake(IMAGE_X,  IMAGE_RELATED_Y, IMAGE_SIZE.width, IMAGE_SIZE.height))
        imageView.image = image
        imageView.contentMode = UIViewContentMode.Center
        
        var timeLabel = UILabel(frame: CGRectMake(TIME_LABEL_X,  TIME_LABEL_RELATED_Y, TIME_LABEL_SIZE.width, TIME_LABEL_SIZE.height))
        timeLabel.text = subTimelineModel.currentTime
        timeLabel.font = UIFont.systemFontOfSize(10)
        
        var infoLabel = UILabel(frame: CGRectMake(TIME_LABEL_X,  INFO_LABEL_RELATED_Y, INFO_LABEL_SIZE.width, INFO_LABEL_SIZE.height))
        infoLabel.text = subTimelineModel.label
        infoLabel.font = UIFont.systemFontOfSize(12)
        
        switch subTimelineModel.status{
            case 1 : infoLabel.textColor = UIColor.blackColor()
            case 2 : infoLabel.textColor = UIColor.greenColor()
            case 3 : infoLabel.textColor = UIColor.lightGrayColor()
            default: infoLabel.textColor = UIColor.blackColor()
        }
        
        self.addSubview(imageView)
        self.addSubview(infoLabel)
        self.addSubview(timeLabel)
    }
}