//
//  CoreDataUtil.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-1.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataUtil : NSObject

+ (NSEntityDescription *)createData:(NSManagedObjectContext *)context modelName:(NSString *)name;

+ (NSArray *)retrieveData:(NSManagedObjectContext *)context modelName:(NSString *)name withPredicate:(NSPredicate *)predicate;

+ (void)deleteData:(NSManagedObjectContext *)context modelName:(NSString *)name withPredicate:(NSPredicate *)predicate;

+ (void)deleteModel:(NSManagedObjectContext *)context modelName:(NSString *)name;

@end
