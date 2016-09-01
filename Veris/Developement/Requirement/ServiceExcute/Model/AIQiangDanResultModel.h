//
//  AIQiangDanResultModel.h
//  AIVeris
//
//  Created by 王坜 on 16/9/1.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

#import "JSONModel.h"
#import "AICustomerModel.h"


@protocol AIQiangDanServiceDetailModel
@end

@interface AIQiangDanServiceDetailModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *service_desc;

@end


@protocol AIQiangDanResultModel
@end

@interface AIQiangDanResultModel : JSONModel

@property (nonatomic, strong) AIQiangDanServiceDetailModel<Optional> *service_process;

@property (nonatomic, strong) AICustomerModel<Optional> *custtomer;

@end
