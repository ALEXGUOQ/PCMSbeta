//
//  StringUtil.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-1.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "StringUtil.h"
#import <CommonCrypto/CommonDigest.h>
@implementation StringUtil
/**
 *  判断一个NSString是否为空(@""或nil)
 *
 *  @param srcString <#srcString description#>
 *
 *  @return 为空返回YES,否则返回NO
 */
+ (BOOL)isNull:(NSString *)srcString {
    if (srcString) {
        if ([[srcString stringByTrimmingCharactersInSet:
          [NSCharacterSet whitespaceAndNewlineCharacterSet]]
         isEqualToString:@""]) {
            return YES;
        }
    }
    return NO;
}
/**
 *  获得一个NSString对象的Md5
 *
 *  @param srcString <#srcString description#>
 *
 *  @return 该对象的Md5字符串
 */
+ (NSString *)getMd5String:(NSString *)srcString {
    if (srcString) {
        const char *cStr = [srcString UTF8String];
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5(cStr, (int)strlen(cStr), digest);
        NSMutableString *result =
        [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
            [result appendFormat:@"%02x", digest[i]];
        NSString *ret = [result uppercaseString];
        return ret;
    }
    return @"MD5加密策略错误!";
}
/**
 *  创建UUID
 *
 *  @return <#return value description#>
 */
+ (NSString *)createUUID {
    // Create universally unique identifier (object)
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    // Get the string representation of CFUUID object.
    NSString *uuidStr = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidObject));
    
    // If needed, here is how to get a representation in bytes, returned as a
    // structure
    // typedef struct {
    //   UInt8 byte0;
    //   UInt8 byte1;
    //   …
    //   UInt8 byte15;
    // } CFUUIDBytes;
    // CFUUIDBytes bytes = CFUUIDGetUUIDBytes(uuidObject);
    
    CFRelease(uuidObject);
    
    return uuidStr;
}

#pragma mark - 根据日期获得日期字符串
#pragma mark yyyyMMdd
/**
 *  根据日期获得日期字符串 `get8BitDateStringFromFormatDateString:`,`get8BitFormateDateString:`
 *
 *  @param date NSDate
 *
 *  @return yyyyMMdd
 */
+ (NSString *)get8BitDateStringFromDate:(NSDate *)date {
    return [self get8BitDateStringFromFormatDateString:[self get8BitFormateDateString:date]];
}
#pragma mark yyyyMMddHHmmss
/**
 *  根据日期获得日期字符串 `get14BitDateStringFromFormatDateString:`,`get14BitFormateDateString:`
 *
 *  @param date NSDate
 *
 *  @return yyyyMMddHHmmss
 */
+ (NSString *)get14BitDateStringFromDate:(NSDate *)date {
    return [self get14BitDateStringFromFormatDateString:[self get14BitFormateDateString:date]];
}

#pragma mark - 根据日期获得带 "-" 的日期字符串
#pragma mark yyyy-MM-dd
/**
 *  根据日期获得带 "-" 的日期字符串 `get8BitDateFormatter`
 *
 *  @param date NSDate
 *
 *  @return yyyy-MM-dd
 */
+ (NSString *)get8BitFormateDateString:(NSDate *)date {
    return [[self get8BitDateFormatter] stringFromDate:date];
}
#pragma mark yyyy-MM-dd HH:mm:ss
/**
 *  根据日期获得带 "-" 的日期字符串 `get14BitDateFormatter`
 *
 *  @param date NSDate
 *
 *  @return yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)get14BitFormateDateString:(NSDate *)date {
    return [[self get14BitDateFormatter] stringFromDate:date];
}

#pragma mark - 根据带 "-" 的日期获得不带 "-" 的日期字符串
#pragma mark yyyyMMdd
/**
 *  根据带 "-" 的日期获得不带 "-" 的日期字符串
 *
 *  @param string yyyy-MM-dd
 *
 *  @return yyyyMMdd
 */
