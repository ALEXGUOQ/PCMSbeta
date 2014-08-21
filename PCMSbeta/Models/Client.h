//
//  Client.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-1.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 *  # 医院模型
 */
@interface Client : NSManagedObject
/**
 *  具体地址(街道)
 */
@property (nonatomic, retain) NSString * address;
/**
 *  床位数
 */
@property (nonatomic, retain) NSString * bedCount;
/**
 *  城市编号
 */
@property (nonatomic, retain) NSString * cityId;
/**
 *  客户群
 */
@property (nonatomic, retain) NSString * clientGroup;
/**
 *  医院Id
 */
@property (nonatomic, retain) NSString * clientId;
/**
 *  医院名称
 */
@property (nonatomic, retain) NSString * clientName;
/**
 *  创建时间
 */
@property (nonatomic, retain) NSString * createDateTime;
/**
 *  日检查量
 */
@property (nonatomic, retain) NSString * dayCount;
/**
 *  财务状况
 */
@property (nonatomic, retain) NSString * finance;
/**
 *  年收入
 */
@property (nonatomic, retain) NSString * income;
/**
 *  是否已删除
 */
@property (nonatomic, retain) NSString * isDelete;
/**
 *  最后操作员Id
 */
@property (nonatomic, retain) NSString * lastOperatorId;
/**
 *  医院等级
 */
@property (nonatomic, retain) NSString * levelRate;
/**
 *  省编号
 */
@property (nonatomic, retain) NSString * provinceId;
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
 *  特色科室
 */
@property (nonatomic, retain) NSString * teSeKeShi;
/**
 *  营业额
 */
@property (nonatomic, retain) NSString * turnover;
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
