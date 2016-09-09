//
//  AISellerViewController.m
//  AITrans
//
//  Created by 王坜 on 15/7/21.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import "AISellerViewController.h"
#import "AISellerCell.h"
#import "AISellerModel.h"
#import "AISellingProgressBar.h"
#import "AITools.h"
#import "AIViews.h"
#import "AIOpeningView.h"
#import "AIShareViewController.h"
#import "AISellserAnimationView.h"
#import "AINetEngine.h"
#import "MJRefresh.h"
#import "AIOrderPreModel.h"
#import "UIImageView+WebCache.h"
#import "Veris-Swift.h"
#import "AIServerConfig.h"
#import "AIOrderTableModel.h"

#define kTablePadding     15

#define kBarHeight        50

#define kCommonCellHeight 95


@interface AISellerViewController ()

@property (nonatomic, strong) UIColor *normalBackgroundColor;

@property (nonatomic, strong) NSArray *sellerInfoList;

@property (nonatomic, strong) AIOrderPreListModel *listModel;

@property (nonatomic, strong) NSMutableDictionary *tableDictionary; // key is sort String , value is AIOrderTableModel

@property (nonatomic, strong) NSMutableArray *tableHeaderList; // array of sort String

@end

@implementation AISellerViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.navigationController.navigationBarHidden = YES;
}



- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.



    [self makeBackGroundView];
    [self makeTableView];
    [self makeBottomBar];
    [self addRefreshActions];
    [self.tableView headerBeginRefreshing];
}



- (void)viewTapped {
#if DEBUG
    AIRequirementViewController *requirementVC = [UIStoryboard storyboardWithName:@"UIRrequirementStoryboard" bundle:nil].instantiateInitialViewController;
    [self.navigationController pushViewController:requirementVC animated:YES];
#endif
}



- (AIMessage *)getServiceListWithUserID:(NSInteger)userID role:(NSInteger)role {
    AIMessage *message = [AIMessage message];

    message.url = @"http://ip:portget/sbss/ServiceCalendarMgr";

    return message;
}

- (void)makeFakeDatas {
    NSString *jsonString = [AITools readJsonWithFileName:@"sellerOrderList" fileType:@"json"];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

    self.listModel = [[AIOrderPreListModel alloc] initWithDictionary:dic error:nil];
}

- (void)cleanOldDatas {
    if (_tableDictionary) {
        [_tableDictionary removeAllObjects];
        [_tableHeaderList removeAllObjects];
    } else {
        _tableDictionary = [[NSMutableDictionary alloc] init];
        _tableHeaderList = [[NSMutableArray alloc] init];
    }
}

- (void)parseTableDataSource {

    [self cleanOldDatas];
    for (AIOrderPreModel *model in self.listModel.order_list) {
        NSString *sort = [NSString stringWithFormat:@"%@", model.order_sort_time];
        AIOrderTableModel *tableModel = [_tableDictionary objectForKey:sort];

        if (tableModel == nil) {
            tableModel = [[AIOrderTableModel alloc] init];
            tableModel.timeTitle = model.order_create_time;
            tableModel.sortTime = sort;
            tableModel.nameTitle = model.proposal_name;
            [_tableDictionary setObject:tableModel forKey:sort];
            [_tableHeaderList addObject:sort];
        }

        [tableModel.orderList addObject:model];
    }
}

