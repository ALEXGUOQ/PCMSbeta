//
//  ViewBuilder.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-7-30.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "MyAreaPickerView.h"
/**
 *  # 视图构建器,构建通用视图
 */
@interface ViewBuilder : NSObject

- (UIView *)buttonListByTitles:(NSArray *)titleArray viewWidth:(CGFloat)width;

+ (MyAreaPickerView *)areaPickerView;

+ (UIDatePicker *)datePickerByDateString:(NSString *)dateString;

+ (void)autoDismissAlertViewWithTitle:(NSString *)title afterDelay:(NSTimeInterval)delay;

+ (UIAlertView *)showAlertWithTitle:(NSString *)title;

+ (UIAlertView *)showAlertWithTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle;

+ (UIAlertView *)showAlertWithTitle:(NSString *)title confirmTitle:(NSString *)confirmTitle;

+ (void)performDismiss:(UIAlertView *)alert;

@end