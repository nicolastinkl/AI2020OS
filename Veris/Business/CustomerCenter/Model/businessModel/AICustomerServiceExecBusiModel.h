//
//  AICustomerServiceExecBusiModel.h
//  AIVeris
//
//  Created by 刘先 on 7/26/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"

@protocol AITimelineBusiModel


@end

@interface AITimelineBusiModel : JSONModel

@property (assign, nonatomic) NSInteger service_id;

@property (strong, nonatomic) NSString<Optional> * service_thumbnail_icon;

@end
