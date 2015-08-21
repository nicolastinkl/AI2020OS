//
//  AIMessageCell.h
//  AI2020OS
//
//  Created by 王坜 on 15/8/17.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AIMessageCellBlock)(NSDictionary *action);

@interface AIMessageCell : UITableViewCell

@property (nonatomic, readonly) UILabel *timeLabel;
@property (nonatomic, strong) NSString *textLabelStartString;
@property (nonatomic, strong) NSString *textLabelEndString;
@property (nonatomic, readonly) BOOL isExpend;


+ (CGFloat)defaultCellHeight;

- (void)expendSelfCompletion:(void(^)(BOOL isExpend))completion;



- (void)makeActions:(NSArray *)actions block:(AIMessageCellBlock)block;



@end
