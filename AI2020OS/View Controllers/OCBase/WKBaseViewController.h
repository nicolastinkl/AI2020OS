//
//  WKBaseViewController.h
//  WokWok
//
//  Created by 王坜 on 15/8/13.
//  Copyright (c) 2015年 王坜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AIViews.h"
#import "WKMacroConstants.h"
#import "WKMacroUtils.h"

@interface WKBaseViewController : UIViewController

@property (nonatomic, strong) UIView *customNavigationBar; // 自定义导航栏

@property (nonatomic, assign) CGFloat customNavigationBarHeight; // 自定义导航栏的高度

@property (nonatomic, strong) UIScrollView *contentView; // 内容区，默认所有subview都应该添加到这上面

@property (nonatomic, assign) CGFloat contentWidth; // contentView 宽度

@property (nonatomic, assign) CGFloat contentHeight; // contentView 高度

@property (nonatomic, assign) CGRect contentOriginalFrame; // contentView 原始Frame


/*说明：隐藏自定义导航栏,contentViewFrame会随着变化
 *
 */
- (void)setCustomNavigationBarHidden:(BOOL)hidden;

- (void)showLoadingMessage:(NSString *)message;

- (void)dismissLoading;


@end
