//
//  ViewBuilder.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-7-30.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "ViewBuilder.h"

@implementation ViewBuilder

#pragma mark - ButtonsList
/**
 *  构建多个竖向排列的Button,
 *
 *  @param titleArray Button的title,String数组
 *  @param width      Button的宽度
 *
 *  @return UIView
 */
- (UIView *)buttonListByTitles:(NSArray *)titleArray viewWidth:(CGFloat)width {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, titleArray.count * 40)];
    for (int i = 0; i < titleArray.count; i++) {
        if ([titleArray[i] isKindOfClass:[NSString class]]) {
            NSString *title = titleArray[i];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.tag = i;
            btn.frame = CGRectMake(view.frame.origin.x, i * 40, width, 40);
            [view addSubview:btn];
        }
    }
    return view;
}

#pragma mark - AreaPicker
/**
 *  构建省市区域选择器
 *
 *  @return `MyAreaPickerView`
 */
+ (MyAreaPickerView *)areaPickerView {
    return [[MyAreaPickerView alloc] initWithFrame:CGRectMake(0, 0, 260, 10)];
}

#pragma mark - DatePicker
/**
 *  构建日期选择器
 *
 *  @param dateString 格式化的日期字符串
 *
 *  @return UIDatePicker
 */
+ (UIDatePicker *)datePickerByDateString:(NSString *)dateString {
    
    UIDatePicker *oneDatePicker = [[UIDatePicker alloc] init];
    
    oneDatePicker.frame = CGRectMake(10, 10, 250, 10); // 设置显示的位置和大小
    
    if (dateString != nil) {
        oneDatePicker.date = [StringUtil
                              getDateFromFormatDateString:
                              [StringUtil getDateFormatStringFrom8BitString:dateString]];
    } else {
        oneDatePicker.date = [NSDate date]; // 设置初始时间
    }
    
    oneDatePicker.locale =
    [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]; //设置地区
    
    oneDatePicker.datePickerMode = UIDatePickerModeDate; // 设置样式
    
    return oneDatePicker;
}

#pragma mark - AlertView
/**
 *  构建并显示自动消失的系统AlertView`showAlertWithTitle:`
 *
 *  @param title alertView的title
 *  @param delay 自动消失的时间间隔
 */
+ (void)autoDismissAlertViewWithTitle:(NSString *)title afterDelay:(NSTimeInterval)delay {
    [self performSelector:@selector(performDismiss:) withObject:[self showAlertWithTitle:title] afterDelay:delay];
}
/**
 *  构建只具有title的系统AlertView
 *
 *  @param title alertView的title
 *
 *  @return UIAlertView
 */
+ (UIAlertView *)showAlertWithTitle:(NSString *)title {
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.title = title;
    [alert show];
    return alert;
}
/**
 *  构建具有多个按钮的系统AlertView,默认显示了"取消"按钮
 *
 *  @param title       alertView的title
 *  @param cancelTitle 自定义按钮的标题
 *
 *  @return UIAlertView
 */
+ (UIAlertView *)showAlertWithTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:cancelTitle, nil];
    [alert show];
    return alert;
}
/**
 *  构建单个按钮的系统AlertView
 *
 *  @param title        alertView的title
 *  @param confirmTitle 自定义按钮的标题
 *
 *  @return UIAlertView
 */
+ (UIAlertView *)showAlertWithTitle:(NSString *)title confirmTitle:(NSString *)confirmTitle {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:confirmTitle otherButtonTitles:nil, nil];
    [alert show];
    return alert;
}
/**
 *  执行AlertView消失动作
 *
 *  @param alert UIAlertView
 */
+ (void)performDismiss:(UIAlertView *)alert {
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

@end
