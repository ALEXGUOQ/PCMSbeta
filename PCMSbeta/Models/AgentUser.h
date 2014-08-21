//
//  AgentUser.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-1.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 *  # 代理商联系人模型
 */
@interface AgentUser : NSManagedObject
/**
 *  年龄
 */
@property (nonatomic, retain) NSString * age;
/**
 *  代理商Id
 */
@property (nonatomic, retain) NSString * agentId;
/**
 *  代理商联系人Id
 */
@property (nonatomic, retain) NSString * agentUserId;
/**
 *  代理商联系人名称
 */
@property (nonatomic, retain) NSString * agentUserName;
/**
 *  生日
 */
@property (nonatomic, retain) NSString * birthday;
/**
 *  创建时间
 */
@property (nonatomic, retain) NSString * createDateTime;
/**
 *  邮箱
 */
@property (nonatomic, retain) NSString * email;
/**
 *  入职日期
 */
@property (nonatomic, retain) NSString * entryDate;
/**
 *  是否已删除
 */
@property (nonatomic, retain) NSString * isDelete;
/**
 *  职务
 */
@property (nonatomic, retain) NSString * job;
/**
 *  最后操作员Id
 */
@property (nonatomic, retain) NSString * lastOperatorId;
/**
 *  电话1
 */
@property (nonatomic, retain) NSString * phoneOne;
/**
 *  电话3
 */
@property (nonatomic, retain) NSString * phoneThree;
/**
 *  电话2
 */
@property (nonatomic, retain) NSString * phoneTwo;
/**
 *  备注
 */
@property (nonatomic, retain) NSString * remark;
/**
 *  备注1
 */
@property (nonatomic, retain) NSString * remarkOne;
/**
 *  备注3
 */
@property (nonatomic, retain) NSString * remarkThree;
/**
 *  备注2
 */
@property (nonatomic, retain) NSString * remarkTwo;
/**
 *  评价
 */
@property (nonatomic, retain) NSString * score;
/**
 *  性别
 */
@property (nonatomic, retain) NSString * sex;
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
