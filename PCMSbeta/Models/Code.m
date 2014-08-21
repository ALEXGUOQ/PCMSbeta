//
//  Code.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-1.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "Code.h"


@implementation Code

@dynamic codeId;
@dynamic codeName;
@dynamic codeTypeId;
@dynamic createDateTime;
@dynamic lastOperatorId;
@dynamic updateDateTime;
/**
 *  获得查询结果
 *
 *  @param predicate 条件
 *
 *  @return NSFetchedResultsController
 */
+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate {
    return [EntityUtil fetchedResultsControllerWithEntityName:@"Code" sortProperty:@"codeId" predicate:predicate];
}

@end
