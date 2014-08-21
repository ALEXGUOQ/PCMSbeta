//
//  ProductOrder.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-15.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "ProductOrder.h"


@implementation ProductOrder

@dynamic productOrderId;
@dynamic foreignkey;
@dynamic date;
@dynamic userId;
@dynamic orderInfo;
@dynamic isDelete;
@dynamic updateDateTime;
/**
 *  获得查询结果
 *
 *  @param predicate 条件
 *
 *  @return NSFetchedResultsController
 */
+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate {
    return [EntityUtil fetchedResultsControllerWithEntityName:@"ProductOrder" sortProperty:@"updateDateTime" predicate:predicate];
}

@end
