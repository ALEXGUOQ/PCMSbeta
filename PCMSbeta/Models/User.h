//
//  User.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-1.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 *  # 用户模型
 */
@interface User : NSManagedObject
/**
 *  生日
 */
@property (nonatomic, retain) NSString * birthday;
/**
 *  公司Id
 */
@property (nonatomic, retain) NSString * companyId;
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
 *  是否在职
 */
@property (nonatomic, retain) NSString * isJob;
/**
 *  最后操作员Id
 */
@property (nonatomic, retain) NSString * lastOperatorId;
/**
 *  机构(部门)Id
 */
@property (nonatomic, retain) NSString * organId;
/**
 *  密码
 */
@property (nonatomic, retain) NSString * password;
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
 *  电话备注1
 */
@property (nonatomic, retain) NSString * remarkOne;
/**
 *  电话备注3
 */
@property (nonatomic, retain) NSString * remarkThree;
/**
 *  电话备注2
 */
@property (nonatomic, retain) NSString * remarkTwo;
/**
 *  评分
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
 *  用户Id
 */
@property (nonatomic, retain) NSString * userId;
/**
 *  用户名
 */
@property (nonatomic, retain) NSString * userName;

+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate;

@end
