//
//  Agent.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-1.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "Agent.h"


@implementation Agent

@dynamic address;
@dynamic agentId;
@dynamic agentName;
@dynamic businessType;
@dynamic cityId;
@dynamic clientGroup;
@dynamic count;
@dynamic createDateTime;
@dynamic isDelete;
@dynamic lastOperatorId;
@dynamic proviceId;
@dynamic registerCapital;
@dynamic remark;
@dynamic score;
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
    return [EntityUtil fetchedResultsControllerWithEntityName:@"Agent" sortProperty:@"updateDateTime" predicate:predicate];
}

@end
