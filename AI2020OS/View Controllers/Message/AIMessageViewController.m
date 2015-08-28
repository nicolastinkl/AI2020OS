//
//  AIMessageViewController.m
//  AI2020OS
//
//  Created by 王坜 on 15/8/17.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIMessageViewController.h"
#import "WMPageController.h"
#import "AIMessageTableController.h"
#import "AIWebViewController.h"

#define kBlueColor [UIColor colorWithRed:0x00 green:0xCE blue:0xC3 alpha:1]
//#define kBlueColor [UIColor colorWithRed:(0x20/0xFF) green:(0xb5/0xFF) blue:(0x6f/0xFF) alpha:1]

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
    AICDWebViewController *webViewController = [[AICDWebViewController alloc] init];
    webViewController.startPage = @"index.html";
    webViewController.wwwFolderName = @"www";
    [self.navigationController pushViewController:webViewController animated:YES];
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


- (UIColor *)colorWithR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b
{
    CGFloat sr = r/0xFF;
    CGFloat sg = g/0xFF;
    CGFloat sb = b/0xFF;
    UIColor *color = [UIColor colorWithRed:sr green:sg blue:sb alpha:1];
    return color;
}


- (void)makePageController
{
    Class class1 = [AIMessageTableController class];
    Class class2 = [AIMessageTableController class];
    Class class3 = [AIMessageTableController class];
    Class class4 = [AIMessageTableController class];
    Class class5 = [AIMessageTableController class];
    NSArray *viewControllers = @[class1, class2, class3, class4, class5];
    NSArray *titles = @[@"全部", @"系统", @"客户", @"卖家", @"好友"];
    
    WMPageController *pageController = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    pageController.pageAnimatable = YES;
    pageController.menuItemWidth = [UIScreen mainScreen].bounds.size.width/5;
    //pageController.postNotification = YES;
    pageController.menuBGColor = [UIColor whiteColor];
    pageController.menuViewStyle = WMMenuViewStyleLine;
    pageController.titleColorSelected = [self colorWithR:0x00 g:0xce b:0xc3];
    pageController.titleSizeSelected = 16;
    
    [self addChildViewController:pageController];
    [self.view addSubview:pageController.view];
}


@end
