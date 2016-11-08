//
//  CapitalFlowViewController.swift
//  AIVeris
//
//  Created by Rocky on 2016/10/13.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class CapitalFlowViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterViewContainer: UIView!
    @IBOutlet weak var filteButton: UIButton!
    
    var capitalData: [CapitalFlowItem]?
    var capitalTypeList: CapitalTypeList?
    private var vc: FilterViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        
        filteButton.titleLabel!.font = AITools.myriadSemiCondensedWithSize(48.displaySizeFrom1242DesignSize())
        
        tableView.registerNib(UINib(nibName: "CapitalFlowCell", bundle: nil), forCellReuseIdentifier: "CapitalFlowCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 25
        
        createFilteViewController()
        
        loadData(nil)
        loadCapitalType()
    }
    
    class func initFromStoryboard() -> CapitalFlowViewController {
        let vc = UIStoryboard(name: "CapitalFlow", bundle: nil).instantiateViewControllerWithIdentifier("CapitalFlowViewController") as! CapitalFlowViewController
        return vc
    }

    @IBAction func filteAction(sender: AnyObject) {
        if vc.parentViewController != nil {
            removeFiltViewController()
        } else {
            if let list = capitalTypeList?.types as? [CapitalClassification] {
                showFiltViewController(list)
            } else {
                reloadCapitalType()
            }
            
        }
    }
    
    private func showFiltViewController(capitalTypeList: [CapitalClassification]) {
        if vc.filteData == nil {
            vc.filteData = capitalTypeList
        }
        
        addChildViewController(vc)
        tableView.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
    }
    
    private func removeFiltViewController() {
        vc.willMoveToParentViewController(nil)
        vc.view.removeFromSuperview()
        vc.removeFromParentViewController()
    }
    
    private func setupNavigationBar() {
        
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "comment-back"), forState: .Normal)
        backButton.addTarget(self, action: #selector(UIViewController.dismiss), forControlEvents: .TouchUpInside)
        
        
        let appearance = UINavigationBarAppearance()
        appearance.leftBarButtonItems = [backButton]
        
        appearance.itemPositionForIndexAtPosition = { index, position in
            if position == .Left {
                return (47.displaySizeFrom1242DesignSize(), 55.displaySizeFrom1242DesignSize())
            } else {
                return (47.displaySizeFrom1242DesignSize(), 40.displaySizeFrom1242DesignSize())
            }
        }
        appearance.barOption = UINavigationBarAppearance.BarOption(backgroundColor: UIColor(hexString: "#0f0c2c"), backgroundImage: nil, removeShadowImage: true, height: AITools.displaySizeFrom1242DesignSize(192))
        appearance.titleOption = UINavigationBarAppearance.TitleOption(bottomPadding: 51.displaySizeFrom1242DesignSize(), font: AITools.myriadSemiCondensedWithSize(72.displaySizeFrom1242DesignSize()), textColor: UIColor.whiteColor(), text: "CapitalFlowViewController.title".localized)
        setNavigationBarAppearance(navigationBarAppearance: appearance)
    }
    
    func loadData(type: String?) {
        showLoading()
        
        let service = HttpCapitalFlowService()
        
        service.getCapitalFlowList(type, success: { (responseData) in
            
            self.dismissLoading()
            self.capitalData = responseData.money_list as? [CapitalFlowItem]
            
            if self.capitalData != nil {
                self.tableView.reloadData()
            }
            
            }) { (errType, errDes) in
                self.dismissLoading()
                NBMaterialToast.showWithText(self.view, text: "GetDataFailed".localized, duration: NBLunchDuration.SHORT)
        }
        
        
        
//        capitalData = [CapitalFlowModel]()
//        
//        var model = CapitalFlowModel()
//        model.itemName = "孕检无忧"
//        model.date = "2016.05.31 19:20:18"
//        model.flowNumber = -50
//        model.type = "信用付款"
//        
//        capitalData?.append(model)
//        
//        model = CapitalFlowModel()
//        model.itemName = "孕检无忧"
//        model.date = "2016.05.30 19:20:18"
//        model.flowNumber = +52
//        model.type = "现金退款"
//        
//        capitalData?.append(model)
//        
//        if capitalData != nil {
//            tableView.reloadData()
//        }
    }
    
    private func loadCapitalType() {
        let service = HttpCapitalFlowService()
        
        service.getCapitalTypeList({ (responseData) in
            self.capitalTypeList = responseData
            }) { (errType, errDes) in
                
        }
    }
    
    private func reloadCapitalType() {
        showLoading()
        let service = HttpCapitalFlowService()
        
        service.getCapitalTypeList({ (responseData) in
            self.dismissLoading()
            self.capitalTypeList = responseData
            
            if let list = self.capitalTypeList?.types as? [CapitalClassification] {
                self.showFiltViewController(list)
            }
            
        }) { (errType, errDes) in
            self.dismissLoading()
            NBMaterialToast.showWithText(self.view, text: "GetDataFailed".localized, duration: NBLunchDuration.SHORT)

        }
    }
    
    private func createFilteViewController() {
        vc = FilterViewController.initFromStoryboard()
        vc.delegate = self
    }
    
    private func convertDate(date: NSNumber) -> String {
        let date = NSDate(timeIntervalSince1970: date.doubleValue / 1000.0)
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "MM-dd HH:mm"
        let timeString = dateFormat.stringFromDate(date)
        return timeString
    }
}

extension CapitalFlowViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CapitalFlowCell") as! CapitalFlowCell
        
        if let model = capitalData?[indexPath.row] {
            cell.itemName.text = model.name
            cell.date.text = self.convertDate(model.time)
            cell.flowNumber.text = String.init(format: "%.2f", model.amout)
            cell.type.text = model.type
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return capitalData?.count ?? 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let itemData = capitalData![indexPath.row]
        let vc = BillDetailViewController.initFromStoryboard()
        vc.billId = itemData.bill_id
        vc.orderId = itemData.rela_id
        
        let nav = UINavigationController(rootViewController: vc)
        presentBlurViewController(nav, animated: true, completion: nil)
    }
}

extension CapitalFlowViewController: CapitalFilterDelegate {
    func capitalTypeDidSelect(type: CapitalTypeItem) {
        removeFiltViewController()
        loadData(type.code)
    }
}

