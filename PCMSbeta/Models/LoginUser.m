//
//  LoginUser.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-1.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "LoginUser.h"


@implementation LoginUser

@dynamic birthday;
@dynamic companyId;
@dynamic createDateTime;
@dynamic email;
@dynamic entryDate;
@dynamic isJob;
@dynamic lastOperatorId;
@dynamic menuIds;
@dynamic organId;
@dynamic password;
@dynamic phoneOne;
@dynamic phoneThree;
@dynamic phoneTwo;
@dynamic remarkOne;
@dynamic remarkThree;
@dynamic remarkTwo;
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
    return [EntityUtil fetchedResultsControllerWithEntityName:@"LoginUser" sortProperty:@"createDateTime" predicate:predicate];
}

@end
