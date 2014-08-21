//
//  StringUtil.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-1.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  # 与字符串操作相关的工具类
 */
@interface StringUtil : NSObject

+ (BOOL)isNull:(NSString *)srcString;

+ (NSString *)getMd5String:(NSString *)srcString;

+ (NSString *)createUUID;

+ (NSString *)get8BitDateStringFromDate:(NSDate *)date;

+ (NSString *)get14BitDateStringFromDate:(NSDate *)date;

+ (NSString *)get8BitFormateDateString:(NSDate *)date;

+ (NSString *)get8BitDateStringFromFormatDateString:(NSString *)string;

+ (NSString *)get14BitFormateDateString:(NSDate *)date;

+ (NSString *)get14BitDateStringFromFormatDateString:(NSString *)string;

+ (NSDate *)getDateFromFormatDateString:(NSString *)formatDateString;

+ (NSString *)getDateFormatStringFrom8BitString:(NSString *)formatDateString;

+ (NSString *)getDateFormatStringFrom14BitString:(NSString *)formatDateString;

@end
