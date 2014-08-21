//
//  Product.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-15.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "Product.h"


@implementation Product

@dynamic productId;
@dynamic productName;
@dynamic remark;
@dynamic manufacturer;
@dynamic shortName;
@dynamic standard;
@dynamic companyId;
/**
 *  获得查询结果
 *
 *  @param predicate 条件
 *
 *  @return NSFetchedResultsController
 */
+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate {
    return [EntityUtil fetchedResultsControllerWithEntityName:@"Product" sortProperty:@"productName" predicate:predicate];
}

@end
