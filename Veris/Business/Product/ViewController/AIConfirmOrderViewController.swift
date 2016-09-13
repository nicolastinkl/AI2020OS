//
//  AIConfirmOrderViewController.swift
//  AIVeris
//
// Copyright (c) 2016 ___ASIAINFO___
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import Spring
import Cartography
import AIAlertView

/// 订单确认界面
class AIConfirmOrderViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!

    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var priceLabel: UILabel!

    var heightDic: [String:CGFloat] = Dictionary<String, CGFloat>()

    var dataSource: AIProposalInstModel?
    
    var customNoteModel: AIProductInfoCustomerNote?

    private var current_service_list: NSArray? {
        get {
            guard dataSource?.service_list == nil else {
                let result = dataSource?.service_list.filter () {
                    return ($0 as! AIProposalServiceModel).service_del_flag == ServiceDeletedStatus.NotDeleted.rawValue
                }
                return result
            }
            return [AnyObject]()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        /**
         Config.
         */
        ConfigTableView()
        
        /**
         Data Referesh.
         */
        if current_service_list?.count > 0 {
            tableView.reloadData()
            Async.main(after: 0.1, block: {
                self.initDataRefersh()
            })
        } else {
            //Reqest Networking.
            reqestData()
        }
    }
    
    func initDataRefersh() {
        /**
         Init.
         */
        InitData()
    }
    
    func reqestData() {
        view.showLoading()
        let params = ["proposal_id" : dataSource?.proposal_id ?? 0]
        BDKProposalService().queryCustomerProposalDetail(params, success: { [weak self](responseData) in
            if let strongSelf = self {
                strongSelf.dataSource = responseData
                strongSelf.tableView.reloadData()
                strongSelf.view.hideLoading()
                Async.main(after: 0.1, block: { 
                    strongSelf.initDataRefersh()
                })
            }
            }) { (errType, errDes) in
                self.view.hideLoading()
        }
    }
    
    func ConfigTableView() {
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0)
        
    }

    func InitData() {

        self.confirmButton.titleLabel?.font = AITools.myriadSemiCondensedWithSize(52 / PurchasedViewDimention.CONVERT_FACTOR)
        self.backButton.titleLabel?.font = AITools.myriadSemiCondensedWithSize(60 / PurchasedViewDimention.CONVERT_FACTOR)
        
        //self.priceLabel.font = AITools.myriadLightSemiCondensedWithSize(39 / PurchasedViewDimention.CONVERT_FACTOR)

        let name = dataSource?.proposal_name ?? ""
        self.backButton.setTitle(String(format: " %@",name), forState: UIControlState.Normal)
        
        if NSString(string: name).containsString("AIBuyerDetailViewController.pregnancy".localized) {

            // 处理字体
            let price = dataSource?.proposal_price ?? ""
            let richText = NSMutableAttributedString(string:(price))
            richText.addAttribute(NSFontAttributeName, value: AITools.myriadLightSemiCondensedWithSize(45 / PurchasedViewDimention.CONVERT_FACTOR), range: NSMakeRange(price.length - 6, 6)) // 设置字体大小
            self.priceLabel.attributedText = richText
        } else {
            self.priceLabel.text = dataSource?.proposal_price
        }
        
        self.priceLabel.textColor = AITools.colorWithR(253, g: 225, b: 50)

        let footView = UIView()
        
        footView.setWidth(UIScreen.mainScreen().bounds.width)
        let providerView =  AIProviderView.currentView()
        providerView.content.text = ""
        providerView.setTop(17.3)
        providerView.setWidth(UIScreen.mainScreen().bounds.width)
        footView.setHeight(17.3 + providerView.height + 200)
        
        tableView.tableFooterView = footView
        
        if let customNot = self.customNoteModel {
            
            let wish = AIProposalServiceDetail_WishModel()
            var array1 = Array<AIProposalServiceDetailLabelModel>()
            var array2 = Array<AIProposalServiceDetailHopeModel>()
            if let taglist = customNot.tag_list {
                taglist.forEach({ (model) in
                    let labelModel_1 = AIProposalServiceDetailLabelModel()
                    labelModel_1.content = model.name ?? ""
                    labelModel_1.label_id = model.tag_id ?? 0
                    labelModel_1.selected_flag = model.is_chosen ?? 0
                    labelModel_1.selected_num = model.chosen_times ?? 0
                    array1.append(labelModel_1)
                })
            }
            
            if let notelist = customNot.note_list {
                notelist.forEach({ (model) in
                    let m = AIProposalServiceDetailHopeModel()
                    m.hope_id = model.nid ?? 0
                    m.text = model.content ?? ""
                    m.type = model.type ?? ""
                    m.audio_url = model.content ?? ""
                    m.time = model.create_time?.toInt() ?? 0
                    array2.append(m)
                })
            }
            
            wish.label_list = array1
            wish.hope_list = array2
            providerView.title.text = customNot.wish_name ?? ""
            providerView.content.text = customNot.wish_desc ?? ""
            if wish.label_list != nil || (wish.hope_list != nil) {
                if wish.hope_list.count > 0 || wish.label_list.count > 0 {
                    let custView = AICustomView.currentView()
                    let heisss = 200 + wish.label_list.count * 16
                    custView.setHeight(CGFloat(heisss))
                    //addNewSubView(custView, preView: viw)
                    custView.setWidth(UIScreen.mainScreen().bounds.width+5)
                    footView.addSubview(custView)
                    custView.setTop(providerView.top + providerView.height - 57)
                    custView.wish_id = wish.wish_id
                    if let labelList = wish.label_list as? [AIProposalServiceDetailLabelModel] {
                        custView.fillTags(labelList, isNormal: true, PlaceHold: true)
                    }
                }
                //这里就隐藏红色背景
                providerView.contentBgView.hidden = true
                providerView.setHeight(providerView.height - 57)
            }
            
        }

        let bgFootView = UIView()
        bgFootView.backgroundColor = UIColor(hexString: "#0F0A2E", alpha: 1)
        footView.addSubview(bgFootView)
        bgFootView.setWidth(self.view.width)
        bgFootView.setHeight(17)
        bgFootView.setTop(0)

        let line = UIView()
        line.backgroundColor = UIColor(hexString: "#ffffff", alpha: 0.2)
        footView.addSubview(line)
        line.setWidth(self.view.width)
        line.setHeight(0.4)
        line.setTop(17)

        footView.addSubview(providerView)
        
//        let tagView = UIView()
//        footView.addSubview(tagView)
//        tagView.setWidth(self.view.width)
//        tagView.setTop(90)

    }

    @IBAction func dissMissView(sender: AnyObject) {

        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func startOrderVideoAction(sender: AnyObject) {

    }

    @IBAction func pleaseMyOrderAction(sender: AnyObject) {
        view.showLoading()
        AIOrderRequester().submitProposalOrder(dataSource?.proposal_id ?? 0, serviceList:current_service_list as! [AnyObject], success: { () -> Void in
            
            self.view.hideLoading()
            
            NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.UIAIASINFORecoverOrdersNotification, object: nil)
            //back to main view controller
            NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.WishVowViewControllerNOTIFY, object: nil)
            
            AIAlertView().showInfo("AIBuyerDetailViewController.SubmitSuccess".localized, subTitle: "", closeButtonTitle:nil, duration: 2)
            
        }) { (errType, errDes) -> Void in
            self.view.hideLoading()
            
        }
    }
    
    func showPayViewAction() {
        let vc = AIPaymentViewController.initFromNib()
        let nav = UINavigationController(rootViewController: vc)
        presentViewController(nav, animated: true, completion: nil)
    }


}

