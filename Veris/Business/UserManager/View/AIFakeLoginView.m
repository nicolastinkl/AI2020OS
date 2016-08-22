//
//  AIFakeLoginViewController.m
//  AIVeris
//
//  Created by 王坜 on 15/12/14.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIFakeLoginView.h"
#import "AITools.h"
#import "AIViews.h"
#import "AINetEngine.h"
#import "AINotifications.h"
#import "AIFakeUser.h"
#import <AVOSCloud/AVOSCloud.h>
#import "Veris-Swift.h"

#define kMargin           20
#define kCustomer1_id     100000002410
#define kProvider1_id     200000002501
#define kProviderDavid    200000001635


@interface AIFakeLoginView ()
{
    UIImageView *_buyerTitleImageView;
    UIImageView *_sellerTitleImageView;
}


@property (nonatomic, weak) AIFakeUser *currentUser;

@end

@implementation AIFakeLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self makeBackground];
        [self makeProviderArea];
        [self makeCustomerArea];
        [self makeDefaultUser];
    }
    
    return self;
}

- (void)makeDefaultUser
{
    AIUser *user = [AIUser currentUser];
    
    NSInteger userID = user.id;
    
    if (userID == kCustomer1_id) {
        _buyerTitleImageView.highlighted = YES;
    }
    else if (userID == kProvider1_id)
    {
        _sellerTitleImageView.highlighted = YES;
    }
}


#pragma mark - Tap


- (void)hideSelf
{
    self.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.alpha = 0.3;
        weakSelf.transform = CGAffineTransformMakeScale(0.25, 0.25);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self hideSelf];
    
}


#pragma mark- Util

- (UIImageView *)makeImageViewAtPoint:(CGPoint)point imageName:(NSString *)imageName hlImageName:(NSString *)hlImageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    CGSize size = [AITools imageDisplaySizeFrom1080DesignSize:image.size];
    CGRect frame = CGRectMake(point.x, point.y, size.width, size.height);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image highlightedImage: hlImageName ? [UIImage imageNamed:hlImageName] : nil];
    imageView.frame = frame;
    imageView.userInteractionEnabled = YES;
    

    [self addSubview:imageView];
    
    return imageView;
}


#pragma mark - Main

- (void)makeBackground
{
    UIImageView *bgView = [self makeImageViewAtPoint:CGPointZero imageName:@"FakeLogin_BG" hlImageName:nil];
    bgView.userInteractionEnabled = NO;
    bgView.frame = self.bounds;
}


- (void)makeProviderArea
{
    CGFloat y = kMargin;
    
    _buyerTitleImageView = [self makeImageViewAtPoint:CGPointMake(0, y) imageName:@"FakeLogin_BuyerTitle" hlImageName:@"FakeLogin_BuyerTitleL"];
    y += kMargin * 2 + CGRectGetHeight(_buyerTitleImageView.frame);
    
    
    UIImage *image = [UIImage imageNamed:@"FakeLogin_Buyer"];
    CGSize size = [AITools imageDisplaySizeFrom1080DesignSize:image.size];
    
    __weak typeof(self) wf = self;
    AIFakeUser *buyer = [[AIFakeUser alloc] initWithFrame:CGRectMake(kMargin, y, size.width, size.height) icon:image selectedAction:^(AIFakeUser *user) {
        [wf handlerUser:user];
    }];
    buyer.userID = kCustomer1_id;
    buyer.userType = AIUserTypeCustomer;
    [self handlerDefaultUser:buyer];
    [self addSubview:buyer];

}

- (void)makeCustomerArea
{
    __weak typeof(self) wf = self;
    CGFloat y = CGRectGetHeight(self.frame) / 2;
    
    [self makeImageViewAtPoint:CGPointMake(0, y) imageName:@"FakeLogin_Line" hlImageName:nil];
    
    y += 1 + kMargin;
    
    _sellerTitleImageView = [self makeImageViewAtPoint:CGPointMake(0, y) imageName:@"FakeLogin_SellerTitle" hlImageName:@"FakeLogin_SellerTitleL"];
    y += kMargin * 2 + CGRectGetHeight(_sellerTitleImageView.frame);
    
    // Provider
    UIImage *image = [UIImage imageNamed:@"FakeLogin_Seller"];
    CGSize size = [AITools imageDisplaySizeFrom1080DesignSize:image.size];
    
    AIFakeUser *seller = [[AIFakeUser alloc] initWithFrame:CGRectMake(kMargin, y, size.width, size.height) icon:image selectedAction:^(AIFakeUser *user) {
        [wf handlerUser:user];
    }];
    seller.userID = kProvider1_id;
    seller.userType = AIUserTypeCustomer;
    [self addSubview:seller];
    [self handlerDefaultUser:seller];
    
    
    // David
    CGFloat x = CGRectGetMaxX(seller.frame) + kMargin;
    
    image = [UIImage imageNamed:@"FakeLogin_David"];
    size = [AITools imageDisplaySizeFrom1080DesignSize:image.size];
    
    seller = [[AIFakeUser alloc] initWithFrame:CGRectMake(x, y, size.width, size.height) icon:image selectedAction:^(AIFakeUser *user) {
        [wf handlerUser:user];
    }];
    seller.userID = kProviderDavid; //fake user
    seller.userType = AIUserTypeProvider;
    [self handlerDefaultUser:seller];
    [self addSubview:seller];
    
    
}



#pragma mark - Actions

- (void)makeStatusWithUserType:(AIUserType)type
{
    if (type == AIUserTypeCustomer) {
        _buyerTitleImageView.highlighted = YES;
        _sellerTitleImageView.highlighted = NO;
    }
    else if (type == AIUserTypeProvider)
    {
        _buyerTitleImageView.highlighted = NO;
        _sellerTitleImageView.highlighted = YES;
    }
}


- (void)handlerDefaultUser:(AIFakeUser *)user
{
    
    AIUser *currentUser = [AIUser currentUser];
    
    NSInteger userID = currentUser.id;
    
    if (user.userID == userID) {
        self.currentUser = user;
        [user setSelected:YES];
        [self makeStatusWithUserType:user.userType];
    }
}

- (void)handlerUser:(AIFakeUser *)user
{
    [self.currentUser setSelected:NO];
    
    [self makeStatusWithUserType:user.userType];
    
    if (user.userID) {
        // 配置语音协助定向推送
        // 配置频道
        AVInstallation *installation = [AVInstallation currentInstallation];

        AIUser *currentUser = [AIUser currentUser];
        currentUser.id = user.userID;
        
        if (user.userType == AIUserTypeCustomer) {
            [installation setObject:@(user.userID) forKey:@"ProviderIdentifier"];
            [installation addUniqueObject:@"ProviderChannel" forKey:@"channels"];
            currentUser.type = AIUserTypeCustomer;
        }
        else
        {
            [installation setObject:@"" forKey:@"ProviderIdentifier"];
            [installation removeObject:@"ProviderChannel" forKey:@"channels"];
            currentUser.type = AIUserTypeProvider;
        }
        
        [installation saveInBackground];
        
        // 保存到本地
        [currentUser save];
        
        NSString *query = [NSString stringWithFormat:@"0&0&%ld&0", user.userID];
        [[AINetEngine defaultEngine] removeCommonHeaders];
        [[AINetEngine defaultEngine] configureCommonHeaders:@{@"HttpQuery" : query}];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kShouldUpdataUserDataNotification object:nil];
    }
    
    [self hideSelf];
}

@end
