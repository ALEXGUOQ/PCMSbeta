//
//  ConfigSyncParams.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-12.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigSyncParams : NSObject

+ (NSMutableDictionary *)getParamsDicByTableName:(NSString *)name modelName:(NSString *)modelName;

@end
