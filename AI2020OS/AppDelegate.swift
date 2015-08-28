//
//  AppDelegate.swift
//  AI2020OS
//
//  Created by tinkl on 30/3/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    struct AppDelegateStatic {
        static var token: dispatch_once_t = 0
    }
    
    var window: UIWindow?
    
    var rootNavigationController:UINavigationController?
    
    var backgroudtask: UIBackgroundTaskIdentifier = 0
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //AVOS
        AVOSCloud.setApplicationId(AIApplication.AVOSCLOUDID,
              clientKey: AIApplication.AVOSCLOUDKEY)

        // DEBUG
        AVAnalytics.setCrashReportEnabled(true)
//        AVAnalytics.setAnalyticsEnabled(true)
//        AVOSCloud.setVerbosePolicy(kAVVerboseShow)
//        AVLogger.addLoggerDomain(AVLoggerDomainIM)
//        AVLogger.addLoggerDomain(AVLoggerDomainCURL)
//        AVLogger.setLoggerLevelMask(AVLoggerLevelAll.value)
        
        //处理讯飞语音初始化
        AIAppInit().xfINIT()
        
        initNetEngine()

        //UIApplication.sharedApplication().applicationIconBadgeNumber
        
        //Hook Viewdidview and ViewDidDisappear.
        
        dispatch_once(&AppDelegateStatic.token) {
            AIApplication.hookViewDidLoad()
            AIApplication.hookViewWillAppear()
            AIApplication.hookViewWillDisappear()
        }
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
    
        self.configureRemoteNotification(application)
        // config weibo
        WeiboSDK.enableDebugMode(true);
        WeiboSDK.registerApp("2045436852");
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        /*
        
        beginBackgroudupdateTask()

        Async.background(after: 5) {
            // do somethings
            let localNotify =  UILocalNotification()
//            localNotify.alertAction = "查看"
            localNotify.alertBody = "收藏夹有新动态"
            localNotify.timeZone = NSTimeZone.defaultTimeZone()
            //localNotify.repeatInterval = NSCalendarUnit.CalendarCalendarUnit
            localNotify.applicationIconBadgeNumber = 0
            localNotify.userInfo = ["key":"name"]
            localNotify.fireDate = NSDate(timeIntervalSinceNow: 5)
            UIApplication.sharedApplication().scheduleLocalNotification(localNotify)
        }
        
        */
        
        
    }
    
    func beginBackgroudupdateTask(){
        backgroudtask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
            
        }
    }
    
    func endBackgroudUpdateTask(){
        UIApplication.sharedApplication().endBackgroundTask(backgroudtask)
        
        self.backgroudtask = UIBackgroundTaskInvalid
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        // endBackgroudUpdateTask()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {

        println(notification)
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        //Optional("readtext") , nil , Optional("com.apple.mobilesafari")
        logInfo("\(url.scheme) , \(url) , \(sourceApplication)")
        

        switch url.host! {
            
        case "browseServiceDetail":
            
            let controller:AIServiceDetailsViewCotnroller = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AIMainStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewIdentifiers.AIServiceDetailsViewCotnroller) as AIServiceDetailsViewCotnroller
            controller.server_id = "1"
            //showViewController(controller, sender: self)            
            UIApplication.sharedApplication().keyWindow?.rootViewController?.showViewController(controller, sender: UIApplication.sharedApplication().keyWindow?.rootViewController!)
            
            break
            
        case "browseMore":

            break
            
            
        default:
            break
        }
        
        return true
    }
    
    private func initNetEngine() {
        let timeStamp: Int = 0
        let token = "0"
        let userId = kUser_ID
        let RSA = "0"
        
        let headerContent = "\(timeStamp)&" + token+"&" + userId+"&" + RSA
        
        let header = [kHttp_Header_Query: headerContent]
        AINetEngine.defaultEngine().configureCommonHeaders(header)
    }
    
    func configureRemoteNotification(application: UIApplication) {


    var settings : UIUserNotificationSettings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound, categories: nil)

    application.registerUserNotificationSettings(settings)
    application.registerForRemoteNotifications();
    AVPush.setProductionMode(true)
    application.applicationIconBadgeNumber = 0
        
    // save user
    var currentInstallation : AVInstallation = AVInstallation.currentInstallation()
    currentInstallation.setObject(kUser_ID, forKey: "owner")
    currentInstallation.saveInBackground()
        
    }
    
    
    // remote notification
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println(error)
    }
    
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        application.applicationIconBadgeNumber = 0
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        var currentInstallation : AVInstallation = AVInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.saveInBackground()
  
    }
    
    //
    func didReceiveWeiboResponse(response: WBBaseResponse!) {
        
        if response.isKindOfClass(WBSendMessageToWeiboResponse.self)
        {
            
            var success:Bool = response.statusCode == WeiboSDKResponseStatusCode.Success
            
            var title:NSString = success ? "微博分享成功" : "微博分享失败"
            
            var alert:UIAlertView = UIAlertView(title: title, message: nil, delegate: nil, cancelButtonTitle: "确定");
            alert.show()
            
            var sendMessageToWeiboResponse:WBSendMessageToWeiboResponse = response as WBSendMessageToWeiboResponse;
            var accessToken:NSString = sendMessageToWeiboResponse.authResponse.accessToken
            
            if accessToken.length > 0 {
                AIWeiboData.instance().wbtoken = accessToken
            }
            var userID:NSString = sendMessageToWeiboResponse.authResponse.userID
            if userID.length > 0 {
                AIWeiboData.instance().wbCurrentUserID = userID;
            }
            
        }
        
        
    }
    
    func didReceiveWeiboRequest(request: WBBaseRequest!) {
        
    }
}

