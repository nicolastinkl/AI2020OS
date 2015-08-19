//
//  AITipModel.h
//  AI2020OS
//  小费数据模型
//  Created by Rocky on 15/8/18.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//



#import "JSONModel.h"


@interface AITipModel : JSONModel

@property (assign,nonatomic) int value;
@property (strong,nonatomic) NSString* desc;

@end

