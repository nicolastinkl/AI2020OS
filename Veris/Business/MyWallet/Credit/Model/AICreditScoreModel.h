//
//  AICreditScoreModel.h
//  AIVeris
//
//  Created by 王坜 on 16/11/9.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"

@protocol AICreditScoreModel 

@end
@interface AICreditScoreModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *credit_score_amount;

@property (nonatomic, strong) NSString<Optional> *rank_in_friends;

@property (nonatomic, strong) NSString<Optional> *assess_time;

@end
