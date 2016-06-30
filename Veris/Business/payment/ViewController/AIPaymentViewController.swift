//
//  AIWishVowViewController.swift
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
import UIKit
import Spring
import Cartography
import AIAlertView
import SnapKit
import SVProgressHUD

/// 许愿视图
class AIPaymentViewController: UIViewController {
    
    let AppScheme: String = "AIVeris"
    
    let AlipayPartner: String = "2088311868782039"
    let AlipaySeller: String = "liaojy@sudiyi.net"
    let AlipayPrivateKey: String = "MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAL8lcOW8NKC0XOhhxzmy5GyhtQtpQWqsE/6+A067VeLLObDKQrC1qMt/7oOMD1KW1Mv0/b3b0UzlxrGDamcJod6VQyZoln8txkhklMFfKX3lM/FOYcXz5wS7GRU4AjiLJaLBWsP3UOrCzNM+bvgv6rMJgIUpyhtyHkrdVAQSBDc5AgMBAAECgYBG0v2o8fpiDVJbfFdQRruikKw/ZSmq98WU3xzkoD8rgHeIzPi29yhq9qUOsue+h0qjo8wc/ATqRD1B6tqTARurdFuEspNakYafAe2waVVd4aRg7Vxh9Ju908+UkKQ+DNqmzvoMkVz2Z1CaBdEbC6kKVd3q8IBsmNPr0OmjyII4AQJBAOogQgJuSNlFP5QyZcCmEN7RsH53NyccXeolCBpfWE0WE0NTE/bblY13az1nnW5/dm9/8PkiZ5fmqlH7GlCFXDkCQQDRATVym2gyWviNSQrHuc0ThE88ouM2c0Whh45PWyNy7Fz3er2z12ksMX7Vl8aTHa/s5OWNMSnMMMSPCvoIG7MBAkA5okk9mfJ68c4N6D4eJ4M9prbg2u4LxbLkwcr12wS8rTN+vkPK4BE3qu8ORaR+oAgCuKcUXUDNJu5EkiDPM5UZAkEAyMlQf3ms8DNU9OZm5NkqmsVRGf+iKH01N6jynmn/9Df+WAIinNMkxsAGCUx2CH9Ms1hy7uF8Nh3jt0fkTEXQAQJBAJLVRSUf6FCxL/MYxd1Ls8us7FU+bzRhXkR6m3lurUyRItkrtbv2kdpegBHxWCTRddf0l0Fpbvh21ShzQ/NKGns="
    
    let AlipayNotifyURL: String = "http://www.yourdomain.com/order/alipay_notify_app"
    
    @IBOutlet weak var providerIcon: AIImageView!
    
    @IBOutlet weak var providerName: UILabel!
    
    @IBOutlet weak var providerLevel: UIView!
    @IBOutlet weak var weixinButton: UIButton!
    @IBOutlet weak var alipayButton: UIButton!
    
    @IBOutlet weak var label_Price_info: UILabel!
    @IBOutlet weak var label_Pay_Style: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var payView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource = Array<AIPayInfoModel> ()
    var expandedIndexPaths: [NSIndexPath] = [NSIndexPath]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
         Init SubView
         */
        layoutSubView()
        
        /**
         Init TableView
         */
        initTableView()
        
        /**
         Init dataSource
         */
        initData()
        
