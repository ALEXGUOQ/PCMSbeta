//
//  PWSCalendarSegmentView.h
//  PWSCalendar
//
//  Created by Sylar on 3/14/14.
//  Copyright (c) 2014 PWS. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////////
#import <UIKit/UIKit.h>
@class PWSCalendarSegmentView;
//////////////////////////////////////////////////////////////////////////////
@interface PWSCalendarSegmentItem : UIButton

+ (id) CreateWithImage:(UIImage *)_image HightlightedImage:(UIImage*)_imgHighlighted Label:(UILabel*)_label;

+ (id) CreateWithImage:(UIImage*)_image HighLightedImage:(UIImage*)_imgHighlighted Label:(UILabel*)_theLabel LabelColor:(UIColor*)_labelColor LabelHighlightedColor:(UIColor*)_labelHighlightedColor;

- (void) AutoLayoutWithFrame:(CGRect)_frame;

- (void) SetHighlightedState:(BOOL)_highlighted;

@end
//////////////////////////////////////////////////////////////////////////////
@protocol PWSCalendarSegmentDelegate <NSObject>

@optional
- (void) PWSCalendarSegment:(PWSCalendarSegmentView*)_segment didSelectedIndex:(NSInteger)_index;

@end
//////////////////////////////////////////////////////////////////////////////
@interface PWSCalendarSegmentView : UIView

@property (nonatomic, strong) id<PWSCalendarSegmentDelegate> p_delegate;
@property (nonatomic, assign) UIColor*                       p_selected_color;

+ (id) CreateWithItems:(NSArray*)_items Frame:(CGRect)_frame;

@end
