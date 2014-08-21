//
//  Task.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-1.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "Task.h"


@implementation Task

@dynamic cityId;
@dynamic clientId;
@dynamic content;
@dynamic createDateTime;
@dynamic endAddress;
@dynamic endDateTime;
@dynamic isDelete;
@dynamic lastOperatorId;
@dynamic provinceId;
@dynamic remark;
@dynamic score;
@dynamic startAddress;
@dynamic startDateTime;
@dynamic task;
@dynamic taskId;
@dynamic updateDateTime;
@dynamic userId;
@dynamic workDate;
/**
 *  获得查询结果
 *
 *  @param predicate 条件
 *
 *  @return NSFetchedResultsController
 */
+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate {
    return [EntityUtil fetchedResultsControllerWithEntityName:@"Task" sortProperty:@"updateDateTime" predicate:predicate];
}

@end
