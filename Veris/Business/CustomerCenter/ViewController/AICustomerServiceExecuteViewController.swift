//
//  AICustomerServiceExecuteViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/6/16.
//  Base on Aerolitec Template
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

// MARK: -
// MARK: AICustomerServiceExecuteViewController
// MARK: -
internal class AICustomerServiceExecuteViewController: UIViewController {
  // MARK: -
  // MARK: Public access
  // MARK: -
  
  // MARK: -> Public properties
    var serviceInstsView : AIVerticalScrollView!
    var models : [IconServiceIntModel]?
    var orderInfoContentView : OrderAndBuyerInfoView?
  
  // MARK: -> Public class methods
  
  // MARK: -> Public init methods
  
  // MARK: -> Public methods
    func setupViews(){
        //orderInfoView
        orderInfoContentView = OrderAndBuyerInfoView.createInstance()
        orderInfoView.addSubview(orderInfoContentView!)
        orderInfoContentView?.delegate = self
        
        orderInfoContentView?.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(orderInfoView)
        }
        
        buildServiceInstsView()
    }
    
    func buildServiceInstsView(){
        
        models = [IconServiceIntModel(serviceInstId: 1, serviceIcon: "http://171.221.254.231:3000/upload/proposal/NKfG9YRqfEZq3.png", serviceInstStatus: ServiceInstStatus.Assigned, executeProgress: 1),IconServiceIntModel(serviceInstId: 1, serviceIcon: "http://171.221.254.231:3000/upload/proposal/NKfG9YRqfEZq3.png", serviceInstStatus: ServiceInstStatus.Assigned, executeProgress: 1),IconServiceIntModel(serviceInstId: 1, serviceIcon: "http://171.221.254.231:3000/upload/proposal/NKfG9YRqfEZq3.png", serviceInstStatus: ServiceInstStatus.Assigned, executeProgress: 1)]
        if let models = models {
            serviceInstsView = AIVerticalScrollView()
            serviceInstsView.userInteractionEnabled = true
            serviceInstsView.myDelegate = self
            serviceInstsView.showsVerticalScrollIndicator = false
            //选择服务执行的时候才展现
            serviceInstsView.hidden = true
            serviceIconContainerView.addSubview(serviceInstsView)
            serviceInstsView?.snp_makeConstraints { (make) -> Void in
                make.edges.equalTo(serviceIconContainerView)
            }
            serviceInstsView.loadData(models)
        }
        
        
    }
  
  // MARK: -> Interface Builder properties
    
    @IBOutlet weak var buttonAll: UIButton!
    @IBOutlet weak var buttonMessage: UIButton!
    @IBOutlet weak var buttonNeedReply: UIButton!
    @IBOutlet weak var serviceIconContainerView: UIView!
    @IBOutlet weak var timelineContainerView: UIView!
    @IBOutlet weak var orderInfoView: UIView!
    
    
  
  // MARK: -> Interface Builder actions
    
    
    @IBAction func timelineFilterButtonAction(sender: UIButton) {
        
    }
    
    @IBAction func contactAction(sender: UIButton) {
    }

    
    @IBAction func filterPopAction(sender: UIButton) {
        
    }
  
  // MARK: -> Class override UIViewController
  
  override internal func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    setupViews()
  }
  
  override internal func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: -> Protocol <#protocol name#>
  
}

extension AICustomerServiceExecuteViewController : OrderAndBuyerInfoViewDelegate, VerticalScrollViewDelegate {
    
    func viewCellDidSelect(verticalScrollView : AIVerticalScrollView , index : Int , cellView : UIView){
        
    }
}
