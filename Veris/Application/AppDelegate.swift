//
//  AppDelegate.swift
//  AISBOSS

//  Created by tinkl on 4/8/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate {
	
	var window: UIWindow?
	//
	var didFinishGetSellerData: Bool = false
	var didFinishGetBuyerListData: Bool = false
	var didFinishGetBuyerProposalData: Bool = false
	
	var sellerData: NSDictionary?
    var buyerListData: ProposalOrderListModel?
    var buyerProposalData: AIProposalPopListModel?
    var dataSourcePop = [AIBuyerBubbleModel]()
    
	let WX_APPID: String = "wx483dafc09117a3d0"
    var _mapManager: BMKMapManager?
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		
		// AVOS
		configAVOSCloud()
        setupBaiduMap()
		AVAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
		AVAnalytics.setChannel("App Store")
		
		IQKeyboardManager.sharedManager().enable = true
		
		// WeChat Pay
		
		WXApi.registerApp(WX_APPID, withDescription: "AIVers")
		
		// 处理讯飞语音初始化
		AIAppInit().initWithXUNFEI()
		
		application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
		application.registerForRemoteNotifications()
		
		// Override point for customization after application launch.
		// self.window = AACustomWindow(frame: UIScreen.mainScreen().bounds)
		configDefaultUser()
		initNetEngine()
		
		// 设置状态栏隐藏
		application.statusBarHidden = true
		application.setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
		// 设置状态栏高亮
		application.statusBarStyle = UIStatusBarStyle.LightContent
		application.setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
		
		// 检查录音权限
		AVAudioSession.sharedInstance().requestRecordPermission({ (granted: Bool) -> Void in
			
			do {
				try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
				try AVAudioSession.sharedInstance().setActive(true)
			} catch {
			}
		})
		
		showRootViewControllerReal()


    


		return true
		
	}

	
    func setupBaiduMap() {
        _mapManager = BMKMapManager()
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        let ret = _mapManager?.start("在此处输入您的授权Key", generalDelegate: self)
        if ret == false {
            NSLog("manager start failed!")
        }
    }
	/**
	 config lean Cloud.
	 */
	func configAVOSCloud() {
		
		AVOSCloudCrashReporting.enable()
		
		AVOSCloud.setApplicationId(AIApplication.AVOSCLOUDID,
			clientKey: AIApplication.AVOSCLOUDKEY)
		
		AVOSCloud.registerForRemoteNotification()
		
		AVAnalytics.setAnalyticsEnabled(true)
		
	}
	
	/**
	 Open URL

	 - parameter application:       <#application description#>
	 - parameter url:               <#url description#>
	 - parameter sourceApplication: <#sourceApplication description#>
	 - parameter annotation:        <#annotation description#>

	 - returns: <#return value description#>
	 */
	
	func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
		
		AILog("openURL:\(url.absoluteString)")
		// 微信支付跳转
		if url.scheme == WX_APPID {
			return WXApi.handleOpenURL(url, delegate: self)
		}
		
		if url.host == "safepay" {
			// 跳转支付宝钱包进行支付，处理支付结果
			AlipaySDK.defaultService().processOrderWithPaymentResult(url, standbyCallback: { (resultDict: [NSObject: AnyObject]!) -> Void in
				if resultDict != nil {
					
					if let resultCode = resultDict["resultStatus"] as? Int {
						if resultCode == 9000 {
							NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.WeixinPaySuccessNotification, object: nil)
						} else {
							let alert = UIAlertView(title: "支付失败", message: resultDict["memo"] as? String ?? "", delegate: nil, cancelButtonTitle: "OK")
							alert.show()
						}
					}
				}
				AILog("openURL result: \(resultDict)")
			})
			
		}
		
		return true
	}
	
	func onResp(resp: BaseResp!) {
		
		var strMsg = "\(resp.errCode)"
		if resp.isKindOfClass(PayResp) {
			switch resp.errCode {
			case 0:
				NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.WeixinPaySuccessNotification, object: nil)
			default:
				strMsg = "支付失败，请您重新支付!"
				AILog("retcode = \(resp.errCode), retstr = \(resp.errStr)")
			}
		}
		let alert = UIAlertView(title: "支付结果", message: strMsg, delegate: nil, cancelButtonTitle: "OK")
		alert.show()
	}
	
	func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
		AILog("\(error.userInfo)")
	}
	
	func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject: AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
		AILog("\(userInfo)")
		
		AVAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
		
	}
	
	func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
		
	}
	
	func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
		
		AVOSCloud.handleRemoteNotificationsWithDeviceToken(deviceToken)
		AILog("DeviceToken OK")
		
	}
	
	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}
	
	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}
	
	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}
	
	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		let num = application.applicationIconBadgeNumber
		if num > 0 {
			let install = AVInstallation.currentInstallation()
			install.badge = 0
			install.saveEventually()
			application.applicationIconBadgeNumber = 0
		}
		application.cancelAllLocalNotifications()
		
	}
	
	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
	
	func configDefaultUser () {
		
		var defaultUserID = "100000002410"
		var defaultUserType = "101"
		
		if let userID: String = NSUserDefaults.standardUserDefaults().objectForKey(kDefault_UserID) as? String {
			defaultUserID = userID
			
			if let type = NSUserDefaults.standardUserDefaults().objectForKey(kDefault_UserType) {
				defaultUserType = type as! String
			}
			AILog("Default UserID is " + userID)
		} else {
			NSUserDefaults.standardUserDefaults().setObject(defaultUserID, forKey: kDefault_UserID)
			NSUserDefaults.standardUserDefaults().setObject(defaultUserType, forKey: kDefault_UserType)
			NSUserDefaults.standardUserDefaults().synchronize()
		}
		
		// 配置语音协助定向推送
		if defaultUserType == "100" {
			AIRemoteNotificationHandler.defaultHandler().addNotificationForUser(defaultUserID)
		} else {
			AIRemoteNotificationHandler.defaultHandler().removeNotificationForUser(defaultUserID)
		}
	}
	
	private func initNetEngine() {
		let timeStamp: Int = 0
		let token = "0"
		let RSA = "0"
		
		let userID = (NSUserDefaults.standardUserDefaults().objectForKey("Default_UserID") ?? "100000002410") as! String
		
		if userID == "100000002410" {
			NSUserDefaults.standardUserDefaults().setObject(userID, forKey: "Default_UserID")
			NSUserDefaults.standardUserDefaults().synchronize()
		}
		
		let splitedarray = ["\(timeStamp)", token, userID, RSA] as [String]
		
		var headerContent: String = ""
		
		for i in 0 ..< splitedarray.count {
			let str = splitedarray[i]
			headerContent += str
			
			if i != 3 {
				headerContent += "&"
			}
			
		}
		
		let header = ["HttpQuery": headerContent]
		AINetEngine.defaultEngine().configureCommonHeaders(header)
	}
	
	func application(app: UIApplication, openURL url: NSURL, options: [String: AnyObject]) -> Bool {
		let path = url.lastPathComponent
		
		AILog(path)
		return true
	}
	
	func showRootViewControllerReal() {
		// 创建Root
		self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
		let root = AIRootViewController()
		// 创建导航控制器
		let nav = UINavigationController(rootViewController: root)
		nav.navigationBarHidden = true
		self.window?.rootViewController = nav
		self.window?.makeKeyAndVisible()
	}
	
}
extension AppDelegate: BMKGeneralDelegate {
    
    /**
     *返回网络错误
     *@param iError 错误号
     */
    func onGetNetworkState(iError: Int32) {
        
    }
    
    /**
     *返回授权验证错误
     *@param iError 错误号 : 为0时验证通过，具体参加BMKPermissionCheckResultCode
     */
    func onGetPermissionState(iError: Int32) {
        
    }
    
}
