//
//  ExcuteModel.h
//  AIVeris
//
//  Created by Rocky on 16/8/31.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"
#import "ExcuteModel.h"
#import <UIKit/UIKit.h>
#import "AICustomerModel.h"


@protocol NodeResultContent
@end

@protocol Procedure
@end

@protocol NodeInfo
@end

@protocol NodeParam
@end

@interface NodeResultContent : JSONModel

// 提交类型：Text, Voice, Picture
@property (strong, nonatomic) NSString<Optional> * note_type;
@property (strong, nonatomic) NSString<Optional> * note_content;
// 当note_type为Voice时，voice_length为声音文件的长度，单位是秒
@property (strong, nonatomic) NSString<Optional> * voice_length;

@end


@protocol ServiceNodeResult
@end

@interface ServiceNodeResult : JSONModel

@property (strong, nonatomic) NSNumber<Optional> * procedure_inst_id;
@property (strong, nonatomic) NSArray<NodeResultContent, Optional> * note_list;

@end

@protocol RequestCode
@end

@interface RequestCode : JSONModel

@property (nonatomic, assign) NSInteger result_code;

@end



@interface NodeInfo : JSONModel

@property (strong, nonatomic) NSString<Optional> * node_title;
// 节点详情图片
@property (strong, nonatomic) NSString<Optional> * node_pic;
@property (strong, nonatomic) NSString<Optional> * node_desc;

@end

@interface Procedure : JSONModel

@property (strong, nonatomic) NSNumber<Optional> * procedure_inst_id;
// 用户授权判断 1-权限标志 2-确认标志 3-只读服务节点标志
@property (strong, nonatomic) NSNumber<Optional> * permission_type;
// permission_value的值根据permission_type值的不同，含义不同
/*
permission_type值	permission_value描述
1	0 – 未授权， 1 – 已授权， 2 – 忽略
2	0 – 未确认， 1 – 已确认
3	0 – 未读，   1 – 已读
 */
@property (strong, nonatomic) NSNumber<Optional> * permission_value;
// 服务步骤节点状态 0 – 未开始 1 – 执行中 2 – 执行完成
@property (strong, nonatomic) NSNumber<Optional> * status;
@property (strong, nonatomic) NodeInfo<Optional> * node_info;
@property (strong, nonatomic) NSArray<NodeParam, Optional> * param_list;

@end


@interface NodeParam : JSONModel

@property (strong, nonatomic) NSNumber<Optional> * id;
@property (strong, nonatomic) NSString<Optional> * name;
@property (strong, nonatomic) NSString<Optional> * value;
@property (strong, nonatomic) NSString<Optional> * icon;

@end