extension AIConfirmOrderViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return current_service_list?.count ?? 0
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = current_service_list?.objectAtIndex(indexPath.row) as? AIProposalServiceModel

        if model?.is_expend == 0 {
            model?.is_expend = 1
        } else {
            model?.is_expend = 0
        }

        tableView.reloadData()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let model = current_service_list?.objectAtIndex(indexPath.row) as? AIProposalServiceModel

        let CELL_ID = "UITableViewCell\(model?.service_id  ?? 0)"

        var tempCell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(CELL_ID)

        if tempCell == nil {
            tempCell = UITableViewCell(style: .Default, reuseIdentifier: CELL_ID)

            //default:
            if let cellView = AIConfirmOrderCellView.initFromNib() {
                tempCell?.contentView.addSubview(cellView)
                cellView.tag = 1
                cellView.hidden = true
            }

            //Service:
            if let cellView = SimpleServiceViewContainer.initFromNib() as? SimpleServiceViewContainer {
                tempCell?.contentView.addSubview(cellView)
                cellView.tag = 2
                cellView.hidden = true
                cellView.settingState.hidden = true
                cellView.loadData(model!)
            }


            let leftTop = UIImageView()
            let rightTop = UIImageView()
            let leftBottom = UIImageView()
            let rightBottom = UIImageView()

            tempCell?.contentView.addSubview(leftTop)
            tempCell?.contentView.addSubview(rightTop)
            tempCell?.contentView.addSubview(leftBottom)
            tempCell?.contentView.addSubview(rightBottom)

            leftTop.tag = 5
            rightTop.tag = 6
            leftBottom.tag = 7
            rightBottom.tag = 8

            leftTop.image = UIImage(named: "fanshaped4")
            rightTop.image = UIImage(named: "fanshaped3")
            leftBottom.image = UIImage(named: "fanshaped2")
            rightBottom.image = UIImage(named: "fanshaped1")


            let indicator = UIImageView()
            tempCell?.contentView.addSubview(indicator)
            indicator.image = UIImage(named: "top_triangle")
            indicator.tag = 10


        }

        localCode {
            tempCell?.selectionStyle = .None
            tempCell?.backgroundColor = UIColor.clearColor()
            tempCell?.contentView.backgroundColor = UIColor.clearColor()
        }

        if model?.is_expend == 0 {

            tempCell?.contentView.viewWithTag(10)?.hidden = true
            tempCell?.contentView.viewWithTag(2)?.hidden = true

            if let orderCellView = tempCell?.contentView.viewWithTag(1) as? AIConfirmOrderCellView {
                orderCellView.hidden = false
                orderCellView.initData(model!)

                constrain(orderCellView, tempCell!) {(view, container) ->() in
                    view.left == container.left
                    view.top == container.top
                    view.bottom == container.bottom - 0.7
                    view.right == container.right
                }

                if indexPath.row % 2 == 0 {
                    orderCellView.backgroundColor = UIColor(hexString: "#d6d5f6", alpha: 0.18)
                } else {
                    orderCellView.backgroundColor = UIColor(hexString: "#d6d5f6", alpha: 0.28)
                }
            }

        } else {
            //expend


            if let v = tempCell?.contentView.viewWithTag(10) {
                v.hidden = false

                constrain(v) { (indicatorlayout) in
                    indicatorlayout.centerX == indicatorlayout.superview!.centerX
                    indicatorlayout.bottom == indicatorlayout.superview!.bottom - 5
                    indicatorlayout.height == 8
                    indicatorlayout.width == 15
                }

            }

            tempCell?.contentView.viewWithTag(1)?.hidden = true

            if let serviceView = tempCell?.contentView.viewWithTag(2) as? SimpleServiceViewContainer {
                serviceView.hidden = false
                //serviceView.settingState.tag = indexPath.row
                //serviceView.settingButtonDelegate = self

                heightDic["\(model?.service_id)"] = serviceView.selfHeight()

                // Add constrain
                constrain(serviceView, tempCell!) {(view, container) ->() in
                    view.left == container.left
                    view.top == container.top
                    view.bottom == container.bottom - 0.7
                    view.right == container.right
                }

            }
        }

        if let leftTop = tempCell?.contentView.viewWithTag(5), rightTop = tempCell?.contentView.viewWithTag(6), leftBottom = tempCell?.contentView.viewWithTag(7), rightBottom =  tempCell?.contentView.viewWithTag(8) {

            if indexPath.row == 0 {
                leftTop.hidden = true
                rightTop.hidden = true
            } else {

                leftTop.hidden = false
                rightTop.hidden = false
            }

            constrain([leftTop, rightTop, leftBottom, rightBottom], block: { (layouts) in
                let layoutLT = layouts[0]
                layoutLT.leading == layoutLT.superview!.leading
                layoutLT.top == layoutLT.superview!.top

                let layoutRT = layouts[1]
                layoutRT.leading == layoutRT.superview!.trailing - 10
                layoutRT.top == layoutRT.superview!.top

                let layoutLB = layouts[2]
                layoutLB.leading == layoutLB.superview!.leading
                layoutLB.bottom == layoutLB.superview!.bottom

                let layoutRB = layouts[3]
                layoutRB.leading == layoutRB.superview!.trailing - 10
                layoutRB.bottom == layoutRB.superview!.bottom

            })

            settingsBlackColor([leftTop, rightTop, leftBottom, rightBottom])
        }


        return tempCell ?? UITableViewCell()
    }

    func settingsBlackColor(sviews: [UIView]) {

        for sview in sviews {
            constrain(sview) { (layout) in
                layout.width == 10
                layout.height == 10
            }
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        let model = current_service_list?.objectAtIndex(indexPath.row) as? AIProposalServiceModel
        if model?.is_expend == 0 {
            return 64
        } else {
            return (heightDic["\(model?.service_id)"] ?? 0) + 10.0
        }

    }
}
