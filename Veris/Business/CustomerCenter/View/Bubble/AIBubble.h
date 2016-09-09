//
//  AIBubble.h
//  AIVeris
//
//  Created by 王坜 on 15/10/22.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import <UIKit/UIKit.h>



//由于swift 编译不过 注释掉了这个枚举
typedef enum  {

    typeToAdd = 0,//
    typeToNormal = 1, // shoucang
    typeToSignIcon = 2,// tuijian
    typeToWish = 3,  // wish
    typeToWishQuery = 4,  // wish Query
    
}BubbleType;


@class AIBuyerBubbleModel;
@interface AIBubble : UIView
{
    CGColorSpaceRef colorSpaceRef;
    CGColorRef glowColorRef;
}
@property (nonatomic) BOOL hadRecommend;

@property (nonatomic) CGFloat radius;
@property (nonatomic) NSInteger index;

//类型
@property (nonatomic) NSInteger bubbleType;
//是否发光
@property (nonatomic) CGFloat isLight;
//是否周边有小气泡标识
@property (nonatomic) BOOL hasSmallBubble;

@property (nonatomic) CGSize glowOffset;

@property (nonatomic) CGFloat glowAmount;

@property (nonatomic, strong) UIColor *glowColor;

@property (nonatomic, strong) UIImageView *rotateBubleImageView;

@property (nonatomic, strong) UIImageView *rotateImageView;

@property (nonatomic, strong) AIBuyerBubbleModel *bubbleModel;

@property (nonatomic, strong) UIView *superAIBubblesView;

@property (nonatomic) CGFloat floatSize;


+ (CGFloat)bigBubbleRadius;

+ (CGFloat)midBubbleRadius;

+ (CGFloat)smaBubbleRadius;

+ (CGFloat)tinyBubbleRadius;

- (instancetype)initWithFrame:(CGRect)frame model:(AIBuyerBubbleModel *)model;

- (instancetype)initWithCenter:(CGPoint)center model:(AIBuyerBubbleModel *)model type:(NSInteger)type Index:(NSInteger)indexModel;


@end