        /**
         Register Notify
         */
        initRegisternotify()
        
    }
    
    func initRegisternotify() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AIPaymentViewController.showNotifyPayStatus), name: AIApplication.Notification.WeixinPaySuccessNotification, object: nil)
    }
    
    /**
     显示支付状态（成功）
     */
    func showNotifyPayStatus() {

        self.label_Price_info.text = "成功支付"
        
        // refersh Views Status
        
        SpringAnimation.springWithCompletion(0.3, animations: { 
            self.payView.alpha = 0
            self.tableView.alpha = 0
            }) { (complate) in
                self.payView.hidden = true
                self.tableView.hidden = true
        }
        
        // Display Button's commit
        
        
        let priceLabel = UILabel()
        priceLabel.textAlignment = .Center
        priceLabel.text = "123元"
        priceLabel.font = AITools.myriadBoldWithSize(140/3)
        priceLabel.textColor = UIColor(white: 1, alpha: 0.7)
        bgView.addSubview(priceLabel)
        priceLabel.pinTopEdgeToTopEdgeOfItem(label_Price_info, offset: 80, priority: UILayoutPriorityRequired)
        priceLabel.sizeToMinWidth(100)
        priceLabel.sizeToHeight(50)
        priceLabel.centerHorizontallyInSuperview()
        
        let commitButton = DesignableButton(type: .Custom)
        bgView.addSubview(commitButton)
        commitButton.pinTopEdgeToTopEdgeOfItem(priceLabel, offset: 83, priority: UILayoutPriorityRequired)
        commitButton.sizeToWidth(78)
        commitButton.sizeToHeight(44)
        commitButton.centerHorizontallyInSuperview()
        commitButton.titleLabel?.font = AITools.myriadBoldWithSize(68/3)
        
        commitButton.borderWidth = 1
        commitButton.cornerRadius = 4
        commitButton.setTitle("评价", forState: UIControlState.Normal)
        commitButton.borderColor = UIColor(hexString: "#0f86e8")
        commitButton.setTitleColor(UIColor(hexString: "#0f86e8"), forState: UIControlState.Normal)
        commitButton.setTitleColor(UIColor(hexString: "#FFFFFF"), forState: UIControlState.Highlighted)
        commitButton.setBackgroundImage(UIColor(hexString: "#0f86e8").imageWithColor(), forState: UIControlState.Highlighted)
        commitButton.addTarget(self, action: #selector(AIPaymentViewController.commitPayAction), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    
    @IBAction func closePayAction(){
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func commitPayAction(){
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = 37
        tableView.registerClass(AIPayListInfoCellView.self, forCellReuseIdentifier: "CellID")
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func initData() {
        
        var model1 = AIPayInfoModel()
        model1.price = 432.5
        model1.servicename = "全程陪护"
        dataSource.append(model1)
        
        
        var model2 = AIPayInfoModel()
        model2.price = 23
        model2.servicename = "神州专车"
        dataSource.append(model2)
                
        var model3 = AIPayInfoModel()
        model3.price = 30
        model3.servicename = "春雨医生"
        model3.childList = dataSource
        dataSource.append(model3)
        
        dataSource.append(model2)
        
        self.tableView.reloadData()
    }
    
    func layoutSubView() {
        
        /// Init Size and Font
        
        providerName.font = AITools.myriadLightWithSize(48/3)
        providerName.textColor = UIColor(hexString: "#fefefe")
        label_Price_info.font = AITools.myriadLightWithSize(48/3)
        label_Price_info.textColor = UIColor(hexString: "#fefefe", alpha: 0.66)
        label_Pay_Style.font = AITools.myriadLightWithSize(48/3)
        label_Pay_Style.textColor = UIColor(hexString: "#fefefe", alpha: 0.66)
        
        /// Layout
        
        providerName.text = "孕检无忧"
        
        let starRateView = StarRateView(frame: CGRect(x: 0, y: 5, width: 60, height: 11), numberOfStars: 5, foregroundImage: "star_rating_results_highlight", backgroundImage: "star_rating_results_normal")
        
        starRateView.userInteractionEnabled = false
        let score: CGFloat = 5
        starRateView.scorePercent = score / 10
        providerLevel.addSubview(starRateView)
        
        let label = UILabel()
        label.text = "\(score)"
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = AITools.colorWithR(253, g: 225, b: 50)
        label.frame = CGRectMake(starRateView.right + 5, 1, 30, 20)
        providerLevel.addSubview(label)
        
        let zanlabel = UILabel()
        zanlabel.text = "12345单"
        zanlabel.font = AITools.myriadLightWithSize(40/3)
        zanlabel.textColor = UIColor(hexString: "#FFFFFF", alpha: 0.6)
        zanlabel.frame = CGRectMake(label.right, 1, 80, 20)
        providerLevel.addSubview(zanlabel)
            
        
        Async.main(after: 1) {
            self.drawLine()
        }
        
    }
    
    func drawLine() {
        
        /// Top
        let offset: CGFloat = self.view.width/7.4
        let widthLine = label_Price_info.left - offset - 11
        let top = label_Price_info.y + label_Price_info.height/2
        let price_List_Left_Line = StrokeLineView(frame: CGRectMake(offset, top, widthLine, 1))
        let price_List_Right_Line = StrokeLineView(frame: CGRectMake(label_Price_info.left + label_Price_info.width + 11, top, widthLine, 1))
        price_List_Left_Line.backgroundColor = UIColor.clearColor()
        price_List_Right_Line.backgroundColor = UIColor.clearColor()
        bgView.addSubview(price_List_Left_Line)
        bgView.addSubview(price_List_Right_Line)
        
        
        /// Middle
        let top_Middle = label_Pay_Style.y + label_Pay_Style.height/2
        let pay_List_Left_Line = StrokeLineView(frame: CGRectMake(offset, top_Middle, widthLine, 1))
        let pay_List_Right_Line = StrokeLineView(frame: CGRectMake(label_Price_info.left + label_Price_info.width + 11, top_Middle, widthLine, 1))
        pay_List_Left_Line.backgroundColor = UIColor.clearColor()
        pay_List_Right_Line.backgroundColor = UIColor.clearColor()
        payView.addSubview(pay_List_Left_Line)
        payView.addSubview(pay_List_Right_Line)
        
        /// Bottom
        let wechatLineView = StrokeLineView()
        let alipayLineView = StrokeLineView()
        wechatLineView.backgroundColor = UIColor.clearColor()
        alipayLineView.backgroundColor = UIColor.clearColor()
        payView.addSubview(wechatLineView)
        payView.addSubview(alipayLineView)
        wechatLineView.setTop(weixinButton.y + weixinButton.height)
        alipayLineView.setTop(alipayButton.y + alipayButton.height)
        wechatLineView.setLeft(offset)
        alipayLineView.setLeft(offset)
        wechatLineView.setWidth(view.width - offset * 2)
        alipayLineView.setWidth(view.width - offset * 2)
        wechatLineView.setHeight(1)
        alipayLineView.setHeight(1)
    }
    
    @IBAction func callPhone(sender: AnyObject) {
        
        let alert = JSSAlertView()
        alert.info( self, title: "13888888888", text: "", buttonText: "Call", cancelButtonText: "Cancel")
        alert.defaultColor = UIColorFromHex(0xe7ebf5, alpha: 1)
        alert.addAction { 
            UIApplication.sharedApplication().openURL(NSURL(string: "tel:13888888888")!)
        }
    }
    
    @IBAction func wechatAction(sender: AnyObject) {
        
        if WXApi.isWXAppInstalled() {
            SVProgressHUD.showWithStatus("正在处理...", maskType: SVProgressHUDMaskType.Gradient)
            let model = MDPayTypeModel()
            model.fee = 11
            model.for_id = "123"
            model.order_type  = 1
            model.pay_type = 1
            model.sign_str = ""
            WXPayClient.shareInstance().payProduct(model, withNotify: AlipayNotifyURL)
            
        } else {
            SVProgressHUD.showErrorWithStatus("该设备未安装微信客户端")
        }
    }
    
    @IBAction func alipayAction(sender: AnyObject) {
     
        // 检测支付宝是否有安装
        
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: "alipay://")!) {
            let order = AIAliPayOrder(id: (12310 + Int(arc4random()%999)), title: "服务预定", content: "pay note", url: "http://asdfasdf.comasdom.domad", createdAt: "\(NSDate().timeIntervalSinceReferenceDate)", price: 10, paid: false, productID: (12310 + Int(arc4random()%9)))
            
            let aliOrder = AlipayOrder(partner: AlipayPartner, seller: AlipaySeller, tradeNO: order.id, productName: order.title, productDescription: order.content, amount: order.price, notifyURL: AlipayNotifyURL, service: "mobile.securitypay.pay", paymentType: "1", inputCharset: "utf-8", itBPay: "30m", showUrl: "m.alipay.com", rsaDate: nil, appID: nil)
            
            
            let orderSpec = aliOrder.description
            
            let signer = RSADataSigner(privateKey: AlipayPrivateKey)
            let signedString = signer.signString(orderSpec)
            
            let orderString = "\(orderSpec)&sign=\"\(signedString)\"&sign_type=\"RSA\""
            
            AlipaySDK.defaultService().payOrder(orderString, fromScheme: AppScheme, callback: {[weak self] resultDic in
                if let _ = self {
                    print("Alipay result = \(resultDic as Dictionary)")
                    let resultDic = resultDic as Dictionary
                    if let resultStatus = resultDic["resultStatus"] as? String {
                        if resultStatus == "9000" {
                            SVProgressHUD.showSuccessWithStatus("支付成功", maskType: SVProgressHUDMaskType.Gradient)
                            //strongSelf.navigationController?.popViewControllerAnimated(true)
                        } else {
                            SVProgressHUD.showInfoWithStatus("系统繁忙，请稍后再试")
                        }
                    }
                }
                })
            
        
        } else {
            SVProgressHUD.showErrorWithStatus("该设备未安装支付宝客户端")
        }
    }
}

class StrokeLineView: UIView {
    override func drawRect(rect: CGRect) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Color Declarations
        let color = UIColor(hexString: "fefefe", alpha: 0.66)
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPoint(x: 0, y: 0))
        bezierPath.addLineToPoint(CGPoint(x: rect.width, y: 0))
        color.setStroke()
        bezierPath.lineWidth = 0.5
        CGContextSaveGState(context)
        CGContextSetLineDash(context, 0, [6, 2], 2)
        bezierPath.stroke()
        CGContextRestoreGState(context)

    }
}


