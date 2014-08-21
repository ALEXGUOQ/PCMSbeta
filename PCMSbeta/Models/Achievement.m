//
//  Achievement.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-1.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "Achievement.h"


@implementation Achievement

@dynamic achievementId;
@dynamic createDateTime;
@dynamic endDate;
@dynamic isDelete;
@dynamic lastOperatorId;
@dynamic managerId;
@dynamic rate;
@dynamic remark;
@dynamic startDate;
@dynamic target;
@dynamic total;
@dynamic updateDateTime;
@dynamic userId;
/**
 *  获得查询结果
 *
 *  @param predicate 条件
 *
 *  @return NSFetchedResultsController
 */
+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate {
    return [EntityUtil fetchedResultsControllerWithEntityName:@"Achievement" sortProperty:@"createDateTime" predicate:predicate];
}

@end