+ (NSString *)get8BitDateStringFromFormatDateString:(NSString *)string {
    if (![self isNull:string]) {
        NSString *year = [string substringWithRange:NSMakeRange(0, 4)];
        NSString *month = [string substringWithRange:NSMakeRange(5, 2)];
        NSString *day = [string substringWithRange:NSMakeRange(8, 2)];

        return [NSString stringWithFormat:@"%@%@%@", year, month, day];
    }
    return nil;
}
#pragma mark yyyyMMddHHmmss
/**
 *  根据带 "-" 的日期获得不带 "-" 的日期字符串
 *
 *  @param string yyyy-MM-dd HH:mm:ss
 *
 *  @return yyyyMMddHHmmss
 */
+ (NSString *)get14BitDateStringFromFormatDateString:(NSString *)string {
    if (![self isNull:string]) {
        NSString *year = [string substringWithRange:NSMakeRange(0, 4)];
        NSString *month = [string substringWithRange:NSMakeRange(5, 2)];
        NSString *day = [string substringWithRange:NSMakeRange(8, 2)];
        NSString *hour = [string substringWithRange:NSMakeRange(11, 2)];
        NSString *min = [string substringWithRange:NSMakeRange(14, 2)];
        NSString *sec = [string substringWithRange:NSMakeRange(17, 2)];
        return [NSString
                stringWithFormat:@"%@%@%@%@%@%@", year, month, day, hour, min, sec];
    }
    return nil;
}

#pragma mark - 根据不带 "-" 的日期字符串获得带 "-" 的日期字符串
#pragma mark yyyy-MM-dd
/**
 *  根据不带 "-" 的日期字符串获得带 "-" 的日期字符串
 *
 *  @param formatDateString yyyyMMdd
 *
 *  @return yyyy-MM-dd
 */
+ (NSString *)getDateFormatStringFrom8BitString:(NSString *)formatDateString {
    if (formatDateString) {
        NSString *year = [formatDateString substringWithRange:NSMakeRange(0, 4)];
        NSString *month = [formatDateString substringWithRange:NSMakeRange(4, 2)];
        NSString *day = [formatDateString substringWithRange:NSMakeRange(6, 2)];
        return [NSString stringWithFormat:@"%@-%@-%@", year, month, day];
    }
    return nil;
}
#pragma mark yyyy-MM-dd HH:mm:ss
/**
 *  根据不带 "-" 的日期字符串获得带 "-" 的日期字符串
 *
 *  @param formatDateString yyyyMMddHHmmss
 *
 *  @return yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)getDateFormatStringFrom14BitString:(NSString *)formatDateString {
    if (formatDateString) {
        NSString *year = [formatDateString substringWithRange:NSMakeRange(0, 4)];
        NSString *month = [formatDateString substringWithRange:NSMakeRange(4, 2)];
        NSString *day = [formatDateString substringWithRange:NSMakeRange(6, 2)];
        NSString *hour = [formatDateString substringWithRange:NSMakeRange(8, 2)];
        NSString *min = [formatDateString substringWithRange:NSMakeRange(10, 2)];
        NSString *sec = [formatDateString substringWithRange:NSMakeRange(12, 2)];
        return [NSString
                stringWithFormat:@"%@-%@-%@ %@:%@:%@", year, month, day, hour, min, sec];
    }
    return nil;
}
#pragma mark - 根据带格式的日期字符串获得日期
/**
 *  根据带格式的日期字符串获得日期 `get8BitDateFormatter`,`get14BitDateFormatter`
 *
 *  @param formatDateString yyyy-MM-dd 或者 yyyy-MM-dd HH:mm:ss
 *
 *  @return NSDate
 */
+ (NSDate *)getDateFromFormatDateString:(NSString *)formatDateString {
    if ([formatDateString length] <= 10) {
        return [[self get8BitDateFormatter] dateFromString:formatDateString];
    } else
        return [[self get14BitDateFormatter] dateFromString:formatDateString];
}
#pragma mark - 初始化日期格式
/**
 *  初始化日期格式
 *
 *  @return NSDateFormatter @"yyyy-MM-dd"
 */
+ (NSDateFormatter *)get8BitDateFormatter {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return formatter;
}
/**
 *  初始化日期格式
 *
 *  @return NSDateFormatter @"yyyy-MM-dd HH:mm:ss"
 */
+ (NSDateFormatter *)get14BitDateFormatter {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return formatter;
}

@end
