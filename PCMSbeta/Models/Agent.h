//
//  Agent.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-1.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 *  # 代理商模型
 */
@interface Agent : NSManagedObject
/**
 *  具体地址(街道)
 */
@property (nonatomic, retain) NSString * address;
/**
 *  代理商Id
 */
@property (nonatomic, retain) NSString * agentId;
/**
 *  代理商名称
 */
@property (nonatomic, retain) NSString * agentName;
/**
 *  业务类型
 */
@property (nonatomic, retain) NSString * businessType;
/**
 *  城市编号
 */
@property (nonatomic, retain) NSString * cityId;
/**
 *  客户群
 */
@property (nonatomic, retain) NSString * clientGroup;
/**
 *  数量
 */
@property (nonatomic, retain) NSString * count;
/**
 *  创建时间
 */
@property (nonatomic, retain) NSString * createDateTime;
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
@property (nonatomic, retain) NSString * proviceId;
/**
 *  注册资本
 */
@property (nonatomic, retain) NSString * registerCapital;
/**
 *  备注
 */
@property (nonatomic, retain) NSString * remark;
/**
 *  评价
 */
@property (nonatomic, retain) NSString * score;
/**
 *  更新时间
 */
@property (nonatomic, retain) NSString * updateDateTime;
/**
 *  用户名
 */
@property (nonatomic, retain) NSString * userId;

+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate;

@end
