//
//  Client.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-1.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "Client.h"


@implementation Client

@dynamic address;
@dynamic bedCount;
@dynamic cityId;
@dynamic clientGroup;
@dynamic clientId;
@dynamic clientName;
@dynamic createDateTime;
@dynamic dayCount;
@dynamic finance;
@dynamic income;
@dynamic isDelete;
@dynamic lastOperatorId;
@dynamic levelRate;
@dynamic provinceId;
@dynamic registerCapital;
@dynamic remark;
@dynamic score;
@dynamic teSeKeShi;
@dynamic turnover;
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
    return [EntityUtil fetchedResultsControllerWithEntityName:@"Client" sortProperty:@"updateDateTime" predicate:predicate];
}

@end
