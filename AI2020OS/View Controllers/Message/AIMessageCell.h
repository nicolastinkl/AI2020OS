//
//  AIMessageCell.h
//  AI2020OS
//
//  Created by 王坜 on 15/8/17.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AIMessageCell : UITableViewCell

@property (nonatomic, readonly) UILabel *timeLabel;


- (void)makeActions:(NSArray *)actions;



@end
