//
//  PWSCalendarView.m
//  PWSCalendar
//
//  Created by Sylar on 3/14/14.
//  Copyright (c) 2014 PWS. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////////
#import "PWSCalendarView.h"
#import "PWSCalendarSegmentView.h"
#import "PWSCalendarViewCell.h"
//////////////////////////////////////////////////////////////////////////////
const float PWSCalendarHeadViewHeight = 80;
extern NSString* PWSCalendarViewCellId;
const int   PWSCalendarViewNumber = 1000;
//////////////////////////////////////////////////////////////////////////////
@interface PWSCalendarView()
<PWSCalendarSegmentDelegate,
PWSCalendarDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate>
{
    // data
    NSDate*            m_current_date;
    int                m_current_page;
    
    // head view
    UIView*            m_view_head;         // height = 80
    UILabel*           m_label_time;        // height = 30
    PWSCalendarSegmentView*  m_segment;     // height = 30
    UIView*            m_view_weekdays;     // height = 20
    
    UICollectionView*  m_view_calendar;
}
@end
//////////////////////////////////////////////////////////////////////////////
@implementation PWSCalendarView

- (id) initWithFrame:(CGRect)frame
{
    id rt = [self initWithFrame:frame CalendarType:en_calendar_type_month];
    return rt;
}

- (id) initWithFrame:(CGRect)frame CalendarType:(enCalendarViewType)pType
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.type = pType;
        m_current_date = [NSDate date];
        [self SetInitialValue];
    }
    return self;
}

- (void) SetInitialValue
{
    [self SetHeadView];
    [self SetCollectionView];
}

- (void) SetHeadView
{
    float width = self.frame.size.width;
    float origin_x = 0;
    
    m_view_head = [[UIView alloc] init];
    [m_view_head setFrame:CGRectMake(0, 0, width, 80)];
    [self addSubview:m_view_head];
    
    // label time
    m_label_time = [[UILabel alloc] init];
    [m_label_time setFrame:CGRectMake(0, origin_x, width, 30)];
    [m_label_time setText:@""];
    [m_label_time setTextAlignment:NSTextAlignmentCenter];
    [m_view_head addSubview:m_label_time];
    
    // segment
//    origin_x += 30;
//    NSArray* items = [NSArray arrayWithObjects:[self GetSegmentItemWithTitle:@"今天"], [self GetSegmentItemWithTitle:@"按周"], [self GetSegmentItemWithTitle:@"按月"], nil];
//    m_segment = [PWSCalendarSegmentView CreateWithItems:items Frame:CGRectMake(0, origin_x, width, 30)];
//    [m_segment setP_delegate:self];
//    [m_view_head addSubview:m_segment];
    
    // weekdays
    origin_x += 50;
    NSArray* weekdays = [NSArray arrayWithObjects:@"日", @"一", @"二", @"三", @"四", @"五", @"六", nil];
    float day_width = width/7;
    for (int i=0; i<7; i++)
    {
        UILabel* each_day = [[UILabel alloc] init];
        [each_day setText:[weekdays objectAtIndex:i]];
        [each_day setTextAlignment:NSTextAlignmentCenter];
        CGRect each_day_frame = CGRectMake(i*day_width, origin_x, day_width, 20);
        [each_day setFrame:each_day_frame];
        [m_view_head addSubview:each_day];
    }
}

- (void) SetLabelDate:(NSDate*)_date
{
    NSDateFormatter* ff = [[NSDateFormatter alloc] init];
    [ff setDateFormat:@"yyyy年MM月"];
    NSString* date = [ff stringFromDate:_date];
    [m_label_time setText:date];
}

- (PWSCalendarSegmentItem*) GetSegmentItemWithTitle:(NSString*)pTitle
{
    UILabel* label = [[UILabel alloc] init];
    [label setText:pTitle];
    PWSCalendarSegmentItem* rt = [PWSCalendarSegmentItem CreateWithImage:nil HighLightedImage:nil Label:label LabelColor:[UIColor blackColor] LabelHighlightedColor:[UIColor blueColor]];
    return rt;
}

- (void) SetCollectionView
{
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setMinimumLineSpacing:0];
    [layout setMinimumInteritemSpacing:0];
    [layout setItemSize:CGSizeMake(width, height-80)];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    m_view_calendar = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 80, width, height-80) collectionViewLayout:layout];
    [m_view_calendar setShowsHorizontalScrollIndicator:NO];
    [m_view_calendar setDelegate:self];
    [m_view_calendar setDataSource:self];
    [m_view_calendar setBackgroundColor:[UIColor clearColor]];
    [self addSubview:m_view_calendar];
    m_view_calendar.pagingEnabled = YES;
    
    [m_view_calendar registerClass:[PWSCalendarViewCell class] forCellWithReuseIdentifier:PWSCalendarViewCellId.copy];
    
    m_current_page = PWSCalendarViewNumber/2;
    NSIndexPath* mid_index = [NSIndexPath indexPathForRow:m_current_page inSection:0];
    [m_view_calendar scrollToItemAtIndexPath:mid_index atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    [self SetLabelDate:[NSDate date]];
}


