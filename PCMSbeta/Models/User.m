//
//  User.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-1.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "User.h"


@implementation User

@dynamic birthday;
@dynamic companyId;
@dynamic createDateTime;
@dynamic email;
@dynamic entryDate;
@dynamic isJob;
@dynamic lastOperatorId;
@dynamic organId;
@dynamic password;
@dynamic phoneOne;
@dynamic phoneThree;
@dynamic phoneTwo;
@dynamic remark;
@dynamic remarkOne;
@dynamic remarkThree;
@dynamic remarkTwo;
@dynamic score;
@dynamic sex;
@dynamic updateDateTime;
@dynamic userId;
@dynamic userName;
/**
 *  获得查询结果
 *
 *  @param predicate 条件
 *
 *  @return NSFetchedResultsController
 */
+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate {
    return [EntityUtil fetchedResultsControllerWithEntityName:@"User" sortProperty:@"userName" predicate:predicate];
}

@end
