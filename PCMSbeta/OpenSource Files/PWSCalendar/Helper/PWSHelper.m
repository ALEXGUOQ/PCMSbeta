//
//  PWSHelper.m
//  PWSCalendar
//
//  Created by Sylar on 3/14/14.
//  Copyright (c) 2014 PWS. All rights reserved.
//

#import "PWSHelper.h"

@implementation PWSHelper

+ (NSDate*) GetNextMonth:(NSDate*)_date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:_date];
    
    int year  = (int)comps.year;
    int month = (int)comps.month;
    int day   = (int)comps.day;
    
    NSDate* rt = nil;
    
    if (day <= 28 || month == 12)
    {
        comps.month = month+1;
        rt = [cal dateFromComponents:comps];
    }
    else
    {
        NSString* ss = [NSString stringWithFormat:@"%d-%d-3", year, month+1];
        NSDateFormatter* ff = [[NSDateFormatter alloc] init];
        [ff setDateFormat:@"yyyy-MM-dd"];
        NSDate* the_month = [ff dateFromString:ss];
        NSRange rng = [cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:the_month];
        int day_in_month = (int)rng.length;
        
        NSString* datestring = [NSString stringWithFormat:@"%d-%d-%d", year, month+1, MIN(day, day_in_month)];
        rt = [ff dateFromString:datestring];
    }
    
    return rt;
}

+ (NSDate*) GetPreviousMonth:(NSDate*)_date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:_date];
    
    int year  = (int)comps.year;
    int month = (int)comps.month;
    int day   = (int)comps.day;
    
    NSDate* rt = nil;
    
    if (day <= 28 || month == 1)
    {
        comps.month = month-1;
        rt = [cal dateFromComponents:comps];
    }
    else
    {
        NSString* ss = [NSString stringWithFormat:@"%d-%d-3", year, month-1];
        NSDateFormatter* ff = [[NSDateFormatter alloc] init];
        [ff setDateFormat:@"yyyy-MM-dd"];
        NSDate* the_month = [ff dateFromString:ss];
        NSRange rng = [cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:the_month];
        int day_in_month = (int)rng.length;
        
        NSString* datestring = [NSString stringWithFormat:@"%d-%d-%d", year, month-1, MIN(day, day_in_month)];
        rt = [ff dateFromString:datestring];
    }
    return rt;
}

+ (NSDate*) GetNextWeek:(NSDate*)_date
{
    NSDate* rt = [_date dateByAddingTimeInterval:7*3600*24];
    return rt;
}

+ (NSDate*) GetPreviousWeek:(NSDate*)_date
{
    NSDate* rt = [_date dateByAddingTimeInterval:-7*3600*24];
    return rt;
}

+ (BOOL) CheckSameDay:(NSDate*)_date1 AnotherDate:(NSDate*)_date2
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* s1 = [formatter stringFromDate:_date1];
    NSString* s2 = [formatter stringFromDate:_date2];
    BOOL rt = [s1 isEqualToString:s2];
    return rt;
}

+ (BOOL) CheckThisMonth:(NSDate*)_thisMonth NextMonth:(NSDate*)_nextMonth
{
    BOOL rt = [self CheckSameMonth:[self GetNextMonth:_thisMonth] AnotherMonth:_nextMonth];
    return rt;
}

+ (BOOL) CheckSameMonth:(NSDate*)_month1 AnotherMonth:(NSDate*)_month2
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents* m1 = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:_month1];
    NSDateComponents* m2 = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:_month2];
    BOOL rt = NO;
    if ((m1.year == m2.year) && (m1.month == m2.month))
    {
        rt = YES;
    }
    return rt;
}

+ (BOOL) CheckThisWeek:(NSDate*)_thisWeek NextWeek:(NSDate*)_nextWeek
{
    BOOL rt = [self CheckSameWeek:[self GetNextWeek:_thisWeek] AnotherWeek:_nextWeek];
    return rt;
}

+ (BOOL) CheckSameWeek:(NSDate*)_week1 AnotherWeek:(NSDate*)_week2
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents* w1 = [cal components:NSYearCalendarUnit|NSWeekCalendarUnit fromDate:_week1];
    NSDateComponents* w2 = [cal components:NSYearCalendarUnit|NSWeekCalendarUnit fromDate:_week2];
    BOOL rt = NO;
    if ((w1.week == w2.week) && ([_week1 timeIntervalSinceDate:_week2]<=24*3600*7))
    {
        rt = YES;
    }
    return rt;
}


@end