- (void)addRefreshActions {
    __weak typeof(self) weakSelf = self;


    [self.tableView addHeaderWithCallback:^{
        NSDictionary *dic = @{ @"data": @{ @"order_state": @"0", @"order_role": @"2" },
                               @"desc": @{ @"data_mode": @"0", @"digest": @"" } };

        
        AIMessage *message = [[AIMessage alloc] init];
        //AIMessage *message = [weakSelf getServiceListWithUserID:123123123 role:2];
        [message.body addEntriesFromDictionary:dic];
        message.url = kURL_QuerySellerOrderList;
        [weakSelf.tableView hideErrorView];
        [[AINetEngine defaultEngine] postMessage:message success:^(NSDictionary *response) {
            if (response != nil) {
                NSArray *array = response[@"order_list"];

                if (array != nil) {
                    if (array.count > 0) {
                        weakSelf.listModel = [[AIOrderPreListModel alloc] initWithDictionary:response error:nil];

                        if (weakSelf.listModel == nil) {
                            [weakSelf cleanOldDatas];
                            [weakSelf.tableView showErrorContentView];
                        } else {
                            [weakSelf parseTableDataSource];
                        }
                    } else {
                        [weakSelf cleanOldDatas];
                        [weakSelf.tableView showDiyContentView:@"No Data"];
                    }
                } else {
                    [weakSelf cleanOldDatas];
                    [weakSelf.tableView showDiyContentView:@"No Data"];
                }
            }

            dispatch_main_async_safe(^{
                [weakSelf.tableView reloadData];
                [weakSelf.tableView headerEndRefreshing];
            });
        } fail:^(AINetError error, NSString *errorDes) {
            dispatch_main_async_safe(^{
                [weakSelf.tableView headerEndRefreshing];
                [weakSelf.tableView showErrorContentView];
            });
        }];
    }];


    [self.tableView addFooterWithCallback:^{
        [weakSelf.tableView footerEndRefreshing];
    }];
}

- (void)makeDatas {
    NSURL *path = [[NSBundle mainBundle] URLForResource:@"Seller" withExtension:@"plist"];

    self.sellerInfoList = [NSArray arrayWithContentsOfURL:path];
}

- (void)makeBottomBar {
    CGFloat maxWidth = CGRectGetWidth(self.view.frame);
    CGFloat maxHeight = CGRectGetHeight(self.view.frame);

    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, maxHeight - kBarHeight, maxWidth, kBarHeight)];
    [self.view addSubview:_bottomView];


    // add shadow
    UIImage *shadowImage = [UIImage imageNamed:@"Seller_BarShadow"];
    UIImageView *shadow = [[UIImageView alloc] initWithImage:shadowImage];
    shadow.frame = CGRectMake(0, -shadowImage.size.height, maxWidth, shadowImage.size.height);
    [_bottomView addSubview:shadow];

    // add bar
    UIImageView *barView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"serller_bar"]];
    barView.frame = CGRectMake(0, 0, maxWidth, kBarHeight);
    barView.userInteractionEnabled = YES;
    barView.layer.shadowColor = [UIColor blackColor].CGColor;
    barView.layer.shadowOffset = CGSizeMake(0, 0);
    barView.layer.shadowOpacity = 1;
    [_bottomView addSubview:barView];

    // add logo
    UIImage *image = [UIImage imageNamed:@"top_logo_default"];
    _logoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _logoButton.frame = CGRectMake(0, 0, 80, 80);
    _logoButton.center = CGPointMake(maxWidth / 2, CGRectGetHeight(barView.frame) / 2 - 7);
    [_logoButton setImage:image forState:UIControlStateNormal];
    [_logoButton setImage:[UIImage imageNamed:@"top_logo_click"] forState:UIControlStateHighlighted];
    [_logoButton addTarget:self action:@selector(gobackAction) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:_logoButton];

    [self makeMyWallet];
    [self makeMyWork];
}

- (UIButton *)commonButtonWithFrame:(CGRect)frame title:(NSString *)title {

    UIButton *button = [AIViews baseButtonWithFrame:frame normalTitle:title];
    button.titleLabel.font = [AITools myriadRegularWithSize:12];
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 2;

    return button;
}

- (void)makeMyWallet {
    CGFloat size = kBarHeight - 10;
    UIButton *wallet = [self commonButtonWithFrame:CGRectMake(5, 5, size, size) title:@"我的\n钱包"];

    [wallet addTarget:self action:@selector(showMyWallet) forControlEvents:UIControlEventTouchUpInside];

    [_bottomView addSubview:wallet];

}

- (void)makeMyWork {
    CGFloat size = kBarHeight - 10;

    UIButton *work = [self commonButtonWithFrame:CGRectMake(CGRectGetWidth(_bottomView.frame) - size - 5, 5, size, size) title:@"我的\n工作"];
    [work addTarget:self action:@selector(showMyWork) forControlEvents:UIControlEventTouchUpInside];

    [_bottomView addSubview:work];
}


#pragma mark - Main Action

