//
//  AIBodyDescModel.h
//  AI2020OS
//
//  Created by admin on 15/8/24.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"
#define MODE_PLAIN_TEXT    0
#define MODE_BASE64        1

@interface AIBodyDescModel : JSONModel

// 数据模式 MODE_PLAIN_TEXT:明文传输, MODE_BASE64:Base64加密传输
@property (assign,nonatomic) int data_mode;
// 报文摘要 MD5校验
@property (strong,nonatomic) NSString<Optional>* digest;

@end
