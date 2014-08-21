//
//  Company.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-1.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 *  # 公司模型
 */
@interface Company : NSManagedObject
/**
 *  公司Id
 */
@property (nonatomic, retain) NSString * companyId;
/**
 *  公司名称
 */
@property (nonatomic, retain) NSString * name;

+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate;

@end
