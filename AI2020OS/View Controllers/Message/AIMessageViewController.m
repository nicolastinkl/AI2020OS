//
//  AIMessageViewController.m
//  AI2020OS
//
//  Created by 王坜 on 15/8/17.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIMessageViewController.h"
#import "WMPageController.h"

@interface AIMessageViewController ()

@end

@implementation AIMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configSelfProperties];
    [self resetNavigationBar];
    [self makePageController];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)configSelfProperties
{
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"消息";
}

#pragma mark - Reset NavigationBar


- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showMore
{
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"AIMenuStoryboard" bundle:nil];
    UIViewController *menuViewController = [storyBoard instantiateViewControllerWithIdentifier:@"AIMenuViewController"];
    menuViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    menuViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:menuViewController animated:YES completion:nil];
}

- (void)showUser
{
    
}

- (void)resetNavigationBar
{
    //
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ico_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    //
    UIBarButtonItem *userItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ico_user"] style:UIBarButtonItemStylePlain target:self action:@selector(showUser)];
    
    //
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ico_more"] style:UIBarButtonItemStylePlain target:self action:@selector(showMore)];
    NSArray *items = @[moreItem, userItem];
    self.navigationItem.rightBarButtonItems = items;
}


#pragma mark - 构造pageController

- (void)makePageController
{
    Class class1 = [UIViewController class];
    Class class2 = [UIViewController class];
    Class class3 = [UIViewController class];
    Class class4 = [UIViewController class];
    Class class5 = [UIViewController class];
    NSArray *viewControllers = @[class1, class2, class3, class4, class5];
    NSArray *titles = @[@"全部", @"系统", @"客户", @"卖家", @"好友"];
    
    WMPageController *pageController = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    pageController.pageAnimatable = YES;
    pageController.menuItemWidth = [UIScreen mainScreen].bounds.size.width/5;
    //pageController.postNotification = YES;
    pageController.menuViewStyle = WMMenuViewStyleLine;
    pageController.titleSizeSelected = 16;
    
    [self addChildViewController:pageController];
    [self.view addSubview:pageController.view];
}


@end
