//
//  ClientSync.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-12.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "ClientSync.h"
#import "ConfigSyncParams.h"
/**
 *  # 同步服务器端的医院数据
 */
@implementation ClientSync

+ (void)start {
    // path 值可以放到 engine 的初始化中，也可以放到 operation的初始化中，效果一样
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:HOST_IP
                                                                apiPath:STEP_PATH
                                                     customHeaderFields:nil];
    MKNetworkOperation *operation = [engine operationWithPath:nil params:[ConfigSyncParams getParamsDicByTableName:CLIENT_TABLE_NAME modelName:@"Client"] httpMethod:@"POST"];
    // 添加网络请求完成处理逻辑
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        // 获得返回的数据（字符串形式）
        NSString *result = [completedOperation responseString]; // responseData 二进制形式
        NSLog(@"返回------------------------Client------------------------数据：\n%@", result);
        if (![result isEqualToString:@"N"]) {
            [CoreDataUtil deleteModel:MANAGED_OBJECT_CONTEXT modelName:@"Client"];
            NSArray *entities = [EntityUtil parseJsonObjectStrToEntityArray:result];
            for (int i = 0; i < entities.count; i++) {
                Client *client = (Client *)[CoreDataUtil createData:MANAGED_OBJECT_CONTEXT modelName:@"Client"];
                NSDictionary *entity = [EntityUtil parseJsonObjectStrToDic:entities[i]];
                [EntityUtil reflectDataFromOtherObject4Entity:client withData:entity];
            }
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"ClientSync请求出错");
        [ViewBuilder autoDismissAlertViewWithTitle:@"连接到服务器错误,同步失败!" afterDelay:1.5f];
    }];
    // 发送网络请求
    [engine enqueueOperation:operation];
}

@end
