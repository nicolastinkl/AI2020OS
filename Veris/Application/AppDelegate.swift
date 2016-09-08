//
//  AppDelegate.swift
//  AISBOSS

//  Created by tinkl on 4/8/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import CardDeepLinkKit
import AIAlertView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate {
	
	var window: UIWindow?
	//
	var didFinishGetSellerData: Bool = false
	var didFinishGetBuyerListData: Bool = false
	var didFinishGetBuyerProposalData: Bool = false
	
    private lazy var router: CDDeepLinkRouter = CDDeepLinkRouter()

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
		
        if WXApi.registerApp(WX_APPID, withDescription: "AIVers") {
            print("wx api register OK")
        }
		
		// 处理讯飞语音初始化
		AIAppInit().initWithXUNFEI()
		
		application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
		application.registerForRemoteNotifications()
		
		// Override point for customization after application launch.
		// self.window = AACustomWindow(frame: UIScreen.mainScreen().bounds)
		//configDefaultUser() //废弃
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
		
        //MARK: Share
        configUmengShare()
    
	// DeepLink
        router.registerBlock({ (deeplink) in
            
            debugPrint("deeplink1 \(deeplink.queryParameters)")
            
            // 1. Parser all the Property and unPackage.
            // 2. Send Notification to do somethings with logic.
            
            if let queryParameters = deeplink.queryParameters {
                //DeepLink Network Requseting.
                NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIDeepLinkupdateDeepLinkView, object: queryParameters)
            }
        }, route: "cddpl://.*")

        showRootViewController()
        handleLoacalNotifications()
        //处理app未启动时的抢单和远程协助请求
        handleRemoteNotifications(app: application, launchOptions: launchOptions)
		return true
		
	}
    
    /// redirect Log.
    func redirectConsoleLog() {
        #if DEBUG
            let documentDir: String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            print("documentPath : \(documentDir)")
            //重定向NSLog
            let logPath: NSString = documentDir.stringByAppendingString("/console.log")// NSURL(fileURLWithPath: documentDir).URLByAppendingPathComponent("console.log").absoluteString
            freopen(logPath.fileSystemRepresentation, "a+", stderr)
            
        #endif
    }
    
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        #if DEBUG
            FLEXManager.sharedManager().toggleExplorer()
            
            let i = AVInstallation.currentInstallation()
            i.removeObjectForKey(AIRemoteNotificationParameters.UserIdentifier)
            i.setObject(1234, forKey: AIRemoteNotificationParameters.UserIdentifier)
            i.saveInBackground()
            AIAlertViewController.showAlertView()
        #endif
    }
    

    /**
     config Umeng.
     */
    func configUmengShare() {
        //设置友盟社会化组件appkey
        UMSocialData.setAppKey("5784b6a767e58e5d1b003373")
        //设置微信AppId、appSecret，分享url
        //UMSocialWechatHandler.setWXAppId("wxdc1e388c3822c80b", appSecret: "a393c1527aaccb95f3a4c88d6d1455f6", url: "http://www.umeng.com/social")
        //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
        UMSocialQQHandler.setQQWithAppId("100424468", appKey: "c7394704798a158208a74ab60104f0ba", url: "http://www.umeng.com/social")

        //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和新浪微博后台设置的回调地址一致。http://open.weibo.com/developers/identity/edit
        UMSocialSinaSSOHandler.openNewSinaSSOWithAppKey("3921700954", secret: "04b48b094faeb16683c32669824ebdad", redirectURL: "http://sns.whalecloud.com/sina2/callback")
    }

    func setupBaiduMap() {
        _mapManager = BMKMapManager()
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        let ret = _mapManager?.start("Gs4nCfbzgrq5C99OHC4RBVSnfnNIAGqI", generalDelegate: self)
        if ret == false {
            NSLog("manager start failed!")
        }
    }
	/**
	 config lean Cloud.
	 */
	func configAVOSCloud() {
		
		AVOSCloudCrashReporting.enable()
        
        //根据语言选择leanCloud返回不同的语言信息
        AVOSCloud.setServiceRegion(AVServiceRegion.CN)
        
		AVOSCloud.setApplicationId(AIApplication.AVOSCLOUDID,
			clientKey: AIApplication.AVOSCLOUDKEY)
		
		AVOSCloud.registerForRemoteNotification()
		
		AVAnalytics.setAnalyticsEnabled(true)
		
        
        
	}
    
    
    
    //// Open URL
    func application(app: UIApplication, openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        application(app, openURL: url, sourceApplication: "", annotation: "")
        return true
    }

	func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
		
		AILog("openURL:\(url)")
        // DeepLink
        router.handleURL(url) { (complte, error) in
            AILog("info : \(complte) \(error) ")
        }

        // 分享跳转
        UMSocialSnsService.handleOpenURL(url)

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
                let alert = UIAlertView(title: "支付结果", message: strMsg, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
			}
		}
		
	}
	
	func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
		AILog("DeviceToken error : \(error.userInfo)")
	}
	
	func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject: AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
		AILog("\(userInfo)")
		
		AVAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
		
        AIRemoteNotificationHandler.defaultHandler().didReceiveRemoteNotificationUserInfo(userInfo)
	}
	
	func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
		
	}
	
	func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
		
		AVOSCloud.handleRemoteNotificationsWithDeviceToken(deviceToken)
		AILog("DeviceToken is :  \(deviceToken)")
        
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


    //MARK: Notificaion Handlers

    func handleLoacalNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(refreshReLoginAction), name: AIApplication.Notification.UserLoginTimeOutNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(logOut), name: AIApplication.Notification.UserLoginOutNotification, object: nil)
    }

    func handleRemoteNotifications(app app: UIApplication, launchOptions: [NSObject: AnyObject]?) {
        if let launchOptions = launchOptions {
            if let remoteUserInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey] {
                application(app, didReceiveRemoteNotification: remoteUserInfo as! [NSObject : AnyObject], fetchCompletionHandler: { (result) in
                    print("aa")
                })
            }
        }
    }

    func refreshReLoginAction() {

        let alertView = AIAlertView()
        alertView.showCloseButton = false
        alertView.addButton("确定") {
            AILocalStore.logout()
            let loginRootViewController = self.createLoginRootViewController()
            self.window!.rootViewController = loginRootViewController
        }
        alertView.showError("Oops！", subTitle: "登录超时,请重新登录~")
    }

    func logOut() {

        let alertView = AIAlertView()
        alertView.addButton("确定") {
            AILocalStore.logout()
            let loginRootViewController = self.createLoginRootViewController()
            self.window!.rootViewController = loginRootViewController
        }
        alertView.showNotice("真的要退出吗？亲~", subTitle: "", closeButtonTitle: "取消", duration: 0, colorStyle: 0xC1272D, colorTextButton: 0xFFFFFF)
    }

    func createLoginRootViewController() -> UINavigationController {
        let storyBoard: UIStoryboard = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AILoginStoryboard, bundle: nil)
        let loginVC = storyBoard.instantiateInitialViewController() as! AILoginViewController
        let loginRootViewController = UINavigationController(rootViewController: loginVC)

        return loginRootViewController
    }


    func showLoginViewController() {

        // 创建Root
        self.window = MBFingerTipWindow(frame: UIScreen.mainScreen().bounds)

        // 创建导航控制器
        let loginRootViewController = createLoginRootViewController()

        self.window?.rootViewController = loginRootViewController
        self.window?.makeKeyAndVisible()
    }

    func showMainViewController() {
        let root = AIRootViewController()
        let mainRootViewController = UINavigationController(rootViewController: root)
        mainRootViewController.navigationBarHidden = true

        self.window = MBFingerTipWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = mainRootViewController
        self.window?.makeKeyAndVisible()
    }

    func showRootViewController() {

        if AILocalStore.didUserLogIn() == true {
            showMainViewController()

        } else {
            showLoginViewController()
        }
    }

    //MARK: 配置默认用户
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
		let timeStamp: Int = Int(NSDate(timeIntervalSince1970: 0).timeIntervalSince1970)
		let token = (NSUserDefaults.standardUserDefaults().objectForKey("Default_Token") ?? "0") as! String
		let RSA = "23432"
		
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