extension AIPaymentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard var cell: AIPayListInfoCellView = tableView.dequeueReusableCellWithIdentifier("CellID") as? AIPayListInfoCellView else {
            preconditionFailure("reusable cell not found")
        }
        if cell.arrowDirectIcon == nil {
            cell = AIPayListInfoCellView.initFromNib() as! AIPayListInfoCellView
        }
        let item = dataSource[indexPath.row]
        cell.setCellContent(item, isExpanded: self.expandedIndexPaths.contains(indexPath))
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1 {
            return UITableViewAutomaticDimension
        } else {
            return self.dynamicCellHeight(indexPath)
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.dynamicCellHeight(indexPath)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }      
    
    //MARK: table view delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.expandedIndexPaths.contains(indexPath) {
            let idx = self.expandedIndexPaths.indexOf(indexPath)
            self.expandedIndexPaths.removeAtIndex(idx!)
        } else {
            self.expandedIndexPaths.append(indexPath)
        }
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
        
    //MARK: compute cell height
    
    private func dynamicCellHeight(indexPath: NSIndexPath) -> CGFloat {
        
        struct StaticStruct {
            static var sizingCell: AIPayListInfoCellView?
            static var onceToken: dispatch_once_t = 0
            
        } // workaround to add static variables inside function in swift
        dispatch_once(&StaticStruct.onceToken) { () -> Void in
            StaticStruct.sizingCell = AIPayListInfoCellView.initFromNib() as? AIPayListInfoCellView
            
            //self.tableView.dequeueReusableCellWithIdentifier("CellID") as? AIPayListInfoCellView
        }
        
        let item = self.dataSource[indexPath.row]
        StaticStruct.sizingCell?.setCellContent(item, isExpanded: self.expandedIndexPaths.contains(indexPath))
        StaticStruct.sizingCell?.setNeedsUpdateConstraints()
        StaticStruct.sizingCell?.updateConstraintsIfNeeded()
        StaticStruct.sizingCell?.setNeedsLayout()
        StaticStruct.sizingCell?.layoutIfNeeded()
        guard let height = StaticStruct.sizingCell?.cellContentHeight() else {
            return 0
        }
        return height
    }
    

    
}
