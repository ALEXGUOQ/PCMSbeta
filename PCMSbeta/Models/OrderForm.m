//
//  OrderForm.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-1.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "OrderForm.h"


@implementation OrderForm

@dynamic companyName;
@dynamic createDateTime;
@dynamic date;
@dynamic deScription;
@dynamic formId;
@dynamic isDelete;
@dynamic lastOperatorId;
@dynamic money;
@dynamic remark;
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
    return [EntityUtil fetchedResultsControllerWithEntityName:@"OrderForm" sortProperty:@"updateDateTime" predicate:predicate];
}

@end
