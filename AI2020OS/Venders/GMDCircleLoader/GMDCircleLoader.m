//
//  GMDCircleLoader.m
//
// Copyright (c) 2014 Gabe Morales
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "GMDCircleLoader.h"

#pragma mark - Interface
@interface GMDCircleLoader ()
{
    UIView *_breakView;
    UIView *_circleView;
}
@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, assign) BOOL isSpinning;

@property (nonatomic, strong) NSString *loadingTitle;
@end

@implementation GMDCircleLoader

//-----------------------------------
// Add the loader to view
//-----------------------------------

+ (GMDCircleLoader *)setOnView:(UIView *)view withTitle:(NSString *)title animated:(BOOL)animated {
    
    GMDCircleLoader *hud = [[GMDCircleLoader alloc] initWithFrame:view.bounds title:title];

    [hud start];
    [view addSubview:hud];
    return hud;
}

//------------------------------------
// Hide the leader in view
//------------------------------------
+ (BOOL)hideFromView:(UIView *)view animated:(BOOL)animated {
    GMDCircleLoader *hud = [GMDCircleLoader HUDForView:view];
    [hud stop];
    if (hud) {
        [hud removeFromSuperview];
        return YES;
    }
    return NO;
}

//------------------------------------
// Perform search for loader and hide it
//------------------------------------
+ (GMDCircleLoader *)HUDForView: (UIView *)view {
    GMDCircleLoader *hud = nil;
    NSArray *subViewsArray = view.subviews;
    Class hudClass = [GMDCircleLoader class];
    for (UIView *aView in subViewsArray) {
        if ([aView isKindOfClass:hudClass]) {
            hud = (GMDCircleLoader *)aView;
        }
    }
    return hud;
}

#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        self.loadingTitle = title;
        // make breakView
        _breakView = [[UIView alloc] initWithFrame:self.bounds];
        _breakView.backgroundColor = [UIColor blackColor];
        _breakView.alpha = 0;
        [self addSubview:_breakView];
        
        [self setup];
        
        [self makeTitle];
        
        [self addAnimationToBreakView];
    }
    return self;
}


- (void)addAnimationToBreakView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:0.5];
    animation.duration = 0.5;
    animation.cumulative = YES;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction =
    [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    [_breakView.layer addAnimation:animation forKey:@"opacity"];
    
//    
//    
//    
//    [UIView animateWithDuration:0.25f animations:^{
//        _breakView.alpha = 0.6;
//    }];
//    
}

#pragma mark - Title

- (void)makeTitle
{
    CGFloat x = (CGRectGetWidth(self.frame) - 260)/2;
    CGFloat y = CGRectGetMaxY(_circleView.frame) + 10;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 260.0f, 20.0f)];
    label.font = [UIFont systemFontOfSize:18.0f];
    label.textColor = GMD_SPINNER_COLOR;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.loadingTitle;
    label.lineBreakMode = NSLineBreakByTruncatingTail;

    [self addSubview:label];
}

#pragma mark - Setup
- (void)setup {
    
    // make circleView
    _circleView = [[UIView alloc] initWithFrame:GMD_SPINNER_FRAME];
    _circleView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2 - 20);
    _circleView.backgroundColor = [UIColor clearColor];
    [self addSubview:_circleView];
    //---------------------------
    // Set line width
    //---------------------------
    _lineWidth = 2;GMD_SPINNER_LINE_WIDTH;
    
    //---------------------------
    // Round Progress View
    //---------------------------
    self.backgroundLayer = [CAShapeLayer layer];
    _backgroundLayer.strokeColor = GMD_SPINNER_COLOR.CGColor;
    _backgroundLayer.fillColor = self.backgroundColor.CGColor;
    _backgroundLayer.lineCap = kCALineCapRound;
    _backgroundLayer.lineWidth = _lineWidth;
    [_circleView.layer addSublayer:_backgroundLayer];
    
    
}

- (void)drawRect:(CGRect)rect {
    //-------------------------
    // Make sure layers cover the whole view
    //-------------------------
    _backgroundLayer.frame = _circleView.bounds;
}

#pragma mark - Drawing

- (void)drawBackgroundCircle:(BOOL) partial {
    CGFloat startAngle = - ((float)M_PI / 2); // 90 Degrees
    CGFloat endAngle = (2 * (float)M_PI) + startAngle;
    CGPoint center = CGPointMake(_circleView.bounds.size.width/2, _circleView.bounds.size.height/2);
    CGFloat radius = (_circleView.bounds.size.width - _lineWidth)/2;
    
    //----------------------
    // Begin draw background
    //----------------------
    
    UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
    processBackgroundPath.lineWidth = _lineWidth;
    
    //---------------------------------------
    // Make end angle to 90% of the progress
    //---------------------------------------
    if (partial) {
        endAngle = (1.8f * (float)M_PI) + startAngle;
    }
    [processBackgroundPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    _backgroundLayer.path = processBackgroundPath.CGPath;
}

#pragma mark - Spin
- (void)start {
    self.isSpinning = YES;
    [self drawBackgroundCircle:YES];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration = 1.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.timingFunction =
    [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
    
    [_backgroundLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stop{
    [self drawBackgroundCircle:NO];
    [_backgroundLayer removeAllAnimations];
    self.isSpinning = NO;
}

@end

