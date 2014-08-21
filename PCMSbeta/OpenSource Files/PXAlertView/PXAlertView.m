//
//  PXAlertView.m
//  PXAlertViewDemo
//
//  Created by Alex Jarvis on 25/09/2013.
//  Copyright (c) 2013 Panaxiom Ltd. All rights reserved.
//

#import "PXAlertView.h"

@interface PXAlertViewQueue : NSObject

@property (nonatomic) NSMutableArray *alertViews;

+ (PXAlertViewQueue *)sharedInstance;

- (void)add:(PXAlertView *)alertView;
- (void)remove:(PXAlertView *)alertView;

@end

//static const CGFloat AlertViewWidth = 270.0;
static const CGFloat AlertViewContentMargin = 0;
static const CGFloat AlertViewVerticalElementSpace = 0;
static const CGFloat AlertViewButtonHeight = 44;

/**
 *  在使用此类时,如果在你的类中调用了一个showAlertView方法并返回了PXAlertView的实例,那么不得是全局变量
 *  若使用全局变量,请在AlertView执行完成消失动作时把PXAlertView的实例置空nil
 */
@interface PXAlertView () {
    CGFloat AlertViewWidth;
}

@property (nonatomic) UIWindow *mainWindow;
@property (nonatomic) UIWindow *alertWindow;
@property (nonatomic) UIView *backgroundView;
@property (nonatomic) UIView *alertView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIView *contentView;
@property (nonatomic) UILabel *messageLabel;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UIButton *otherButton;
@property (nonatomic) UITapGestureRecognizer *tap;
@property (nonatomic, strong) void (^completion)(BOOL cancelled);
//自定义
@property (nonatomic, strong) NSString *cancelTitle;

@end

@implementation PXAlertView

- (UIWindow *)windowWithLevel:(UIWindowLevel)windowLevel
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in windows) {
        if (window.windowLevel == windowLevel) {
            return window;
        }
    }
    return nil;
}

