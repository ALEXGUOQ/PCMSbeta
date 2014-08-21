//
//  AgentSync.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-12.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "AgentSync.h"
#import "ConfigSyncParams.h"
/**
 *  # 同步服务器端的代理商数据
 */
@implementation AgentSync

+ (void)start {
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:HOST_IP
                                                                apiPath:STEP_PATH
                                                     customHeaderFields:nil];
    MKNetworkOperation *operation = [engine operationWithPath:nil params:[ConfigSyncParams getParamsDicByTableName:AGENT_TABLE_NAME modelName:@"Agent"] httpMethod:@"POST"];
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSString *result = [completedOperation responseString];
        NSLog(@"返回------------------------Agent------------------------数据：\n%@", result);
        if (![result isEqualToString:@"N"]) {
            [CoreDataUtil deleteModel:MANAGED_OBJECT_CONTEXT modelName:@"Agent"];
            NSArray *entities = [EntityUtil parseJsonObjectStrToEntityArray:result];
            for (int i = 0; i < entities.count; i++) {
                Agent *agent = (Agent *)[CoreDataUtil createData:MANAGED_OBJECT_CONTEXT modelName:@"Agent"];
                NSDictionary *entity = [EntityUtil parseJsonObjectStrToDic:entities[i]];
                [EntityUtil reflectDataFromOtherObject4Entity:agent
                                                           withData:entity];
            }
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"AgentSync请求出错");
        [ViewBuilder autoDismissAlertViewWithTitle:@"连接到服务器错误,同步失败!" afterDelay:1.5f];
    }];
    [engine enqueueOperation:operation];
}

@end
