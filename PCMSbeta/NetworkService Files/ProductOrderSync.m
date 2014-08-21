//
//  ProductOrderSync.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-15.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "ProductOrderSync.h"
#import "ConfigSyncParams.h"
/**
 *  # 同步服务器端的产品订单数据
 */
@implementation ProductOrderSync

+ (void)start {
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:HOST_IP
                                                                apiPath:STEP_PATH
                                                     customHeaderFields:nil];
    MKNetworkOperation *operation = [engine operationWithPath:nil params:[ConfigSyncParams getParamsDicByTableName:PRODUCT_ORDER_TABLE_NAME modelName:@"ProductOrder"] httpMethod:@"POST"];
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSString *result = [completedOperation responseString];
        NSLog(@"返回------------------------ProductOrder------------------------数据：\n%@", result);
        if (![result isEqualToString:@"N"]) {
            [CoreDataUtil deleteModel:MANAGED_OBJECT_CONTEXT modelName:@"ProductOrder"];
            NSArray *entities = [EntityUtil parseJsonObjectStrToEntityArray:result];
            for (int i = 0; i < entities.count; i++) {
                ProductOrder *productOrder = (ProductOrder *)[CoreDataUtil createData:MANAGED_OBJECT_CONTEXT modelName:@"ProductOrder"];
                NSDictionary *entity = [EntityUtil parseJsonObjectStrToDic:entities[i]];
                [EntityUtil reflectDataFromOtherObject4Entity:productOrder
                                                     withData:entity];
            }
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"ProductOrderSync请求出错");
        [ViewBuilder autoDismissAlertViewWithTitle:@"连接到服务器错误,同步失败!" afterDelay:1.5f];
    }];
    [engine enqueueOperation:operation];
}

@end
