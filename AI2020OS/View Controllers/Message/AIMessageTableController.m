//
//  AIMessageTableController.m
//  AI2020OS
//
//  Created by 王坜 on 15/8/20.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIMessageTableController.h"
#import "CBStoreHouseRefreshControl.h"
#import "AIMessageCell.h"
#import "AIShareViewController.h"

@interface AIMessageTableController ()

@property (nonatomic, strong) CBStoreHouseRefreshControl *storeHouseRefreshControl;
@property (nonatomic, strong) NSArray *messages;

@end


@implementation AIMessageTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self makeData];
    //self.storeHouseRefreshControl = [CBStoreHouseRefreshControl attachToScrollView:self.tableView target:self refreshAction:@selector(refreshTriggered:) plist:@"storehouse" color:[UIColor blackColor] lineWidth:1.5 dropHeight:80 scale:1 horizontalRandomness:150 reverseLoadingAnimation:YES internalAnimationFactor:0.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)makeData
{
    NSDictionary *dic = @{  // 消息列表
                          @"type":@"2",  // 消息类型，区分系统=1、客户=2、卖家=3、好友=4
                          @"id":@"XCJ12354820", // 唯一标识一条消息，可作为查询的标识
                          @"title":@"退款成功",
                          @"icon":@"http://...", // 图片地址
                          @"service":@"（上门美甲服务）",
                          @"time":@"12:03",
                          @"message":@"交易金额:200元,退款金额:200元",
                          @"action":@[@{ // 操作功能区,理论上不能有重复的类型
                              @"title":@"查看欠款",
                              @"type":@"2"  // action类型:0-无操作、1-查看订单、2-查看欠款,通过type来定义客户端的操作
                          },
                                    @{
                                        @"title":@"查看订单",
                                        @"id":@"sad2132131d",// 订单号或其他标识，用作查询的依据
                                        @"type":@"1"
                                        }]};
    
    self.messages = @[dic,dic,dic,dic,dic,dic,dic,dic,dic,dic];
    
}

/*
#pragma mark - Notifying refresh control of scrolling

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.storeHouseRefreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.storeHouseRefreshControl scrollViewDidEndDragging];
}

#pragma mark - Listening for the user to trigger a refresh

- (void)refreshTriggered:(id)sender
{
    [self performSelector:@selector(finishRefreshControl) withObject:nil afterDelay:3];
}

- (void)finishRefreshControl
{
    [self.storeHouseRefreshControl finishingLoading];
}

*/


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    AIShareViewController *shareVC = [AIShareViewController shareWithText:@"分享是一种快乐~"];
//    [self presentViewController:shareVC animated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.messages.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"messageCell";
    AIMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    NSInteger row = indexPath.row;
    NSDictionary *message = [self.messages objectAtIndex:row];
    
    if (!cell) {
        cell = [[AIMessageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Configure the cell...
    cell.imageView.image = [UIImage imageNamed:@"touch_focus_not"];
    cell.detailTextLabel.text = [message objectForKey:@"message"];
    cell.textLabelStartString = [message objectForKey:@"title"];
    cell.textLabelEndString = [message objectForKey:@"service"];
    cell.timeLabel.text = [message objectForKey:@"time"];
    [cell makeActions:[message objectForKey:@"action"] block:^(NSDictionary *action) {
        
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [AIMessageCell defaultCellHeight];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
