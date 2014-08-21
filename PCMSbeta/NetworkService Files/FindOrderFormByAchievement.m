//
//  FindOrderFormByAchievement.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-12.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "FindOrderFormByAchievement.h"
/**
 *  # 根据一条业绩记录从服务器查询订单数据
 */
@implementation FindOrderFormByAchievement

+ (void)startFindByAchievement:(Achievement *)achievement {
    NSString *post = [EntityUtil parseEntityToJsonObjectStr:achievement];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"findByAchievement" forKey:@"method"];
    [params setValue:post forKey:@"data"];
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:HOST_IP
                                                                apiPath:ORDERFORM_PATH
                                                     customHeaderFields:nil];
    MKNetworkOperation *operation = [engine operationWithPath:nil params:params httpMethod:@"POST"];
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSString *result = [completedOperation responseString];
        NSLog(@"返回------------------------OrderForm------------------------数据：\n%@", result);
        if (![result isEqualToString:@"N"]) {
            [CoreDataUtil deleteModel:MANAGED_OBJECT_CONTEXT modelName:@"OrderForm"];
            NSArray *entities = [EntityUtil parseJsonObjectStrToEntityArray:result];
            for (int i = 0; i < entities.count; i++) {
                OrderForm *orderForm = (OrderForm *)[CoreDataUtil createData:MANAGED_OBJECT_CONTEXT modelName:@"OrderForm"];
                NSDictionary *entity = [EntityUtil parseJsonObjectStrToDic:entities[i]];
                [EntityUtil reflectDataFromOtherObject4Entity:orderForm withData:entity];
            }
        }else{
            [ViewBuilder autoDismissAlertViewWithTitle:@"暂无订单数据" afterDelay:1.5f];
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"FindOrderFormByAchievement请求出错");
        [ViewBuilder autoDismissAlertViewWithTitle:@"连接到服务器错误!" afterDelay:1.5f];
    }];
    [engine enqueueOperation:operation];
}

@end