- (void)showMyWallet {
    // 演示屏蔽
    AIFundManageViewController *fundManageViewController = [[AIFundManageViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:fundManageViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)showMyWork {
    // 演示屏蔽
    AIWorkManageViewController *workManageViewController = [[AIWorkManageViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:workManageViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Go Back


- (void)gobackAction {
    [self.tableView footerEndRefreshing];
    [self.tableView headerEndRefreshing];

    [[AIOpeningView instance] show];
}

- (void)makeBackGroundView {    //
    self.normalBackgroundColor = [AITools colorWithHexString:@"1e1b38"];
    self.view.backgroundColor = self.normalBackgroundColor;
}

- (void)addTopAndBottomMaskForTable:(UITableView *)table {
    // header
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(table.frame), kTablePadding)];

    view.backgroundColor = self.normalBackgroundColor;
    table.tableHeaderView = view;

    view = [[UIView alloc] initWithFrame:CGRectMake(0, -500, CGRectGetWidth(table.frame), 500)];
    view.backgroundColor = self.normalBackgroundColor;
    [table.tableHeaderView addSubview:view];

    // footer
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(table.frame), kBarHeight - 1)];
    view.backgroundColor = self.normalBackgroundColor;
    table.tableFooterView = view;

    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(table.frame), 1000)];
    view.backgroundColor = self.normalBackgroundColor;
    [table.tableFooterView addSubview:view];
}

- (void)addBackgroundViewForTable:(UITableView *)table {
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:table.bounds];

    backImageView.image = [UIImage imageNamed:@"wholebackground"];
    backImageView.layer.cornerRadius = 8;
    backImageView.layer.masksToBounds = YES;
    backImageView.backgroundColor = [UIColor clearColor];
    backImageView.layer.backgroundColor = [UIColor clearColor].CGColor;
    backImageView.contentMode = UIViewContentModeScaleAspectFill;


    table.backgroundView = backImageView;
}

- (void)makeTableView {
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(kTablePadding, 0, CGRectGetWidth(self.view.frame) - kTablePadding * 2, CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.backgroundColor = [UIColor clearColor];

        [self addBackgroundViewForTable:tableView];
        [self addTopAndBottomMaskForTable:tableView];

        tableView;
    });


    [self.view addSubview:self.tableView];
    //[self makeMaskForTable];
}

// test
- (void)makeMaskForTable {
    UIView *maskView = [[UIView alloc] initWithFrame:self.view.bounds];


    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(maskView.frame) / 2, 0) radius:CGRectGetWidth(maskView.frame) / 2 startAngle:0 endAngle:M_PI clockwise:YES];

    CAShapeLayer *tracklayer = [CAShapeLayer layer];

    tracklayer.fillColor = [[UIColor clearColor] CGColor];
    tracklayer.frame = maskView.bounds;
    tracklayer.path = [path CGPath];
    maskView.layer.mask = tracklayer;
    maskView.userInteractionEnabled = NO;
    //


    //边框蒙版
//
    CAShapeLayer *maskBorderLayer = [CAShapeLayer layer];

    maskBorderLayer.path = [path CGPath];

    maskBorderLayer.fillColor = [[UIColor clearColor] CGColor];
    maskBorderLayer.mask = tracklayer;
    //边框宽度
    [maskView.layer addSublayer:tracklayer];
    [self.view addSubview:maskView];
    self.view.clipsToBounds = YES;
    self.view.layer.masksToBounds = YES;
}

#pragma mark - TableViewDataSource


