//
//  AIRootViewController.m
//  AITrans
//
//  Created by 王坜 on 15/7/17.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import "AIRootViewController.h"
#import "AISellerViewController.h"
#import "Veris-Swift.h"

@interface AIRootViewController ()
{
    UIViewController *_currentViewController;
}

@property (nonatomic, strong) UIViewController *centerTapViewController;
@property (nonatomic, strong) UIViewController *upDirectionViewController;
@property (nonatomic, strong) UIViewController *downDirectionViewController;
@property (nonatomic, strong) UIViewController *leftDirectionViewController;
@property (nonatomic, strong) UIViewController *rightDirectionViewController;

@property (nonatomic, strong) LoginAction *loginAction;

@end

@implementation AIRootViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*!
     *  初始化处理
     */
    [self makeChildViewControllers];
    [self startOpenningAnimation];
 
    
    //[self handleLoginAction];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Method

- (void)makeChildViewControllers
{
    // up
    AIUINavigationController *upNavi = [[AIUINavigationController alloc] initWithRootViewController:[[AIBuyerViewController alloc] init]];
    self.upDirectionViewController = upNavi;
    [self addChildViewController:self.upDirectionViewController];
    [self.upDirectionViewController didMoveToParentViewController:self];


    // down
    AISellerViewController *sellerViewController = [[AISellerViewController alloc] init];
    [self addChildViewController:sellerViewController];
    self.downDirectionViewController = sellerViewController;
    [sellerViewController didMoveToParentViewController:self];
    
    // default
    [self.view addSubview:self.upDirectionViewController.view];
    _currentViewController = self.upDirectionViewController;
}

- (void)didOperatedWithDirection:(NSInteger)direction// 0:center 1:up 2:down 3:left 4:right
{
    switch (direction) {
        case 0: //0:center
            break;
        case 1: // 1:up
        {
            if (_currentViewController == self.upDirectionViewController) {
                return;
            }
            [self transitionFromViewController:_currentViewController toViewController:self.upDirectionViewController duration:0 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                _currentViewController = self.upDirectionViewController;
            }];
        }
            break;
        case 2: // 2:down
        {
            if (_currentViewController == self.downDirectionViewController) {
                return;
            }
            [self transitionFromViewController:_currentViewController toViewController:self.downDirectionViewController duration:0 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                _currentViewController = self.downDirectionViewController;
            }];
        }
            break;
        case 3: // 3:left
            break;
        case 4: // 4:right
            break;
            
    }

}

/*!
 *  @author tinkl, 15-09-07 17:09:53
 *
 *  设置初始化状态
 */
- (void)startOpenningAnimation
{
    [AIOpeningView instance].delegate = self;
    [AIOpeningView instance].rootView = self.view;
    [AIOpeningView instance].centerTappedView = self.centerTapViewController.view;
    [[AIOpeningView instance] show];
    
}

- (void)handleLoginAction
{
    if (![AILoginUtil isLogin]){
         self.loginAction = [[LoginAction alloc] initWithViewController:self completion:nil];
    }
   
}

@end
