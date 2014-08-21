//
//  TabContainerViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-7-29.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//
#import "ProductSync.h"
#import "TabContainerViewController.h"
/**
 *  # 主界面选项卡容器视图控制器,在此对选项卡视图作初始化,此外,当用户登录成功,会进行异步网络操作`ProductSync`
 */
@interface TabContainerViewController ()

@end

@implementation TabContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [ProductSync start];
    [[self tabBar] setBackgroundImage:[UIImage imageNamed:@"tab_bg"]];
    [[self tabBar]
     setSelectionIndicatorImage:[UIImage imageNamed:@"tab_bg_pressed"]];
    
    NSArray *selectedImageArray = [NSArray
                                   arrayWithObjects:
                                   [self imageNamedWithDefaultRenderingMode:@"tabbar_home_highlighted"],
                                   [self imageNamedWithDefaultRenderingMode:@"tabbar_profile_highlighted"],
                                   [self imageNamedWithDefaultRenderingMode:@"tabbar_discover_highlighted"],
                                   [self imageNamedWithDefaultRenderingMode:@"tabbar_more_highlighted"], nil];
    
    NSArray *imageArray = [NSArray
                           arrayWithObjects:[self imageNamedWithDefaultRenderingMode:@"tabbar_home"],
                           [self imageNamedWithDefaultRenderingMode:@"tabbar_profile"],
                           [self imageNamedWithDefaultRenderingMode:@"tabbar_discover"],
                           [self imageNamedWithDefaultRenderingMode:@"tabbar_more"],
                           nil];
    
    for (int i = 0; i < self.tabBar.items.count; i++) {
        UITabBarItem *item = [self.tabBar.items objectAtIndex:i];
        
        [item setTitlePositionAdjustment:UIOffsetMake(0, -3)];
        
        [item setImage:[imageArray objectAtIndex:i]];
        
        [item setSelectedImage:[selectedImageArray objectAtIndex:i]];
        
        [item setTitleTextAttributes:[NSDictionary
                                      dictionaryWithObjectsAndKeys:
                                      [UIColor orangeColor],
                                      NSForegroundColorAttributeName, nil]
                            forState:UIControlStateSelected];
        
        [item setTitleTextAttributes:[NSDictionary
                                      dictionaryWithObjectsAndKeys:
                                      [UIColor colorWithRed:0x3c / 255.0
                                                      green:0x80 / 255.0
                                                       blue:0x1a / 255.0
                                                      alpha:1.0],
                                      NSBackgroundColorAttributeName, nil]
                            forState:UIControlStateNormal];
    }
}

- (UIImage *)imageNamedWithDefaultRenderingMode:(NSString *)imageName {
    UIImage *image = [[UIImage imageNamed:imageName]
                      imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

@end
