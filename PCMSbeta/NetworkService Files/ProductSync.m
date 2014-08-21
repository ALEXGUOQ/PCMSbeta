//
//  ProductSync.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-15.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "ProductSync.h"
#import "ConfigSyncParams.h"
/**
 *  # 同步服务器端的产品数据
 */
@implementation ProductSync

+ (void)start {
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:HOST_IP
                                                                apiPath:STEP_PATH
                                                     customHeaderFields:nil];
    MKNetworkOperation *operation = [engine operationWithPath:nil params:[ConfigSyncParams getParamsDicByTableName:PRODUCT_TABLE_NAME modelName:@"Product"] httpMethod:@"POST"];
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSString *result = [completedOperation responseString];
        NSLog(@"返回------------------------Product------------------------数据：\n%@", result);
        if (![result isEqualToString:@"N"]) {
            [CoreDataUtil deleteModel:MANAGED_OBJECT_CONTEXT modelName:@"Product"];
            NSArray *entities = [EntityUtil parseJsonObjectStrToEntityArray:result];
            for (int i = 0; i < entities.count; i++) {
                Product *product = (Product *)[CoreDataUtil createData:MANAGED_OBJECT_CONTEXT modelName:@"Product"];
                NSDictionary *entity = [EntityUtil parseJsonObjectStrToDic:entities[i]];
                [EntityUtil reflectDataFromOtherObject4Entity:product
                                                     withData:entity];
            }
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"ProductSync请求出错");
        //[ViewBuilder autoDismissAlertViewWithTitle:@"连接到服务器错误,同步失败!" afterDelay:1.5f];
    }];
    [engine enqueueOperation:operation];
}

@end
