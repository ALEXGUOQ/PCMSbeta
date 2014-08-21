//
//  ManagementViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-7-29.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "ManagementViewController.h"
#import "ManaTaskViewController.h"
#import "ClientSync.h"
#import "AgentSync.h"
#import "ClientUserSync.h"
#import "AgentUserSync.h"
#import "KeShiSync.h"
#import "SheBeiSync.h"
#import "TaskSync.h"
#import "UserSync.h"
#import "AchievementSync.h"
#import "ProductOrderSync.h"
#import "UIImage+RoundedCorner.h"
/**
 *  # 管理
 */
@interface ManagementViewController ()

@end

@implementation ManagementViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)dataSync {
    UIAlertView *alert = [ViewBuilder showAlertWithTitle:@"正在同步,请稍候..."];
    [ClientSync start];
    [AgentSync start];
    [ClientUserSync start];
    [AgentUserSync start];
    [KeShiSync start];
    [SheBeiSync start];
    [TaskSync start];
    [UserSync start];
    [AchievementSync start];
    [ProductOrderSync start];
    [alert dismissWithClickedButtonIndex:0 animated:NO];
    [ViewBuilder autoDismissAlertViewWithTitle:@"同步成功!" afterDelay:2.0f];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TaskManager"]) {
        [(ManaTaskViewController *)segue.destinationViewController setUserId:[[APP_DELEGATE currentUser] userId]];
    }
}

@end
