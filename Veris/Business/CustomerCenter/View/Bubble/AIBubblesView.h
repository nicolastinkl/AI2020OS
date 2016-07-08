//
//  AIBubblesView.h
//  AIVeris
//
//  Created by 王坜 on 15/10/21.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AIBubble.h"

typedef void (^BubbleBlock)(AIBuyerBubbleModel *model, AIBubble *bubble);

@class AIBuyerBubbleModel;

@interface AIBubblesView : UIView

- (id)initWithFrame:(CGRect)frame models:(NSMutableArray *)models;

- (void)addGestureBubbleAction:(BubbleBlock)block;

@end
