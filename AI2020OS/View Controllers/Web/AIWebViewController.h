//
//  AIWebViewController.h
//  AI2020OS
//
//  Created by 王坜 on 15/8/14.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDVViewController.h"

@interface AICDWebViewController : CDVViewController<UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL shouldHideNavigationBar;

@end
