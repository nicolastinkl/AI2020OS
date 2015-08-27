//
//  AIServiceManageViewController.m
//  AI2020OS
//
//  Created by 王坜 on 15/8/25.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIServiceManageViewController.h"
#import "AIWebViewController.h"

#define kButtonHeight 44

@interface AIServiceManageViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AIServiceManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的货架";
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self resetNavigationBar];
    [self makeTableView];
    [self makeAddButton];
    
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:YES];
    
    [self.tableView setEditing:editing animated:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}


- (void)resetNavigationBar
{
    //
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ico_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backItem;
    
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - make table

- (void)makeTableView
{
    self.tableView = ({
        CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        
        tableView;
    });
    
    [self.view addSubview:self.tableView];
}


#pragma mark - 添加

- (UIImage *)createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (UIImage *)imageWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b alpha:(CGFloat)alpha frame:(CGRect)frame
{
    UIImage *img = nil;
    
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, r/0xFF, g/0xFF, b/0xFF, alpha);
    CGContextFillRect(context, frame);
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


- (void)makeAddButton
{
    //
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height -= kButtonHeight;
    self.tableView.frame = tableFrame;
    
    //
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, CGRectGetHeight(self.view.frame)- kButtonHeight, CGRectGetWidth(self.view.frame), kButtonHeight);
    
    UIImage *image = [self imageWithR:0x00 G:0xCE B:0xC3 alpha:1 frame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kButtonHeight)];

    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitle:@"增加服务" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    [button addTarget:self action:@selector(addService) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}


- (void)addService
{
    AIWebViewController *webViewController = [[AIWebViewController alloc] init];
    webViewController.startPage = @"serviceCatelog.html";
    webViewController.wwwFolderName = @"www";
    webViewController.shouldHideNavigationBar = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 20;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"reuseIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
    }
    
    BOOL isOdd = indexPath.row%2 == 0;
    
    cell.textLabel.text = isOdd?@"美甲服务":@"地陪服务";
    cell.detailTextLabel.text = isOdd?@"18:00 - 22:00 提供服务":@"仅限周末";
    cell.imageView.image = [UIImage imageNamed:isOdd?@"CardIndicator13":@"CardIndicator14"];
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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
