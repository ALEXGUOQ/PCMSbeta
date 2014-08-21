//
//  ConfigSyncParams.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-12.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "ConfigSyncParams.h"
/** # 网络同步任务通用的参数配置

     + (NSMutableDictionary *)getParamsDicByTableName:(NSString *)name modelName:(NSString *)modelName {
         NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@",
            [[APP_DELEGATE currentUser] userId]];
         if ([modelName isEqualToString:@"Product"]) {
             predicate = nil;
         }
         NSArray *result = [CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT 
                modelName:modelName withPredicate:predicate];
         NSString *companyId = [[APP_DELEGATE currentUser] companyId];
         NSString *userId = [[APP_DELEGATE currentUser] userId];
         NSString *menuIds = [[APP_DELEGATE currentUser] menuIds];
         id data = result.count == 0 ? @"" : result;
         NSString *post = [EntityUtil parseEntityArrayToJsonObjectStr:data];
         NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
         [params setValue:name forKey:@"table"];
         [params setValue:companyId forKey:@"companyId"];
         [params setValue:userId forKey:@"userId"];
         [params setValue:menuIds forKey:@"menuIds"];
         [params setValue:post forKey:@"data"];
         return params;
     }
 
 */
@implementation ConfigSyncParams

+ (NSMutableDictionary *)getParamsDicByTableName:(NSString *)name modelName:(NSString *)modelName {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@",[[APP_DELEGATE currentUser] userId]];
    if ([modelName isEqualToString:@"Product"]) {
        predicate = nil;
    }
    NSArray *result = [CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT
                                       modelName:modelName
                                   withPredicate:predicate];
    NSString *companyId = [[APP_DELEGATE currentUser] companyId];
    NSString *userId = [[APP_DELEGATE currentUser] userId];
    NSString *menuIds = [[APP_DELEGATE currentUser] menuIds];
    id data = result.count == 0 ? @"" : result;
    NSString *post = [EntityUtil parseEntityArrayToJsonObjectStr:data];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:name forKey:@"table"];
    [params setValue:companyId forKey:@"companyId"];
    [params setValue:userId forKey:@"userId"];
    [params setValue:menuIds forKey:@"menuIds"];
    [params setValue:post forKey:@"data"];
    return params;
}

@end
