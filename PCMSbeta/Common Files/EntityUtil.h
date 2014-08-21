//
//  EntityUtil.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-1.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  # 模型转换字符串,模型赋值,建立模型查询
 */
@interface EntityUtil : NSObject

+ (NSArray *)parseJsonObjectStrToEntityArray:(NSString *)jsonStr;

+ (NSString *)parseEntityArrayToJsonObjectStr:(NSArray *)entityArray;

+ (NSDictionary *)parseJsonObjectStrToDic:(NSString *)jsonStr;

+ (NSString *)parseEntityToJsonObjectStr:(id)entity;

+ (NSFetchedResultsController *)fetchedResultsControllerWithEntityName:(NSString *)name sortProperty:(NSString *)sortStr predicate:(NSPredicate *)predicate;

+ (BOOL)reflectDataFromOtherObject4Entity:(id)entity withData:(NSObject*)dataSource;

@end
