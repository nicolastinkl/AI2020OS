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
// 用户授权判断 0-不需要用户授权 1-需要用户授权
@property (strong, nonatomic) NSNumber<Optional> * permission_type;
// 服务步骤节点状态 0 – 未开始 1 – 执行中 2 – 执行完成
@property (strong, nonatomic) NSNumber<Optional> * status;
@property (strong, nonatomic) NodeInfo<Optional> * node_info;
@property (strong, nonatomic) NSArray<NodeParam, Optional> * param_list;

@end


@interface NodeParam : JSONModel

@property (strong, nonatomic) NSNumber<Optional> * id;
@property (strong, nonatomic) NSString<Optional> * name;
@property (strong, nonatomic) NSString<Optional> * value;

@end

