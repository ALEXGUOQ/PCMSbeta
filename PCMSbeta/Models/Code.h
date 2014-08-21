//
//  Code.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-1.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 *  # 编码模型
 */
@interface Code : NSManagedObject
/**
 *  编码Id
 */
@property (nonatomic, retain) NSString * codeId;
/**
 *  编码名称
 */
@property (nonatomic, retain) NSString * codeName;
/**
 *  编码类型Id
 */
@property (nonatomic, retain) NSString * codeTypeId;
/**
 *  创建时间
 */
@property (nonatomic, retain) NSString * createDateTime;
/**
 *  最后操作员Id
 */
@property (nonatomic, retain) NSString * lastOperatorId;
/**
 *  更新时间
 */
@property (nonatomic, retain) NSString * updateDateTime;

+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate;

@end