- (id)initAlertWithTitle:(NSString *)title
                 message:(NSString *)message
             cancelTitle:(NSString *)cancelTitle
              otherTitle:(NSString *)otherTitle
             contentView:(UIView *)contentView
              completion:(void(^) (BOOL cancelled))completion
{
    self = [super init];
    if (self) {
        AlertViewWidth = 270.0;
        _mainWindow = [self windowWithLevel:UIWindowLevelNormal];
        _alertWindow = [self windowWithLevel:UIWindowLevelAlert];
        if (!_alertWindow) {
            _alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            _alertWindow.windowLevel = UIWindowLevelAlert;
        }
        self.frame = _alertWindow.bounds;
        
        _backgroundView = [[UIView alloc] initWithFrame:_alertWindow.bounds];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
        _backgroundView.alpha = 0;
        [self addSubview:_backgroundView];
        
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        _alertView.layer.cornerRadius = 4.5;
        _alertView.layer.opacity = .95;
        _alertView.clipsToBounds = YES;
        [self addSubview:_alertView];
        
        // Title
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(AlertViewContentMargin,
                                                                AlertViewVerticalElementSpace,
                                                                AlertViewWidth - AlertViewContentMargin*2,
                                                                44)];
        _titleLabel.text = title;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        _titleLabel.frame = [self adjustLabelFrameHeight:self.titleLabel];
        [_alertView addSubview:_titleLabel];
        
        CGFloat messageLabelY = _titleLabel.frame.origin.y + _titleLabel.frame.size.height + AlertViewVerticalElementSpace;
        
        // Optional Content View
        if (contentView) {
            AlertViewWidth = contentView.frame.size.width;
            _contentView = contentView;
            _contentView.frame = CGRectMake(0,
                                            messageLabelY,
                                            _contentView.frame.size.width,
                                            _contentView.frame.size.height);
            _contentView.center = CGPointMake(AlertViewWidth/2, _contentView.center.y);
            [_alertView addSubview:_contentView];
            messageLabelY += contentView.frame.size.height + AlertViewVerticalElementSpace;
            //自定义
            if (contentView.subviews) {
                for (int i = 0; i < contentView.subviews.count; i++) {
                    if ([contentView.subviews[i] isKindOfClass:[UIButton class]]) {
                        [contentView.subviews[i] addTarget:self action:@selector(setBackgroundColorForButton:) forControlEvents:UIControlEventTouchDown];
                        [contentView.subviews[i] addTarget:self action:@selector(clearBackgroundColorForButton:) forControlEvents:UIControlEventTouchDragExit];
                    }
                }
            }
        }
        
        // Message
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(AlertViewContentMargin,
                                                                  messageLabelY,
                                                                  AlertViewWidth - AlertViewContentMargin*2,
                                                                  44)];
        _messageLabel.text = message;
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.textColor = [UIColor blackColor];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:15];
        _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _messageLabel.numberOfLines = 0;
        _messageLabel.frame = [self adjustLabelFrameHeight:self.messageLabel];
        [_alertView addSubview:_messageLabel];
        
        // Line
        CALayer *lineLayer = [CALayer layer];
        lineLayer.backgroundColor = [[UIColor colorWithWhite:0.90 alpha:0.3] CGColor];
        lineLayer.frame = CGRectMake(0, _messageLabel.frame.origin.y + _messageLabel.frame.size.height + AlertViewVerticalElementSpace, AlertViewWidth, 0.5);
        [_alertView.layer addSublayer:lineLayer];
        
        // Buttons
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (cancelTitle) {
            //自定义
            _cancelTitle = cancelTitle;
            [_cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
        } else {
            [_cancelButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        }
        _cancelButton.backgroundColor = [UIColor clearColor];
        
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithWhite:0.25 alpha:1] forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton addTarget:self action:@selector(setBackgroundColorForButton:) forControlEvents:UIControlEventTouchDown];
        [_cancelButton addTarget:self action:@selector(clearBackgroundColorForButton:) forControlEvents:UIControlEventTouchDragExit];

        CGFloat buttonsY = lineLayer.frame.origin.y + lineLayer.frame.size.height;
        if (otherTitle) {
            _cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
            _cancelButton.frame = CGRectMake(0, buttonsY, AlertViewWidth/2, AlertViewButtonHeight);
            
            _otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_otherButton setTitle:otherTitle forState:UIControlStateNormal];
            _otherButton.backgroundColor = [UIColor clearColor];
            _otherButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
            [_otherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_otherButton setTitleColor:[UIColor colorWithWhite:0.25 alpha:1] forState:UIControlStateHighlighted];
            [_otherButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
            [_otherButton addTarget:self action:@selector(setBackgroundColorForButton:) forControlEvents:UIControlEventTouchDown];
            [_otherButton addTarget:self action:@selector(clearBackgroundColorForButton:) forControlEvents:UIControlEventTouchDragExit];
            _otherButton.frame = CGRectMake(_cancelButton.frame.size.width, buttonsY, AlertViewWidth/2, 44);
            [self.alertView addSubview:_otherButton];
            
            CALayer *lineLayer = [CALayer layer];
            lineLayer.backgroundColor = [[UIColor colorWithWhite:0.90 alpha:0.3] CGColor];
            lineLayer.frame = CGRectMake(_otherButton.frame.origin.x, _otherButton.frame.origin.y, 0.5, AlertViewButtonHeight);
            [_alertView.layer addSublayer:lineLayer];
            
        } else {
            _cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
            _cancelButton.frame = CGRectMake(0, buttonsY, AlertViewWidth, AlertViewButtonHeight);
        }
        //自定义
        if (cancelTitle) {
            [_alertView addSubview:_cancelButton];
        }
        
        
        //[_alertView addSubview:_cancelButton];
        _alertView.bounds = CGRectMake(0, 0, AlertViewWidth, 150);
        
        if (completion) {
            _completion = completion;
        }
        
        [self setupGestures];
        [self resizeViews];
        
        _alertView.center = CGPointMake(CGRectGetMidX(_alertWindow.bounds), CGRectGetMidY(_alertWindow.bounds));
    }
    return self;
}

- (void)show
{
    [[PXAlertViewQueue sharedInstance] add:self];
}

- (void)_show
{
    [self.alertWindow addSubview:self];
    [self.alertWindow makeKeyAndVisible];
    self.visible = YES;
    [self showBackgroundView];
    [self showAlertAnimation];
}

- (void)showBackgroundView
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.mainWindow.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        [self.mainWindow tintColorDidChange];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundView.alpha = 1;
    }];
}

- (void)hide
{
    [self removeFromSuperview];
}

- (void)dismiss:(id)sender
{
    self.visible = NO;
    
    if ([[[PXAlertViewQueue sharedInstance] alertViews] count] == 1) {
        [self dismissAlertAnimation];
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
            self.mainWindow.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
            [self.mainWindow tintColorDidChange];
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.backgroundView.alpha = 0;
            [self.mainWindow makeKeyAndVisible];
        }];
    }
    
    
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alertView.alpha = 0;
    } completion:^(BOOL finished) {
        [[PXAlertViewQueue sharedInstance] remove:self];
        [self removeFromSuperview];
    }];
    
    BOOL cancelled;
    if (sender == self.tap || [sender isKindOfClass:[UIButton class]] || sender == nil) {
        if (sender == self.otherButton) {
            cancelled = NO;
        } else {
            cancelled = YES;
        }
    } else {
        cancelled = NO;
    }
    if (self.completion) {
        self.completion(cancelled);
    }
}

- (void)setBackgroundColorForButton:(id)sender
{
    [sender setBackgroundColor:[UIColor colorWithWhite:0.85 alpha:1]];
}

