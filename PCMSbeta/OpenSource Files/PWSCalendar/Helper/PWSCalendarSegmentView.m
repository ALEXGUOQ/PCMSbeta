//
//  PWSCalendarSegmentView.m
//  PWSCalendar
//
//  Created by Sylar on 3/14/14.
//  Copyright (c) 2014 PWS. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////////////////////
#import "PWSCalendarSegmentView.h"
//////////////////////////////////////////////////////////////////////////////////////////
const float SegmentMoveInterval = 0.5f;
//////////////////////////////////////////////////////////////////////////////////////////
@interface PWSCalendarSegmentItem()
{
    UIImageView*  m_img_view;
    UILabel*      m_label;
}
@property (nonatomic, copy) UIImage* p_img;
@property (nonatomic, copy) UIImage* p_img_highlighted;
@property (nonatomic, copy) UIColor* p_label_color;
@property (nonatomic, copy) UIColor* p_label_highlighted_color;
@end
//////////////////////////////////////////////////////////////////////////////////////////
@implementation PWSCalendarSegmentItem

+ (id) CreateWithImage:(UIImage *)_image HightlightedImage:(UIImage*)_imgHighlighted Label:(UILabel*)_label
{
    PWSCalendarSegmentItem* rt = [self CreateWithImage:_image HighLightedImage:_imgHighlighted Label:_label LabelColor:[UIColor blackColor] LabelHighlightedColor:[UIColor redColor]];
    return rt;
}

+ (id) CreateWithImage:(UIImage*)_image HighLightedImage:(UIImage*)_imgHighlighted Label:(UILabel*)_theLabel LabelColor:(UIColor*)_labelColor LabelHighlightedColor:(UIColor*)_labelHighlightedColor
{
    PWSCalendarSegmentItem* rt = [[PWSCalendarSegmentItem alloc] initWithImage:_image Label:_theLabel];
    rt.p_img = _image;
    rt.p_img_highlighted = _imgHighlighted;
    rt.p_label_color = _labelColor;
    rt.p_label_highlighted_color = _labelHighlightedColor;
    return rt;
}

- (id) initWithImage:(UIImage*)_image Label:(UILabel*)_theLabel
{
    self = [super init];
    if (self)
    {
        m_img_view = [[UIImageView alloc] init];
        [m_img_view setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:m_img_view];
        m_label = _theLabel;
        [self addSubview:m_label];
    }
    return self;
}

- (void) setP_img:(UIImage *)p_img
{
    _p_img = p_img;
    [m_img_view setImage:p_img];
}

- (void) setP_img_highlighted:(UIImage *)p_img_highlighted
{
    _p_img_highlighted = p_img_highlighted;
    [m_img_view setHighlightedImage:p_img_highlighted];
}

- (void) setP_label_color:(UIColor *)p_label_color
{
    _p_label_color = p_label_color;
    [m_label setTextColor:p_label_color];
}

- (void) setP_label_highlighted_color:(UIColor *)p_label_highlighted_color
{
    _p_label_highlighted_color = p_label_highlighted_color;
    [m_label setHighlightedTextColor:p_label_highlighted_color];
}

- (void) AutoLayoutWithFrame:(CGRect)_frame
{
    float edge = 5;
    float frame_1_3 = _frame.size.width/3;
    float height = _frame.size.height;
    
    CGRect image_view_frame = CGRectMake(edge, 0, frame_1_3-edge, height);
    
    CGRect label_frame = CGRectMake(frame_1_3, 0, (_frame.size.width-frame_1_3)-edge, height);
    
    [self AutoLayoutWithFrame:_frame ImageViewFrame:image_view_frame LabelFrame:label_frame];
    
}

- (void) AutoLayoutWithFrame:(CGRect)_frame ImageViewFrame:(CGRect)_imageViewFrame LabelFrame:(CGRect)_labelFrame
{
    [self setFrame:_frame];
    
    [m_img_view setFrame:_imageViewFrame];
    
    [m_label setFrame:_labelFrame];
}

- (void) SetHighlightedState:(BOOL)_highlighted
{
    [m_img_view setHighlighted:_highlighted];
    [m_label setHighlighted:_highlighted];
}


@end
//////////////////////////////////////////////////////////////////////////////////////////
@interface PWSCalendarSegmentView()
{
    UIView*  m_selected_view;
    NSArray* m_items;
}
@end
//////////////////////////////////////////////////////////////////////////////////////////
@implementation PWSCalendarSegmentView

+ (id) CreateWithItems:(NSArray*)_items Frame:(CGRect)_frame
{
    PWSCalendarSegmentView* rt = [[PWSCalendarSegmentView alloc] initWithItems:_items Frame:_frame];
    return rt;
}

- (void) setP_selected_color:(UIColor *)p_selected_color
{
    _p_selected_color = p_selected_color;
    [m_selected_view setBackgroundColor:p_selected_color];
}

- (id) initWithItems:(NSArray*)_items Frame:(CGRect)_frame
{
    self = [super initWithFrame:_frame];
    if (self)
    {
        m_items = _items;
        [self SetSelectedView];
        [self SetItems];
        [self SetCustom];
        [self SelectedViewMoveToFrame:[m_items firstObject] Animation:NO];
    }
    return self;
}

- (void) SetCustom
{
    [self setBackgroundColor:[UIColor clearColor]];
    [self.layer setCornerRadius:10];
}

- (void) SetSelectedView
{
    m_selected_view = [[UIView alloc] init];
    [m_selected_view.layer setCornerRadius:10];
    [self addSubview:m_selected_view];
}

- (void) SelectedViewMoveToFrame:(PWSCalendarSegmentItem*)_item Animation:(BOOL)_animation
{
    float edge = 2;
    CGRect frame = _item.frame;
    CGRect to_frame = CGRectMake(frame.origin.x+edge, frame.origin.y+edge, frame.size.width-2*edge, frame.size.height-2*edge);
    float animation_time = 0;
    if (_animation)
    {
        animation_time = SegmentMoveInterval;
    }
    [UIView animateWithDuration:animation_time
                     animations:^{
                         [m_selected_view setFrame:to_frame];
                     }
                     completion:^(BOOL finished) {
                         for (PWSCalendarSegmentItem* each_item in m_items)
                         {
                             if (each_item == _item)
                             {
                                 [each_item SetHighlightedState:YES];
                             }
                             else
                             {
                                 [each_item SetHighlightedState:NO];
                             }
                         }
                     }];
}

- (void) SetItems
{
    int item_count = (int)m_items.count;
    float width = self.frame.size.width/item_count;
    float height = self.frame.size.height;
    for(int i=0; i<m_items.count; i++)
    {
        PWSCalendarSegmentItem* each_item = [m_items objectAtIndex:i];
        [each_item AutoLayoutWithFrame:CGRectMake(i*width, 0, width, height)];
        [each_item setTag:i];
        [each_item addTarget:self action:@selector(BtnSelectItem:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:each_item];
    }
}

- (void) BtnSelectItem:(PWSCalendarSegmentItem*)_item
{
    [self SelectedViewMoveToFrame:_item Animation:YES];
    [self performSelector:@selector(cbToDelegateWithIndex:) withObject:_item afterDelay:SegmentMoveInterval];
}

- (void) cbToDelegateWithIndex:(PWSCalendarSegmentItem*)_item
{
    int index = (int)_item.tag;
    if ([self.p_delegate respondsToSelector:@selector(PWSCalendarSegment:didSelectedIndex:)])
    {
        [self.p_delegate PWSCalendarSegment:self didSelectedIndex:index];
    }
}


@end
