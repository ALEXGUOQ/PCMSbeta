//
//  FindCompany.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-12.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "FindCompany.h"
/**
 *  # 访问服务器获得公司数据,保存到本地
 */
@implementation FindCompany

+ (void)start {
    NSString *path = [NSString stringWithFormat:@"sale-manage/CompanyServlet"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"findAllToCode" forKey:@"method"];
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:HOST_IP apiPath:path customHeaderFields:nil];
    MKNetworkOperation *operation = [engine operationWithPath:nil params:params httpMethod:@"POST"];
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSString *result = [completedOperation responseString];
        NSLog(@"返回------------------------Company------------------------数据：\n%@", result);
        if (![result isEqualToString:@"N"]) {
            [CoreDataUtil deleteModel:MANAGED_OBJECT_CONTEXT modelName:@"Company"];
            NSArray *entities = [EntityUtil parseJsonObjectStrToEntityArray:result];
            for (int i = 0; i < entities.count; i++) {
                NSDictionary *entity = [EntityUtil parseJsonObjectStrToDic:entities[i]];
                Company *company = (Company *)[CoreDataUtil createData:MANAGED_OBJECT_CONTEXT modelName:@"Company"];
                [EntityUtil reflectDataFromOtherObject4Entity:company
                                                     withData:entity];
            }
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"FindCompany请求出错");
    }];
    [engine enqueueOperation:operation];
}

@end
