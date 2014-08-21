//
//  MoreSubInfoViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-7-29.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "MoreSubInfoViewController.h"
/**
 *  # 使用协议及关于我们界面
 */
@interface MoreSubInfoViewController ()

@end

@implementation MoreSubInfoViewController

#pragma mark - lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.title isEqualToString:@"使用协议"]) {
        [self.view
         addSubview:[self getWebViewFromFileName:@"agreement" ofType:@"html"]];
    } else if ([self.title isEqualToString:@"关于我们"]) {
        [self.view
         addSubview:[self getWebViewFromFileName:@"about_us" ofType:@"html"]];
    }
    
}

#pragma mark - ViewBuilder

- (UIWebView *)getWebViewFromFileName:(NSString *)fileName
                               ofType:(NSString *)ofType {
    UIWebView *webView =
    [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, 320, 500)];
    webView.backgroundColor = [UIColor clearColor];
    NSString *htmlPath =
    [[NSBundle mainBundle] pathForResource:fileName ofType:ofType];
    NSURL *baseUrl =
    [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileName
                                                           ofType:ofType]];
    NSError *error;
    NSString *html = [[NSString alloc] initWithContentsOfFile:htmlPath
                                                     encoding:NSUTF8StringEncoding
                                                        error:&error];
    [webView loadHTMLString:html baseURL:baseUrl];
    return webView;
}

@end
