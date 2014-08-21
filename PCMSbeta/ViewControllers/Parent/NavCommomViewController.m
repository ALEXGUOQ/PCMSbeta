//
//  NavCommomViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-7-29.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "NavCommomViewController.h"
/** # 用于配置导航栏的父类ViewController,
这里不采用全局方式配置导航栏的原因在于,如果使用全局配置,那么当应用内使用了系统功能
面,如短信界面等,可能会导致系统功能界面出现黒块等怪异问题
 
     - (void)viewDidLoad{
         [super viewDidLoad];
         [[self.navigationController navigationBar]
         setBackgroundImage:[UIImage imageNamed:@"nav_bg"]
         forBarMetrics:UIBarMetricsDefault];
         [[self.navigationController navigationBar]
         setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
         [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
     }
 
 */
@interface NavCommomViewController ()

@end

@implementation NavCommomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self.navigationController navigationBar]
     setBackgroundImage:[UIImage imageNamed:@"nav_bg"]
     forBarMetrics:UIBarMetricsDefault];
    [[self.navigationController navigationBar]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                             [UIColor whiteColor],
                             NSForegroundColorAttributeName,
                             nil]];
}

@end
