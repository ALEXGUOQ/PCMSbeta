//
//  OrderForm.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-1.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 *  # 订单模型
 */
@interface OrderForm : NSManagedObject
/**
 *  公司名称
 */
@property (nonatomic, retain) NSString * companyName;
/**
 *  创建时间
 */
@property (nonatomic, retain) NSString * createDateTime;
/**
 *  日期
 */
@property (nonatomic, retain) NSString * date;
/**
 *  订单描述
 */
@property (nonatomic, retain) NSString * deScription;
/**
 *  订单Id
 */
@property (nonatomic, retain) NSString * formId;
/**
 *  是否已删除
 */
@property (nonatomic, retain) NSString * isDelete;
/**
 *  最后操作员Id
 */
@property (nonatomic, retain) NSString * lastOperatorId;
/**
 *  金额
 */
@property (nonatomic, retain) NSString * money;
/**
 *  备注
 */
@property (nonatomic, retain) NSString * remark;
/**
 *  更新时间
 */
@property (nonatomic, retain) NSString * updateDateTime;
/**
 *  用户Id
 */
@property (nonatomic, retain) NSString * userId;

+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate;

@end
