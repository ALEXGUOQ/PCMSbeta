//
//  SetPwdRemembered.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-13.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SetPwdRemembered : NSObject

+ (BOOL)getIsRemembered;

+ (void)setIsRemembered:(NSString *)str;

@end
