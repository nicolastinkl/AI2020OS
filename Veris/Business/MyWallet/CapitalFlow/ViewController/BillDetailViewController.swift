//
//  BillDetailViewController.swift
//  AIVeris
//
//  Created by Rocky on 2016/10/26.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class BillDetailViewController: UIViewController {

    @IBOutlet weak var providerIcon: UIImageView!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var starView: StarRateView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var orderCount: UILabel!
    @IBOutlet weak var costDetailsTableView: SKSTableView!
    @IBOutlet weak var transactionDetailsTableView: UITableView!
    
    var orderId: String?
    var billId: String?
    
    private var payInfop: AIPayInfoModel?
    
    private let subCellIdentifier = "CostItemSubCell"
    private let cellIdentifier = "CostItemCell"
    private let transitionCellIdentifier = "TransactionCell"
    
    class func initFromStoryboard() -> BillDetailViewController {
        let vc = UIStoryboard(name: "CapitalFlow", bundle: nil).instantiateViewControllerWithIdentifier("BillDetailViewController") as! BillDetailViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        
        providerIcon.roundCorner(providerIcon.width / 2)
        serviceName.font = AITools.myriadSemiCondensedWithSize(48.displaySizeFrom1242DesignSize())
        rateLabel.font = AITools.myriadSemiCondensedWithSize(36.displaySizeFrom1242DesignSize())
        orderCount.font = AITools.myriadSemiCondensedWithSize(36.displaySizeFrom1242DesignSize())
        
        costDetailsTableView.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        costDetailsTableView.registerNib(UINib(nibName: subCellIdentifier, bundle: nil), forCellReuseIdentifier: subCellIdentifier)
        costDetailsTableView.sksTableViewDelegate = self
        
        transactionDetailsTableView.registerNib(UINib(nibName: transitionCellIdentifier, bundle: nil), forCellReuseIdentifier: transitionCellIdentifier)
        
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func callActiion(sender: AnyObject) {
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
        appearance.titleOption = UINavigationBarAppearance.TitleOption(bottomPadding: 51.displaySizeFrom1242DesignSize(), font: AITools.myriadSemiCondensedWithSize(72.displaySizeFrom1242DesignSize()), textColor: UIColor.whiteColor(), text: "BillDetailViewController.Title".localized)
        setNavigationBarAppearance(navigationBarAppearance: appearance)
    }
    
    private func loadData() {
        
        if orderId != nil && billId != nil {
            showLoading()
            
            AIPayInfoServices.reqeustOrderInfo(orderId!, billId: billId!, success: { (model) in
                self.dismissLoading()
                self.dataModel = model
                self.transactionDetailsTableView.reloadData()
                self.costDetailsTableView.reloadData()
                
            }) { (errType, errDes) in
                self.dismissLoading()
                NBMaterialToast.showWithText(self.view, text: "GetDataFailed".localized, duration: NBLunchDuration.SHORT)
            }

        }
        
//        costData = [CostItem]()
//        
//        var item = CostItem(name: "全程陪护", cost: "32元")
//        costData?.append(item)
//        
//        item = CostItem(name: "神州孕妈专车", cost: "40元")
//        var subItem = CostItem(name: "里程费", cost: "25元")
//        item.subItems.append(subItem)
//        subItem = CostItem(name: "时长费", cost: "15元")
//        item.subItems.append(subItem)
//        costData?.append(item)
//        
//        costDetailsTableView.reloadData()
//        
//        transitionData = [TransictionItem]()
//        
//        var tritem = TransictionItem(name: "支付宝支付", value: "62.0元")
//        transitionData?.append(tritem)
//        tritem = TransictionItem(name: "支付宝支付", value: "62.0元")
//        transitionData?.append(tritem)
//        tritem = TransictionItem(name: "支付宝支付", value: "62.0元")
//        transitionData?.append(tritem)
        
        transactionDetailsTableView.reloadData()
    }

}

extension BillDetailViewController: SKSTableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == costDetailsTableView {
            return  0
        } else {
            return  0
        }
    }
    
    func tableView(tableView: UITableView, numberOfSubRowsAtIndexPath indexPath: NSIndexPath) -> Int {
        if let subRows = costData?[indexPath.row].subItems {
            return subRows.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath: NSIndexPath) -> UITableViewCell {
        if tableView == costDetailsTableView {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? CostItemCell
            
            cell?.backgroundColor = UIColor.clearColor()
            cell?.selectionStyle = .None
            
            if let data = costData?[cellForRowAtIndexPath.row] {
                cell?.itemName?.text = data.name
                cell?.costNumber?.text = data.cost
                
                cell?.isExpandable = data.subItems.count > 0
            }
            
            return cell!
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(transitionCellIdentifier) as? TransactionCell
            
            if let data = transitionData?[cellForRowAtIndexPath.row] {
                cell?.itemName?.text = data.name
                cell?.value?.text = data.value
            }
            
            return cell!
        }
    }
    
    func tableView(tableView: UITableView, cellForSubRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
   
        let cell = tableView.dequeueReusableCellWithIdentifier(subCellIdentifier) as? CostItemSubCell
        
        if let data = costData?[indexPath.row].subItems[indexPath.subRow] {
            cell?.itemName?.text = data.name
            cell?.costNumber?.text = data.cost
        }
        
        return cell!
    }
}

class CostItem {
    var name: String
    var cost: String
    var subItems = [CostItem]()
    
    init(name: String, cost: String) {
        self.name = name
        self.cost = cost
    }
}

class TransictionItem {
    var name: String
    var value: String
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}
