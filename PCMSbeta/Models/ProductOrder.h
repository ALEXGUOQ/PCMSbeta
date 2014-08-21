//
//  ProductOrder.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-15.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 *  # 产品订单模型
 */
@interface ProductOrder : NSManagedObject
/**
 *  产品订单Id
 */
@property (nonatomic, retain) NSString * productOrderId;
/**
 *  外键,医院Id
 */
@property (nonatomic, retain) NSString * foreignkey;
/**
 *  日期
 */
@property (nonatomic, retain) NSString * date;
/**
 *  用户Id
 */
@property (nonatomic, retain) NSString * userId;
/**
 *  订单信息(格式为@"productId,,count;;productId,,count"拼接字符串)
 */
@property (nonatomic, retain) NSString * orderInfo;
/**
 *  是否已删除
 */
@property (nonatomic, retain) NSString * isDelete;
/**
 *  更新时间
 */
@property (nonatomic, retain) NSString * updateDateTime;

+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate;

@end
