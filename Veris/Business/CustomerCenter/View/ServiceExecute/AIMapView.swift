//
//  AIMapView.swift
//  AIVeris
//
//  Created by 刘先 on 7/12/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIMapView: UIView, BMKMapViewDelegate {

    var _mapView: BMKMapView?
    static let sharedInstance = AIMapView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setupView()
    }
    
    func setupView() {
        _mapView = BMKMapView()
        _mapView?.viewWillAppear()
        _mapView?.delegate = self
        self.addSubview(_mapView!)
        _mapView!.snp_makeConstraints(closure: { (make) in
            make.leading.top.bottom.trailing.equalTo(self)
            
        })
    }
    
    //加载一个目标坐标点
    func showTargetLocation() {
        
    }
    
    //MARK: -> delegate
    /**
     *地图初始化完毕时会调用此接口
     *@param mapview 地图View
     */
    func mapViewDidFinishLoading(mapView: BMKMapView!) {
        AILog("百度地图加载完成")
    }
}
