//
//  AIMapView.swift
//  AIVeris
//
//  Created by 刘先 on 7/12/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIMapView: UIView {

    var _mapView: BMKMapView!
    var locationService: BMKLocationService!
    var targetAnnotation: BMKPointAnnotation?
    var locationAnnotation: BMKPointAnnotation?
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
        _mapView.viewWillAppear()
        _mapView.delegate = self
        self.addSubview(_mapView!)
        _mapView!.snp_makeConstraints(closure: { (make) in
            make.leading.top.bottom.trailing.equalTo(self)
        })
        locationService = BMKLocationService()
        //locationService.allowsBackgroundLocationUpdates = true
        locationService.delegate = self
        //showTargetAnnotation()
    }
    
    func releaseView(){
        _mapView.viewWillDisappear()
        _mapView.delegate = nil
        locationService.delegate = nil
    }
    
    //加载一个目标坐标点
    func showTargetAnnotation() {
        targetAnnotation = BMKPointAnnotation()
        let coor = CLLocationCoordinate2D(latitude: 30.633, longitude: 104.047)
        targetAnnotation!.coordinate = coor
        _mapView.addAnnotation(targetAnnotation)
        zoomToFitMapAnnotations(_mapView)
    }
    
    //MARK: -> util methods
    
    /**
     根据当前定位坐标和目标显示坐标，调整map的缩放大小
     
     - parameter mapView: <#mapView description#>
     */
    func zoomToFitMapAnnotations(mapView: BMKMapView) {
        if mapView.annotations.count == 0 {
            return
        }
        var topLeftCoord = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        var bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)
        for annotation in mapView.annotations {
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude)
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude)
            
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude)
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude)
        }
        var region = BMKCoordinateRegion()
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5
        region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5
        region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
        region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
        region = mapView.regionThatFits(region)
        mapView.setRegion(region, animated: true)
    }
    
    
}

extension AIMapView: BMKMapViewDelegate, BMKLocationServiceDelegate {
    //MARK: -> delegate
    /**
     *地图初始化完毕时会调用此接口
     *@param mapview 地图View
     */
    func mapViewDidFinishLoading(mapView: BMKMapView!) {
        AILog("百度地图加载完成")
        locationService.startUserLocationService()
        _mapView.showsUserLocation = false//先关闭显示的定位图层
        _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
        _mapView.showsUserLocation = true//显示定位图层
    }
    
    func mapView(mapView: BMKMapView!, viewForAnnotation annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if (annotation as! BMKPointAnnotation) == targetAnnotation {
            let AnnotationViewID = "TargetAnnotation"
            let annotationView = BMKAnnotationView(annotation: annotation, reuseIdentifier: AnnotationViewID)
            //annotationView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
            annotationView.clipsToBounds = false
            annotationView.image = UIImage(named: "AI_Search_Home_WIsh")
            return annotationView
        }
        return nil
    }
    
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        print("didUpdateUserLocation lat:\(userLocation.location.coordinate.latitude) lon:\(userLocation.location.coordinate.longitude)")
        _mapView.removeAnnotation(locationAnnotation)
        locationService.stopUserLocationService()
        locationAnnotation = BMKPointAnnotation()
        let coor = CLLocationCoordinate2D(latitude: userLocation.location.coordinate.latitude, longitude: userLocation.location.coordinate.longitude)
        locationAnnotation!.coordinate = coor
        
        _mapView.addAnnotation(locationAnnotation)
        
        showTargetAnnotation()
        _mapView.updateLocationData(userLocation)
    }
    
    /**
     *在地图View将要启动定位时，会调用此函数
     *@param mapView 地图View
     */
    func willStartLocatingUser() {
        print("willStartLocatingUser")
    }
}
