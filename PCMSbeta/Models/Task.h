//
//  Task.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-1.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 *  # 任务模型
 */
@interface Task : NSManagedObject
/**
 *  城市编号
 */
@property (nonatomic, retain) NSString * cityId;
/**
 *  拜访单位Id
 */
@property (nonatomic, retain) NSString * clientId;
/**
 *  任务内容
 */
@property (nonatomic, retain) NSString * content;
/**
 *  创建时间
 */
@property (nonatomic, retain) NSString * createDateTime;
/**
 *  止签到地点
 */
@property (nonatomic, retain) NSString * endAddress;
/**
 *  止签到时间
 */
@property (nonatomic, retain) NSString * endDateTime;
/**
 *  是否已删除
 */
@property (nonatomic, retain) NSString * isDelete;
/**
 *  最后操作员Id
 */
@property (nonatomic, retain) NSString * lastOperatorId;
/**
 *  省编号
 */
@property (nonatomic, retain) NSString * provinceId;
/**
 *  备注
 */
@property (nonatomic, retain) NSString * remark;
/**
 *  评价
 */
@property (nonatomic, retain) NSString * score;
/**
 *  起签到地点
 */
@property (nonatomic, retain) NSString * startAddress;
/**
 *  起签到时间
 */
@property (nonatomic, retain) NSString * startDateTime;
/**
 *  任务名称
 */
@property (nonatomic, retain) NSString * task;
/**
 *  任务Id
 */
@property (nonatomic, retain) NSString * taskId;
/**
 *  更新时间
 */
@property (nonatomic, retain) NSString * updateDateTime;
/**
 *  用户Id
 */
@property (nonatomic, retain) NSString * userId;
/**
 *  任务日期
 */
@property (nonatomic, retain) NSString * workDate;

+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate;

@end
