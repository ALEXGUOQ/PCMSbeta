//
//  AchievementSync.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-12.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "AchievementSync.h"
/**
 *  # 同步服务器端的业绩数据
 */
@implementation AchievementSync

+ (void)start {
    NSString *userId =[[APP_DELEGATE currentUser] userId];
    NSString *menuIds = [[APP_DELEGATE currentUser] menuIds];
    NSString *post = [NSString stringWithFormat:@"%@<fh>%@",userId,menuIds];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"findAchievements" forKey:@"method"];
    [params setValue:post forKey:@"data"];
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:HOST_IP
                                                                apiPath:ACHIEVE_PATH
                                                     customHeaderFields:nil];
    MKNetworkOperation *operation = [engine operationWithPath:nil params:params httpMethod:@"POST"];
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSString *result = [completedOperation responseString];
        NSLog(@"返回------------------------Achievement------------------------数据：\n%@", result);
        if (![result isEqualToString:@"N"]) {
            [CoreDataUtil deleteModel:MANAGED_OBJECT_CONTEXT modelName:@"Achievement"];
            NSArray *entities = [EntityUtil parseJsonObjectStrToEntityArray:result];
            for (int i = 0; i < entities.count; i++) {
                Achievement *achievement = (Achievement *)[CoreDataUtil createData:MANAGED_OBJECT_CONTEXT
                                                                         modelName:@"Achievement"];
                NSDictionary *entity = [EntityUtil parseJsonObjectStrToDic:entities[i]];
                [EntityUtil reflectDataFromOtherObject4Entity:achievement withData:entity];
            }
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"AchievementSync请求出错");
        [ViewBuilder autoDismissAlertViewWithTitle:@"连接到服务器错误,同步失败!" afterDelay:1.5f];
    }];
    [engine enqueueOperation:operation];
}

@end
