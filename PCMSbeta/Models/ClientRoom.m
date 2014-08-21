//
//  ClientRoom.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-1.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "ClientRoom.h"


@implementation ClientRoom

@dynamic age;
@dynamic clientId;
@dynamic createDateTime;
@dynamic income;
@dynamic isDelete;
@dynamic lastOperatorId;
@dynamic remark;
@dynamic roomId;
@dynamic roomName;
@dynamic sex;
@dynamic updateDateTime;
@dynamic userId;
@dynamic zhuRenName;
/**
 *  获得查询结果
 *
 *  @param predicate 条件
 *
 *  @return NSFetchedResultsController
 */
+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate {
    return [EntityUtil fetchedResultsControllerWithEntityName:@"ClientRoom" sortProperty:@"updateDateTime" predicate:predicate];
}

@end
