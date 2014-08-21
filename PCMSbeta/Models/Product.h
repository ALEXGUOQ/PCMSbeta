//
//  Product.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-15.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
/**
 *  # 产品模型
 */
@interface Product : NSManagedObject
/**
 *  产品Id
 */
@property (nonatomic, retain) NSString * productId;
/**
 *  产品名称
 */
@property (nonatomic, retain) NSString * productName;
/**
 *  备注
 */
@property (nonatomic, retain) NSString * remark;
/**
 *  厂商
 */
@property (nonatomic, retain) NSString * manufacturer;
/**
 *  短名称
 */
@property (nonatomic, retain) NSString * shortName;
/**
 *  规格
 */
@property (nonatomic, retain) NSString * standard;
/**
 *  公司Id
 */
@property (nonatomic, retain) NSString * companyId;

+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate;

@end
