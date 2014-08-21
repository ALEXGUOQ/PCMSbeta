//
//  FindCode.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-12.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "FindCode.h"
/**
 *  # 访问服务器获得Code数据保存到本地数据库
 */
@implementation FindCode

+ (void)start {
    NSString *table = @"t_p_code";
    NSString *companyId = @"N";
    NSString *userId = @"N";
    NSString *menuIds = @"N";
    NSString *path = [NSString stringWithFormat:@"sale-manage/StepServlet"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:table forKey:@"table"];
    [params setValue:companyId forKey:@"companyId"];
    [params setValue:userId forKey:@"userId"];
    [params setValue:menuIds forKey:@"menuIds"];
    [params setValue:@"N" forKey:@"data"];
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:HOST_IP apiPath:path customHeaderFields:nil];
    MKNetworkOperation *operation = [engine operationWithPath:nil params:params httpMethod:@"POST"];
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSString *result = [completedOperation responseString];
        NSLog(@"返回------------------------Code------------------------数据：\n%@", result);
        if (![result isEqualToString:@"N"]) {
            [CoreDataUtil deleteModel:MANAGED_OBJECT_CONTEXT modelName:@"Code"];
            NSArray *entities = [EntityUtil parseJsonObjectStrToEntityArray:result];
            for (int i = 0; i < entities.count; i++) {
                Agent *agent = (Agent *)[CoreDataUtil createData:MANAGED_OBJECT_CONTEXT modelName:@"Code"];
                NSDictionary *entity = [EntityUtil parseJsonObjectStrToDic:entities[i]];
                [EntityUtil reflectDataFromOtherObject4Entity:agent withData:entity];
            }
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"FindCode请求出错");
    }];
    [engine enqueueOperation:operation];
}

@end
