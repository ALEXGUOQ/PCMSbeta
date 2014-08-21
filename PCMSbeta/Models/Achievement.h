//
//  Achievement.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-1.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 *  # 业绩模型
 */
@interface Achievement : NSManagedObject
/**
 *  业绩Id
 */
@property (nonatomic, retain) NSString * achievementId;
/**
 *  创建时间
 */
@property (nonatomic, retain) NSString * createDateTime;
/**
 *  结束日期
 */
@property (nonatomic, retain) NSString * endDate;
/**
 *  是否已删除
 */
@property (nonatomic, retain) NSString * isDelete;
/**
 *  最后操作员id
 */
@property (nonatomic, retain) NSString * lastOperatorId;
/**
 *  管理者(上级)Id
 */
@property (nonatomic, retain) NSString * managerId;
/**
 *  完成比率
 */
@property (nonatomic, retain) NSString * rate;
/**
 *  备注
 */
@property (nonatomic, retain) NSString * remark;
/**
 *  开始日期
 */
@property (nonatomic, retain) NSString * startDate;
/**
 *  目标金额
 */
@property (nonatomic, retain) NSString * target;
/**
 *  完成金额
 */
@property (nonatomic, retain) NSString * total;
/**
 *  更新日期
 */
@property (nonatomic, retain) NSString * updateDateTime;
/**
 *  用户Id
 */
@property (nonatomic, retain) NSString * userId;

+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate;

@end
