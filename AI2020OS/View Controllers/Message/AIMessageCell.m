//
//  AIMessageCell.m
//  AI2020OS
//
//  Created by 王坜 on 15/8/17.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

#import "AIMessageCell.h"

#define kDefaultCellHeight         115
#define kImageSize                 45
#define kTitleFont                 18
#define kDetailFont                15
#define kTimeFont                  12
#define kCellMargin                20
#define kSideMargin                15
#define kTitleWidth                240
#define kSeperateMaring            5

typedef NS_ENUM(NSInteger, CellStatus) {
    CellStatusNone,        // 无收缩功能
    CellStatusExpended,    // 展开状态
    CellStatusShrinked,    // 收缩状态
};

@interface AIMessageCell ()
{
    CellStatus _currentStatus;
    UILabel *_timeLabel;
    UIView *_actionView;
}

@property (nonatomic, strong) NSMutableArray *actionButtons;
@property (nonatomic, strong) NSArray *actions;
@property (nonatomic, strong) AIMessageCellBlock cellBlock;

@end


@implementation AIMessageCell
@synthesize timeLabel = _timeLabel;

#pragma mark - 计算当前高度
+ (CGFloat)defaultCellHeight
{
    return kDefaultCellHeight;
}





#pragma mark - Life Circle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _currentStatus = CellStatusNone;
        
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, kTitleFont)];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor lightGrayColor];
    
        _timeLabel.font = [UIFont systemFontOfSize:kTimeFont];
        [self.contentView addSubview:_timeLabel];
        
        //self.textLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.textColor = [UIColor lightGrayColor];
        self.detailTextLabel.font = [UIFont systemFontOfSize:kDetailFont];
    }
    
    return self;
}

#pragma mark - 增加action按钮
- (void)makeActions:(NSArray *)actions block:(AIMessageCellBlock)block
{
    self.actions = actions;
    self.cellBlock = block;
    
    for (UIButton *button in self.actionButtons) {
        [button removeFromSuperview];
    }
    self.actionButtons = [[NSMutableArray alloc] init];
    
    [_actionView removeFromSuperview];
    
    CGFloat x = 0;
    _actionView = [[UIView alloc] initWithFrame:CGRectMake(x, 90, 200, kDetailFont)];
    _actionView.clipsToBounds = YES;
    [self.contentView addSubview:_actionView];
    
    for (NSDictionary *action in actions) {
        
        NSString *title = [action objectForKey:@"title"];
        NSString *type = [action objectForKey:@"type"];
        
        CGSize size = [self calculateSizeForString:title withFont:[UIFont systemFontOfSize:kDetailFont] forWidth:200];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x, 0, size.width+2, kDetailFont);
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:kDetailFont];
        
        if ([type isEqualToString:@"0"]) {
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.userInteractionEnabled = NO;
        }
        
        [_actionView addSubview:button];
        
        
        
        x += kSeperateMaring*2 + CGRectGetWidth(button.frame);
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, 0, 1, kDetailFont)];
        line.backgroundColor = [UIColor grayColor];
        [_actionView addSubview:line];
        
        x += 1+kSeperateMaring*2;
        
    }

    _actionView.frame = CGRectMake(CGRectGetWidth(self.frame)-kSideMargin-x, 80, x-1-kSeperateMaring*4, kDetailFont);
    
}


#pragma mark - 展开事件

- (void)expendSelfCompletion:(void(^)(BOOL isExpend))completion
{
    
}


#pragma mark - 重构layout


- (NSAttributedString *)attrStringWithStart:(NSString *)start end:(NSString *)end
{
    if (end == nil || end.length == 0) {
        return [[NSMutableAttributedString alloc] initWithString:start];
    }
    NSString *str = [NSString stringWithFormat:@"%@%@",start?:@"", end?:@""];
    NSRange range = [str rangeOfString:end];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSDictionary *att = @{NSForegroundColorAttributeName : [UIColor lightGrayColor],
                          NSFontAttributeName : [UIFont systemFontOfSize:kDetailFont]};
    [attString addAttributes:att range:range];
    
    return attString;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat x = kSideMargin;
    CGFloat y = kCellMargin;
    CGFloat textWidth = CGRectGetWidth(self.frame) - kSideMargin*2 - kImageSize - kCellMargin;
    CGSize timeSize = [self calculateSizeForString:_timeLabel.text withFont:[UIFont systemFontOfSize:kTimeFont] forWidth:200];
    // set image
    
    self.imageView.frame = CGRectMake(x, y, kImageSize, kImageSize);
    
    // title
    x += kCellMargin + kImageSize;
    y += kSeperateMaring - 2;
    
    self.textLabel.frame = CGRectMake(x, y, textWidth-timeSize.width, kTitleFont);
    self.textLabel.font = [UIFont systemFontOfSize:kTitleFont];
    self.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.textLabel.attributedText = [self attrStringWithStart:self.textLabelStartString end:self.textLabelEndString];
    
    // detail
    y += kTitleFont + kSeperateMaring;
    //CGSize size = [self calculateSizeForString:self.detailTextLabel.text withFont:[UIFont systemFontOfSize:kDetailFont] forWidth:textWidth];
    self.detailTextLabel.frame = CGRectMake(x, y, textWidth, kDetailFont);
    self.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.detailTextLabel.numberOfLines = 1;
    /*
    if (size.height > kDetailFont + 10) {
        if (_currentStatus == CellStatusNone) {
            _currentStatus = CellStatusShrinked;
            self.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            self.detailTextLabel.numberOfLines = 1;
        }
        else if (_currentStatus == CellStatusShrinked)
        {
            _currentStatus = CellStatusExpended;
            self.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.detailTextLabel.numberOfLines = 0;
        }
        
        
        
        
    }
    */
    
    //
    CGRect frame = _actionView.frame;
    frame.origin.x = CGRectGetWidth(self.frame)-kSideMargin-CGRectGetWidth(frame);
    _actionView.frame = frame;
    
    // time
    
    
    _timeLabel.frame = CGRectMake(CGRectGetWidth(self.frame)-kSideMargin-timeSize.width, kCellMargin, timeSize.width, timeSize.height);
    
    // frame
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(kSideMargin/2, CGRectGetHeight(self.frame)-1, CGRectGetWidth(self.frame)-kSideMargin, 1)];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:bottomLine];
}


- (CGSize)calculateSizeForString:(NSString *)string withFont:(UIFont *)font forWidth:(CGFloat)width
{
    CGSize size = CGSizeZero;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGRect frame = [string boundingRectWithSize:CGSizeMake(width, INFINITY) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    size = frame.size;
    
    return size;
}



@end