// collection view delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return PWSCalendarViewNumber;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PWSCalendarViewCell* cell = [m_view_calendar dequeueReusableCellWithReuseIdentifier:PWSCalendarViewCellId.copy forIndexPath:indexPath];
    
    NSDate* cell_date = m_current_date;
    
    if (indexPath.row != m_current_page)
    {
        if (self.type == en_calendar_type_month)
        {
            if (indexPath.row > m_current_page)
            {
                cell_date = [PWSHelper GetNextMonth:m_current_date];
            }
            else
            {
                cell_date = [PWSHelper GetPreviousMonth:m_current_date];
            }
        }
        else if (self.type == en_calendar_type_week)
        {
            if (indexPath.row > m_current_page)
            {
                cell_date = [PWSHelper GetNextWeek:m_current_date];
            }
            else
            {
                cell_date = [PWSHelper GetPreviousWeek:m_current_date];
            }
        }
    }
    [cell setDelegate:self];
    [cell SetWithDate:cell_date ShowType:self.type];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"\n pos = %f %f", collectionView.contentOffset.x, collectionView.contentOffset.y);
    
    float cell_width = collectionView.frame.size.width;
    int pos_x = collectionView.contentOffset.x;
    int index = (pos_x+20)/cell_width;
    
    if (m_current_page != index)
    {
        if (self.type == en_calendar_type_month)
        {
            if (m_current_page > index)
            {
                m_current_date = [PWSHelper GetPreviousMonth:m_current_date];
            }
            else if (m_current_page < index)
            {
                m_current_date = [PWSHelper GetNextMonth:m_current_date];
            }
            m_current_page = index;
        }
        else if (self.type == en_calendar_type_week)
        {
            if (m_current_page > index)
            {
                m_current_date = [PWSHelper GetPreviousWeek:m_current_date];
            }
            else if (m_current_page < index)
            {
                m_current_date = [PWSHelper GetNextWeek:m_current_date];
            }
            m_current_page = index;
        }
    }
    
    [self SetLabelDate:m_current_date];
}

- (void) ScrollToToday
{
    NSDate* today = [NSDate date];
    if (self.type == en_calendar_type_month)
    {
        // max scroll 2 page
        if (![PWSHelper CheckSameMonth:today AnotherMonth:m_current_date])
        {
            int scroll_pages = 0;
            NSComparisonResult result = [today compare:m_current_date];
            if (result == NSOrderedDescending)
            {
                if ([PWSHelper CheckThisMonth:m_current_date NextMonth:today])
                {
                    scroll_pages = 1;
                    m_current_date = [PWSHelper GetPreviousMonth:today];
                }
                else
                {
                    scroll_pages = 2;
                    m_current_date = [PWSHelper GetPreviousMonth:today];
                    m_current_date = [PWSHelper GetPreviousMonth:m_current_date];
                }
            }
            else if (result == NSOrderedAscending)
            {
                if ([PWSHelper CheckThisMonth:today NextMonth:m_current_date])
                {
                    scroll_pages = -1;
                    m_current_date = [PWSHelper GetNextMonth:today];
                }
                else
                {
                    scroll_pages = -2;
                    m_current_date = [PWSHelper GetNextMonth:today];
                    m_current_date = [PWSHelper GetNextMonth:m_current_date];
                }
            }
            
            NSIndexPath* indexpath = [NSIndexPath indexPathForRow:m_current_page+scroll_pages inSection:0];
            [m_view_calendar scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
    }
    else if (self.type == en_calendar_type_week)
    {
        if (![PWSHelper CheckSameWeek:m_current_date AnotherWeek:today])
        {
            int scroll_pages = 0;
            NSComparisonResult result = [today compare:m_current_date];
            if (result == NSOrderedDescending)
            {
                if ([PWSHelper CheckThisWeek:m_current_date NextWeek:today])
                {
                    scroll_pages = 1;
                    m_current_date = [PWSHelper GetPreviousWeek:today];
                }
                else
                {
                    scroll_pages = 2;
                    m_current_date = [PWSHelper GetPreviousWeek:today];
                    m_current_date = [PWSHelper GetPreviousWeek:m_current_date];
                }
            }
            else if (result == NSOrderedAscending)
            {
                if ([PWSHelper CheckThisWeek:today NextWeek:m_current_date])
                {
                    scroll_pages = -1;
                    m_current_date = [PWSHelper GetNextWeek:today];
                }
                else
                {
                    scroll_pages = -2;
                    m_current_date = [PWSHelper GetNextWeek:today];
                    m_current_date = [PWSHelper GetNextWeek:m_current_date];
                }
            }
            
            NSIndexPath* indexpath = [NSIndexPath indexPathForRow:m_current_page+scroll_pages inSection:0];
            [m_view_calendar scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
    }
}

// segment delegate
- (void) PWSCalendarSegment:(PWSCalendarSegmentView *)_segment didSelectedIndex:(NSInteger)_index
{
    if (_index == 1)
    {
        // week
        self.type = en_calendar_type_week;
        NSArray* cells = [m_view_calendar visibleCells];
        for (PWSCalendarViewCell* each_cell in cells)
        {
            [each_cell setType:en_calendar_type_week];
        }
        
    }
    else if (_index == 2)
    {
        // month
        self.type = en_calendar_type_month;
        NSArray* cells = [m_view_calendar visibleCells];
        for (PWSCalendarViewCell* each_cell in cells)
        {
            [each_cell setType:en_calendar_type_month];
        }
    }
    else if (_index == 0)
    {
        [self ScrollToToday];
    }
    
    [m_view_calendar reloadData];
}

// calendar delegate
- (void) PWSCalendar:(PWSCalendarView *)_calendar didSelecteDate:(NSDate *)_date
{
    if ([self.delegate respondsToSelector:@selector(PWSCalendar:didSelecteDate:)])
    {
        [self.delegate PWSCalendar:self didSelecteDate:_date];
    }
}


@end
