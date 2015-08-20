//
//  SubTimelineView.swift
//  AI2020OS
//
//  Created by 刘先 on 15/8/19.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

struct SubTimelineLabelModel {
    var position:Int!
    var currentTime:String!
    var label:String!
    
    init(position:Int,currentTime:String,label:String){
        self.position = position
        self.currentTime = currentTime
        self.label = label
    }
}

enum SubTimelinePosition : Int{
    case TopFuture = 1,Top
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
    }
    
    func fakeModelData(){
        timelineDatas = [SubTimelineLabelModel(position: 1, currentTime: "12:50", label: "到达别人家"),SubTimelineLabelModel(position: 2, currentTime: "12:30", label: "已出发"),SubTimelineLabelModel(position: 3, currentTime: "12:00", label: "等待出发"),SubTimelineLabelModel(position: 3, currentTime: "11:30", label: "等待出发")]
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
    let TIME_LABEL_X:CGFloat = 100
    let TIME_LABEL_RELATED_Y:CGFloat = 20
    let TIME_LABEL_SIZE:CGSize = CGSizeMake(30, 20)
    //TODO size need caculate
    let INFO_LABEL_SIZE:CGSize = CGSizeMake(100, 40)
    let INFO_LABEL_RELATED_Y:CGFloat = 50
    let IMAGE_X:CGFloat = 10
    let IMAGE_RELATED_Y:CGFloat = 15
    let IMAGE_SIZE:CGSize = CGSizeMake(20, 60)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        println("init by code")
    }

    func buildCell(subTimelineModel:SubTimelineLabelModel){
        var imageString:String
        switch subTimelineModel.position {
        case 1:
            imageString = "aa"
        case 2:
            imageString = "bb"
        default:
            imageString = "cc"
        }
        let image = UIImage(named: imageString)
        var imageView = UIImageView(frame: CGRectMake(IMAGE_X,  IMAGE_RELATED_Y, IMAGE_SIZE.width, IMAGE_SIZE.height))
        
        var timeLabel = UILabel(frame: CGRectMake(TIME_LABEL_X,  TIME_LABEL_RELATED_Y, TIME_LABEL_SIZE.width, TIME_LABEL_SIZE.height))
        timeLabel.text = subTimelineModel.currentTime
        
        var infoLabel = UILabel(frame: CGRectMake(TIME_LABEL_X,  INFO_LABEL_RELATED_Y, INFO_LABEL_SIZE.width, INFO_LABEL_SIZE.height))
        infoLabel.text = subTimelineModel.label
        
        self.addSubview(imageView)
        self.addSubview(infoLabel)
        self.addSubview(timeLabel)
    }
}