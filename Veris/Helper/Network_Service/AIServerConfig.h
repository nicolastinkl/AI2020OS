//
//  AIServerConfig.h
//  AITrans
//
//  Created by 王坜 on 15/8/10.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//


// 服务器地址


#if DEBUG
//    internal static let KURL_ReleaseURL = "http://localhost:3006" // zx debug ip
#define kURL_Base @"http://171.221.254.231:2999/nsboss"
#else
#define kURL_Base @"http://171.221.254.231:2999/nsboss" // RELEASE 服务器根地址
#endif



#define kURL_GetServiceList                 [NSString stringWithFormat:@"%@%@",kURL_Base, @"/getservicelist"]  //TEST..

#define kURL_QuerySellerOrderList            [NSString stringWithFormat:@"%@%@",kURL_Base, @"/order/querySellerOrderList"]

// 关键字(字段名)
#define kKey_ServiceID     @"serviceID"
#define kKey_SchemeID      @"sheme_id"