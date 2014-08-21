//
//  ClientRoom.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-1.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 *  # 科室模型
 */
@interface ClientRoom : NSManagedObject
/**
 *  年龄
 */
@property (nonatomic, retain) NSString * age;
/**
 *  医院Id
 */
@property (nonatomic, retain) NSString * clientId;
/**
 *  创建时间
 */
@property (nonatomic, retain) NSString * createDateTime;
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
 *  备注
 */
@property (nonatomic, retain) NSString * remark;
/**
 *  科室Id
 */
@property (nonatomic, retain) NSString * roomId;
/**
 *  科室名称
 */
@property (nonatomic, retain) NSString * roomName;
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
/**
 *  主任姓名
 */
@property (nonatomic, retain) NSString * zhuRenName;

+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate;

@end
