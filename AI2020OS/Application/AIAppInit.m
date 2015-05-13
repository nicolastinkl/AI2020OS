//
//  AIAppInit.m
//  AI2020OS
//
//  Created by tinkl on 14/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

#import "AIAppInit.h"

#import "iflyMSC/iflySetting.h" 
#import "iflyMSC/IFlySpeechUtility.h"
#import "IFlyFlowerCollector.h"

#define APPID_VALUE           @"551ba83b"
#define URL_VALUE             @""                 // url
#define TIMEOUT_VALUE         @"20000"            // timeout      连接超时的时间，以ms为单位
#define BEST_URL_VALUE        @"1"                // best_search_url 最优搜索路径

@implementation AIAppInit

-(void) xfINIT
{
    //设置log等级，此处log为默认在app沙盒目录下的msc.log文件
    [IFlySetting setLogFile:LVL_ALL];
    
    //输出在console的log开关
    [IFlySetting showLogcat:YES];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    //设置msc.log的保存路径
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,timeout=%@",APPID_VALUE,TIMEOUT_VALUE];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
    
    
    [IFlyFlowerCollector SetDebugMode:YES];
    [IFlyFlowerCollector SetCaptureUncaughtException:YES];
    [IFlyFlowerCollector SetAppid:APPID_VALUE];
    [IFlyFlowerCollector SetAutoLocation:YES];
    
}
@end
