//
//  SetPwdRemembered.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-13.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "SetPwdRemembered.h"
/**
 *  # 设置是否记住密码工具类,该状态保存到本地文件rememberPwd.plist中
 */
@implementation SetPwdRemembered
/**
 *  获得当前文件中是否记住密码的状态
 *
 *  @return 记住返回YES,否则返回NO
 */
+ (BOOL)getIsRemembered {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *filename = [plistPath1 stringByAppendingPathComponent:@"rememberPwd.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    NSString *ret = [data valueForKey:@"isRemember"];
    if ([ret isEqualToString:@"Y"]) {
        return YES;
    } else {
        return NO;
    }
}
/**
 *  设置是否记住密码
 *
 *  @param str @"Y" 或者 @"N"
 */
+ (void)setIsRemembered:(NSString *)str {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"rememberPwd" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    [data setValue:str forKey:@"isRemember"];
    //获取应用程序沙盒的Documents目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *filename = [plistPath1 stringByAppendingPathComponent:@"rememberPwd.plist"];
    //输入写入
    [data writeToFile:filename atomically:YES];
}

@end