- (SellerCellColorType)orderState:(NSInteger)state {
    SellerCellColorType type;

    if (state == 10 || state == 14 || state == 11) {
        type = SellerCellColorTypeNormal;
    } else if (state == 100) {
        type = SellerCellColorTypeGreen;
    } else {
        type = SellerCellColorTypeBrown;
    }

    return type;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    for (NSInteger i = 0; i < _tableDictionary.allKeys.count; i++) {
        AIOrderTableModel *model = [_tableDictionary objectForKey:[_tableHeaderList objectAtIndex:i]];

        if (i == section) {
            return model.orderList.count;
        }
    }

    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _tableHeaderList.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat width = CGRectGetWidth(tableView.frame);
    AIOrderTableModel *tableModel = [_tableDictionary objectForKey:[_tableHeaderList objectAtIndex:section]];

    UPLabel *nameLabel = [AIViews normalLabelWithFrame:CGRectMake(0, 0, width, 20) text:tableModel.nameTitle fontSize:16 color:Color_HighWhite];

    UPLabel *timeLabel = [AIViews normalLabelWithFrame:CGRectMake(0, 0, width, 20) text:tableModel.timeTitle fontSize:16 color:Color_HighWhite];

    timeLabel.textAlignment = NSTextAlignmentRight;

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 20)];
    view.backgroundColor = self.normalBackgroundColor;
    [view addSubview:nameLabel];
    [view addSubview:timeLabel];


    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *resueID = @"SellerCell";
    AISellerCell *cell = [tableView dequeueReusableCellWithIdentifier:resueID];

    if (!cell) {
        cell = [[AISellerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resueID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    AIOrderTableModel *tableModel = [_tableDictionary objectForKey:[_tableHeaderList objectAtIndex:indexPath.section]];
    AIOrderPreModel *model = [tableModel.orderList objectAtIndex:indexPath.row];
    [cell.sellerIcon sd_setImageWithURL:[NSURL URLWithString:model.customer.user_portrait_icon] placeholderImage:nil];
    cell.sellerName.text = model.customer.user_name;
    cell.price.text = model.service.service_price;

    NSString *time = [@"AISellerViewController.2beConfirmed" localized];
    NSString *address = [@"AISellerViewController.2beConfirmed" localized];

    NSArray *array = model.service_progress.param_list;

    if (array) {
        for (AIServiceParamModel *model in array) {
            if ([model.param_key isEqualToString:@"time"]) {
                time = model.param_value ? : time;
            } else if ([model.param_key isEqualToString:@"location"]) {
                address = model.param_value ? : address;
            }
        }
    }

    cell.userPhone = model.customer.user_phone;
    cell.timestamp.text = time;
    cell.location.text = address;
    [cell setBackgroundColorType:[self orderState:model.order_state]];
    [cell setButtonType:model.service_progress.operation];
    [cell setProgressBarModel:model.service_progress];
    [cell setServiceCategory:model];

    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    AIOrderTableModel *tableModel = [_tableDictionary objectForKey:[_tableHeaderList objectAtIndex:indexPath.section]];
    AIOrderPreModel *model = [tableModel.orderList objectAtIndex:indexPath.row];

    AIProposalServiceModel *serviceModel = [[AIProposalServiceModel alloc] init];
    serviceModel.service_id = model.service.service_id;

    if ([model.service.service_type  isEqualToString:@"0"]) { // 单一服务
        [self showSingalServiceStatusViewControllerWithModel:model];
    }else if ([model.service.service_type  isEqualToString:@"1"]){ // 复合服务
        [self showRequirementViewControllerWithModel:model];
    }

}

- (void)showRequirementViewControllerWithModel:(AIOrderPreModel *)model {
    AIRequirementViewController *requirementVC = [UIStoryboard storyboardWithName:@"UIRrequirementStoryboard" bundle:nil].instantiateInitialViewController;
    requirementVC.orderPreModel = model;
    [self.navigationController pushViewController:requirementVC animated:YES];
}


- (void)showSingalServiceStatusViewControllerWithModel:(AIOrderPreModel *)model {
    NSInteger statusInt = model.service.service_instance_status;

    UIViewController *nextViewController = nil;
    switch (statusInt) {
        case 0:  // 未开始
        {
            AIContestSuccessViewController *successViewController = [[UIStoryboard storyboardWithName:@"AIAlertStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"AIContestSuccessViewController"];
            successViewController.serviceInstanceID = model.service.service_instance_id;
            successViewController.proposalID = model.proposal_id;
            successViewController.serviceID = model.service.service_id;
            successViewController.customerID = model.customer.customer_id;
            nextViewController = successViewController;
        }

            break;

        case 1: // 进行中
        {
            TaskDetailViewController *taskViewController = [[UIStoryboard storyboardWithName:@"TaskExecuteStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"TaskDetailViewController"];
            taskViewController.serviceId = model.service.service_instance_id;
            //taskViewController.providerId = model
            nextViewController = taskViewController;
        }
            break;
        case 2: // 已完成
        {

        }
            break;

        default:
            break;
    }

    if (nextViewController) {
        [self.navigationController pushViewController:nextViewController animated:YES];
    }


}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCommonCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

@end
