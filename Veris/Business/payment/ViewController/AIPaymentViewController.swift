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
    
    let AppScheme:String = "AIVeris"
    
    let AlipayPartner:String = "2088311868782039"
    let AlipaySeller:String = "liaojy@sudiyi.net"
    let AlipayPrivateKey:String = "MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAL8lcOW8NKC0XOhhxzmy5GyhtQtpQWqsE/6+A067VeLLObDKQrC1qMt/7oOMD1KW1Mv0/b3b0UzlxrGDamcJod6VQyZoln8txkhklMFfKX3lM/FOYcXz5wS7GRU4AjiLJaLBWsP3UOrCzNM+bvgv6rMJgIUpyhtyHkrdVAQSBDc5AgMBAAECgYBG0v2o8fpiDVJbfFdQRruikKw/ZSmq98WU3xzkoD8rgHeIzPi29yhq9qUOsue+h0qjo8wc/ATqRD1B6tqTARurdFuEspNakYafAe2waVVd4aRg7Vxh9Ju908+UkKQ+DNqmzvoMkVz2Z1CaBdEbC6kKVd3q8IBsmNPr0OmjyII4AQJBAOogQgJuSNlFP5QyZcCmEN7RsH53NyccXeolCBpfWE0WE0NTE/bblY13az1nnW5/dm9/8PkiZ5fmqlH7GlCFXDkCQQDRATVym2gyWviNSQrHuc0ThE88ouM2c0Whh45PWyNy7Fz3er2z12ksMX7Vl8aTHa/s5OWNMSnMMMSPCvoIG7MBAkA5okk9mfJ68c4N6D4eJ4M9prbg2u4LxbLkwcr12wS8rTN+vkPK4BE3qu8ORaR+oAgCuKcUXUDNJu5EkiDPM5UZAkEAyMlQf3ms8DNU9OZm5NkqmsVRGf+iKH01N6jynmn/9Df+WAIinNMkxsAGCUx2CH9Ms1hy7uF8Nh3jt0fkTEXQAQJBAJLVRSUf6FCxL/MYxd1Ls8us7FU+bzRhXkR6m3lurUyRItkrtbv2kdpegBHxWCTRddf0l0Fpbvh21ShzQ/NKGns="
    
    let AlipayNotifyURL:String = "http://www.yourdomain.com/order/alipay_notify_app"
    
    @IBOutlet weak var providerIcon: AIImageView!
    
    @IBOutlet weak var providerName: UILabel!
    
    @IBOutlet weak var providerLevel: UIView!
    @IBOutlet weak var weixinButton: UIButton!
    @IBOutlet weak var alipayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        if let navi = AINavigationBar.initFromNib() as? AINavigationBar {
//            view.addSubview(navi)
//            navi.holderViewController = self
//            constrain(navi, block: { (layout) in
//                layout.left == layout.superview!.left
//                layout.top == layout.superview!.top
//                layout.right == layout.superview!.right
//                layout.height == 44.0 + 10.0
//            })
//        }
        
        layoutSubView()
    }
    
    func layoutSubView(){
        
        providerName.text = "孕检无忧"
        
        if let starRateView = CWStarRateView(frameAndImage: CGRect(x: 0, y: 5, width: 60, height: 11), numberOfStars: 5, foreground: "star_rating_results_highlight", background: "star_rating_results_normal" ) {
            starRateView.userInteractionEnabled = false
            let score: CGFloat = 5
            starRateView.scorePercent = score / 10
            providerLevel.addSubview(starRateView)
            
            let label = UILabel()
            label.text = "\(score)"
            label.font = UIFont.systemFontOfSize(12)
            label.textColor = AITools.colorWithR(253, g: 225, b: 50)
            label.frame = CGRectMake(starRateView.right + 5, 1, 40, 20)
            providerLevel.addSubview(label)
            
            let zanlabel = UILabel()
            zanlabel.text = "12345"
            zanlabel.font = UIFont.systemFontOfSize(12)
            zanlabel.textColor = UIColor.whiteColor()
            zanlabel.frame = CGRectMake(label.right + 5, 1, 40, 20)
            providerLevel.addSubview(zanlabel)
            
        }
    }
    
    @IBAction func callPhone(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "tel:13888888888")!)
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
            
        }else{
            SVProgressHUD.showErrorWithStatus("该设备未安装微信客户端")
        }
        
    }
    
    @IBAction func alipayAction(sender: AnyObject) {
     
        let order = AIAliPayOrder(id: 1, title: "alipay", content: "pay note", url: "", createdAt: "", price: 0, paid: false, productID: 0)
        
        let aliOrder = AlipayOrder(partner: AlipayPartner, seller: AlipaySeller, tradeNO: order.id, productName: order.title, productDescription: order.content, amount: order.price, notifyURL: AlipayNotifyURL, service: "mobile.securitypay.pay", paymentType: "1", inputCharset: "utf-8", itBPay: "30m", showUrl: "m.alipay.com", rsaDate: nil, appID: nil)
        
        
        let orderSpec = aliOrder.description //orderA.description
        
        let signer = RSADataSigner(privateKey: AlipayPrivateKey)
        let signedString = signer.signString(orderSpec)
        
        let orderString = "\(orderSpec)&sign=\"\(signedString)\"&sign_type=\"RSA\""
        
        print(orderString)
        
        AlipaySDK.defaultService().payOrder(orderString, fromScheme: AppScheme, callback: {[weak self] resultDic in
            if let _ = self {
                print("Alipay result = \(resultDic as Dictionary)")
                let resultDic = resultDic as Dictionary
                if let resultStatus = resultDic["resultStatus"] as? String {
                    if resultStatus == "9000" {
                        //strongSelf.delegate?.paymentSuccess(paymentType: .Alipay)
                        SVProgressHUD.showSuccessWithStatus("支付成功", maskType: SVProgressHUDMaskType.Gradient)
                        //strongSelf.navigationController?.popViewControllerAnimated(true)
                    } else {
//                        strongSelf.delegate?.paymentFail(paymentType: .Alipay)
                        SVProgressHUD.showInfoWithStatus("支付失败，请您重新支付！")
                    }
                }
            }
            })
        
    }
    
    

}
