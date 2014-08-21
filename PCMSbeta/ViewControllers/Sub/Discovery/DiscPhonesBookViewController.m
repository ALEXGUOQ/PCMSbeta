//
//  DiscPhonesBookViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-7-30.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "DiscPhonesBookViewController.h"
#import <MessageUI/MessageUI.h>
/**
 *  # 电话本选项卡容器
 */
@interface DiscPhonesBookViewController () <MFMessageComposeViewControllerDelegate>

@property(nonatomic, strong) NSArray *phoneNumbers;

@end

@implementation DiscPhonesBookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configTabBar];
    _phoneInfo = [[NSMutableDictionary alloc] init];
    _phoneNumbers = [[NSArray alloc] init];
}

- (IBAction)sendSMS:(UIBarButtonItem *)sender {
    _phoneNumbers = [_phoneInfo allValues];
    if (_phoneNumbers.count > 0) {
        if ([MFMessageComposeViewController canSendText]) {
            MFMessageComposeViewController *controller =
            [[MFMessageComposeViewController alloc] init];
            controller.body = @"感谢销管,为我带去最真诚的祝福";
            controller.recipients = _phoneNumbers;
            controller.messageComposeDelegate = self;
            [self presentViewController:controller animated:YES completion:^{}];
        }
    } else {
        [ViewBuilder autoDismissAlertViewWithTitle:@"请先勾选联系人" afterDelay:1.5f];
    }
}

- (void)messageComposeViewController: (MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            [ViewBuilder autoDismissAlertViewWithTitle:@"未知错误!" afterDelay:1.5f];
            break;
        case MessageComposeResultSent:
            [ViewBuilder autoDismissAlertViewWithTitle:@"信息发送成功!" afterDelay:1.5f];
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)configTabBar {
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    NSMutableDictionary *textAttrsSelected = [NSMutableDictionary dictionary];
    textAttrsSelected[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrsSelected[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    [[UITabBarItem appearance] setTitleTextAttributes:textAttrs
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:textAttrsSelected
                                             forState:UIControlStateSelected];
    [[self tabBar] setBackgroundImage:[UIImage imageNamed:@"tab_bg"]];
    [[self tabBar]
     setSelectionIndicatorImage:[UIImage imageNamed:@"tab_bg_pressed_large"]];
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -15)];
}

@end
