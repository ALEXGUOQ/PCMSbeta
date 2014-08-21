//
//  UIImage+RoundedCorner.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-19.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "UIImage+RoundedCorner.h"
/**
 *  # 圆角图片
 */
@implementation UIImage (RoundedCorner)
/**
 *  UIImage引用此方法会得到圆角的UIImage
 *
 *  @param cornerRadius 圆角弧度
 *
 *  @return UIImage
 */
- (UIImage *)roundedCornerImageWithCornerRadius:(CGFloat)cornerRadius {
    CGFloat w = self.size.width;
    CGFloat h = self.size.height;
    CGFloat scale = [UIScreen mainScreen].scale;
    // 防止圆角半径小于0，或者大于宽/高中较小值的一半。
    if (cornerRadius < 0)
        cornerRadius = 0;
    else if (cornerRadius > MIN(w, h))
        cornerRadius = MIN(w, h) / 2.;
    
    UIImage *image = nil;
    CGRect imageFrame = CGRectMake(0., 0., w, h);
    UIGraphicsBeginImageContextWithOptions(self.size, NO, scale);
    [[UIBezierPath bezierPathWithRoundedRect:imageFrame cornerRadius:cornerRadius] addClip];
    [self drawInRect:imageFrame];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
