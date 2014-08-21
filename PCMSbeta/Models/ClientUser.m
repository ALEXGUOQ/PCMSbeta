//
//  ClientUser.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-1.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "ClientUser.h"


@implementation ClientUser

@dynamic age;
@dynamic birthday;
@dynamic clientId;
@dynamic clientUserId;
@dynamic clientUserName;
@dynamic createDateTime;
@dynamic email;
@dynamic entryDate;
@dynamic isDelete;
@dynamic job;
@dynamic lastOperatorId;
@dynamic phoneOne;
@dynamic phoneThree;
@dynamic phoneTwo;
@dynamic remark;
@dynamic remarkOne;
@dynamic remarkThree;
@dynamic remarkTwo;
@dynamic score;
@dynamic sex;
@dynamic skilled;
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
    return [EntityUtil fetchedResultsControllerWithEntityName:@"ClientUser" sortProperty:@"updateDateTime" predicate:predicate];
}

@end
