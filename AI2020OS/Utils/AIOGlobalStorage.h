//
//  AIOGlobalStorage.h
//  AI2020OS
//
//  Created by 王坜 on 15/8/30.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AIOGlobalStorage : NSObject

+ (instancetype)defaultStorage;


@property (nonatomic, weak) UINavigationController *shelfNavigationController;

@end
