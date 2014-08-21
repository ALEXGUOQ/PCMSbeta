//
//  ClientRoomDevice.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-1.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "ClientRoomDevice.h"


@implementation ClientRoomDevice

@dynamic brand;
@dynamic buyDate;
@dynamic count;
@dynamic createDateTime;
@dynamic dayCheckCount;
@dynamic deviceId;
@dynamic isDelete;
@dynamic lastOperatorId;
@dynamic roomId;
@dynamic remark;
@dynamic saleCompanyName;
@dynamic type;
@dynamic updateDateTime;
@dynamic userId;
@dynamic useState;
@dynamic version;
/**
 *  获得查询结果
 *
 *  @param predicate 条件
 *
 *  @return NSFetchedResultsController
 */
+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate {
    return [EntityUtil fetchedResultsControllerWithEntityName:@"ClientRoomDevice" sortProperty:@"updateDateTime" predicate:predicate];
}

@end
