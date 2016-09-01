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