- (void)clearBackgroundColorForButton:(id)sender
{
    [sender setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - public

+ (PXAlertView *)showAlertWithTitle:(NSString *)title
{
    return [PXAlertView showAlertWithTitle:title message:nil cancelTitle:NSLocalizedString(@"确定", nil) completion:nil];
}

+ (PXAlertView *)showAlertWithTitle:(NSString *)title
                            message:(NSString *)message
{
    return [PXAlertView showAlertWithTitle:title message:message cancelTitle:NSLocalizedString(@"确定", nil) completion:nil];
}

+ (PXAlertView *)showAlertWithTitle:(NSString *)title
                            message:(NSString *)message
                         completion:(void(^) (BOOL cancelled))completion
{
    return [PXAlertView showAlertWithTitle:title message:message cancelTitle:NSLocalizedString(@"确定", nil) completion:completion];
}

+ (PXAlertView *)showAlertWithTitle:(NSString *)title
                            message:(NSString *)message
                        cancelTitle:(NSString *)cancelTitle
                         completion:(void(^) (BOOL cancelled))completion
{
    PXAlertView *alertView = [[PXAlertView alloc] initAlertWithTitle:title
                                                             message:message
                                                         cancelTitle:cancelTitle
                                                          otherTitle:nil
                                                         contentView:nil
                                                          completion:completion];
    [alertView show];
    return alertView;
}

+ (PXAlertView *)showAlertWithTitle:(NSString *)title
                            message:(NSString *)message
                        cancelTitle:(NSString *)cancelTitle
                         otherTitle:(NSString *)otherTitle
                         completion:(void(^) (BOOL cancelled))completion
{
    PXAlertView *alertView = [[PXAlertView alloc] initAlertWithTitle:title
                                                             message:message
                                                         cancelTitle:cancelTitle
                                                          otherTitle:otherTitle
                                                         contentView:nil
                                                          completion:completion];
    [alertView show];
    return alertView;
}

+ (PXAlertView *)showAlertWithTitle:(NSString *)title
                            message:(NSString *)message
                        cancelTitle:(NSString *)cancelTitle
                         otherTitle:(NSString *)otherTitle
                        contentView:(UIView *)view
                         completion:(void(^) (BOOL cancelled))completion
{
    PXAlertView *alertView = [[PXAlertView alloc] initAlertWithTitle:title
                                                             message:message
                                                         cancelTitle:cancelTitle
                                                          otherTitle:otherTitle
                                                         contentView:view
                                                          completion:completion];
    [alertView show];
    return alertView;
}

#pragma mark - gestures

- (void)setupGestures
{
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [self.tap setNumberOfTapsRequired:1];
    [self.backgroundView setUserInteractionEnabled:YES];
    [self.backgroundView setMultipleTouchEnabled:NO];
    [self.backgroundView addGestureRecognizer:self.tap];
}

#pragma mark -

- (CGRect)adjustLabelFrameHeight:(UILabel *)label
{
    CGFloat height;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize size = [label.text sizeWithFont:label.font
                             constrainedToSize:CGSizeMake(label.frame.size.width, FLT_MAX)
                                 lineBreakMode:NSLineBreakByWordWrapping];
        
        height = size.height;
        #pragma clang diagnostic pop
    } else {
        NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
        context.minimumScaleFactor = 1.0;
        CGRect bounds = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, FLT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:label.font}
                                        context:context];
        height = bounds.size.height;
    }
    
    return CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, height);
}

- (void)resizeViews
{
    CGFloat totalHeight = 0;
    for (UIView *view in [self.alertView subviews]) {
        if ([view class] != [UIButton class]) {
            totalHeight += view.frame.size.height + AlertViewVerticalElementSpace;
        }
    }
    //自定义
    if (_cancelTitle) {
        totalHeight += AlertViewButtonHeight;
    }
    //totalHeight += AlertViewButtonHeight;
    totalHeight += AlertViewVerticalElementSpace;
    
    self.alertView.frame = CGRectMake(self.alertView.frame.origin.x,
                                      self.alertView.frame.origin.y,
                                      self.alertView.frame.size.width,
                                      totalHeight);
}

- (void)showAlertAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = .3;
    
    [self.alertView.layer addAnimation:animation forKey:@"showAlert"];
}

- (void)dismissAlertAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1)]];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeRemoved;
    animation.duration = .2;
    
    [self.alertView.layer addAnimation:animation forKey:@"dismissAlert"];
}

@end

@implementation PXAlertViewQueue

+ (instancetype)sharedInstance
{
    static PXAlertViewQueue *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[PXAlertViewQueue alloc] init];
        _sharedInstance.alertViews = [NSMutableArray array];
    });
    
    return _sharedInstance;
}

- (void)add:(PXAlertView *)alertView
{
    [self.alertViews addObject:alertView];
    [alertView _show];
    for (PXAlertView *av in self.alertViews) {
        if (av != alertView) {
            [av hide];
        }
    }
}

- (void)remove:(PXAlertView *)alertView
{
    [self.alertViews removeObject:alertView];
    PXAlertView *last = [self.alertViews lastObject];
    if (last) {
        [last _show];
    }
}

@end
