//
//  CalenderViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-7-29.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "CalenderViewController.h"
#import "PWSCalendarView.h"

@interface CalenderViewController ()<PWSCalendarDelegate>

@end

@implementation CalenderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIImageView *backgroudImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calender_bg"]];
        backgroudImg.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:backgroudImg];
        PWSCalendarView *view = [[PWSCalendarView alloc]
                                 initWithFrame:CGRectMake(0, 70, kSCREEN_WIDTH, 500)
                                 CalendarType:en_calendar_type_month];
        [self.view addSubview:view];
        self.title = @"日历";
        [view setDelegate:self];
    }
    return self;
}

- (void)PWSCalendar:(PWSCalendarView *)_calendar
     didSelecteDate:(NSDate *)_date {
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *components = [calender components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:_date];
    [components setTimeZone:[[NSTimeZone alloc] initWithName:@"GMT"]];
    _home.userSelectedDate = [calender dateFromComponents:components];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
