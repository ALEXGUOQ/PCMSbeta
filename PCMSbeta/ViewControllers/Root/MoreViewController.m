//
//  MoreViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-7-29.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "MoreViewController.h"
#import "SetPwdRemembered.h"
/**
 *  # 更多
 */
@interface MoreViewController () <UIAlertViewDelegate>

@end

@implementation MoreViewController

#pragma mark - lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)logOut:(UIBarButtonItem *)sender {
    UIAlertView *alert = [ViewBuilder showAlertWithTitle:@"确认是否退出?" cancelTitle:@"确定"];
    alert.delegate = self;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [SetPwdRemembered setIsRemembered:@"N"];
        [self presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController] animated:YES completion:^{}];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"agreement"]) {
        [segue.destinationViewController setTitle:@"使用协议"];
    } else if ([segue.identifier isEqualToString:@"about"]) {
        [segue.destinationViewController setTitle:@"关于我们"];
    } else if ([segue.identifier isEqualToString:@"feedback"]) {
        [segue.destinationViewController setTitle:@"意见反馈"];
    } else if ([segue.identifier isEqualToString:@"changePassword"]) {
        [segue.destinationViewController setTitle:@"修改密码"];
    }
}


@end
