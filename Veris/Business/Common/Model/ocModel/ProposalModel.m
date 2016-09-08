//
//  ProposalModel.m
//  AIVeris
//
//  Created by Rocky on 15/10/22.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "ProposalModel.h"


@implementation AIBaseModel


//Make all model properties optional (avoid if possible)
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

-(instancetype)initWithDictionary:(NSDictionary*)dict {
    return (self = [[super init] initWithDictionary:dict error:nil]);
}

@end

@implementation ServiceOrderModel
- (id) init
{
    self = [super init];
    
    if (self) {
        _name = @"";
        _image = @"";
    }
    
    return self;
}
@end

@implementation KeypointModel
@end

@implementation InfoDetailModel
@end


@implementation ArrangeScriptModel
@end

@implementation ProposalOrderListModel
@end

@implementation ProposalOrderModel
- (id) init
{
    self = [super init];
    
    if (self) {
        _name = @"";
        _messages = 0;
        _state = @"";
    }
    
    return self;
}
@end

@implementation ServiceNodeModel
- (id) init
{
    self = [super init];
    
    if (self) {
        _type = @"";
        _provider_icon = @"";
        _provider_nbr = @"";
        _title = @"";
        _desc = @"";
        _state = @"";
        _time = 0;
    }
    
    return self;
}
@end

@implementation ServiceContentModel
@end

@implementation MapContentModel
@end

@implementation AIProposalServiceModel

- (id) init
{
    self = [super init];
    
    if (self) {
        _service_rating_level = -1;
        _is_expend = 0;
        _service_del_flag = 1;
    }
    
    return self;
}


@end

@implementation AIProposalProvider
@end

@implementation AIProposalInstModel

- (id) init
{
    self = [super init];
    
    if (self) {
        // 临时添加初始值，服务器暂时没有做算费模型，没有这个字段
        _proposal_price = @"€891+/month";
    }
    
    return self;
}

@end
@implementation ParamModel



@end

@implementation AIProposalHopeModel
@end

@implementation AIProposalServicePriceModel
@end

@implementation AIProposalHopeAudioTextModel
@end

@implementation AIProposalNotesModel
@end

/**
 *  @author tinkl, 15-12-01 11:12:52
 *
 *  @brief  detail
 *
 *  @since <#version number#>
 */
@implementation AIProposalServiceDetailIntroImgModel
@end

@implementation AIProposalServiceDetailProviderModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"sid"
                                                       }];
}

@end

@implementation AIProposalServiceDetailParamModel
@end

@implementation AIProposalServiceDetailParamValueModel
//sid

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"sid"
                                                       }];
}
@end

@implementation AIProposalServiceDetailRatingItemModel
@end

@implementation AIProposalServiceDetailRatingCommentModel
@end

@implementation AIProposalServiceDetailRatingModel
@end

@implementation AIProposalServiceDetailLabelModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"label_id"
                                                       }];
}

@end

@implementation AIProposalServiceDetailHopeModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"hope_id",
                                                       @"duration": @"time"
                                                       }];
}

@end

@implementation AIProposalServiceDetail_WishModel
@end

@implementation AIProposalServiceDetailModel
@end



@implementation AIProposalServiceParamRelationModel
@end

@implementation AIRelationParamItemModel
@end

@implementation AIParamRelationModel
@end


/////AIServiceDetailDisplayModel
@implementation AIServiceDetailDisplayModel

@end



