//
//  CoreDataUtil.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-1.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "CoreDataUtil.h"
/**
 *  # 操作CoreData的工具类
 */
@implementation CoreDataUtil

/**
 *  新增一条数据,返回该实体描述
 *
 *  @param context NSManagedObjectContext
 *  @param name    NSString
 *
 *  @return NSEntityDescription
 */
+ (id)createData:(NSManagedObjectContext *)context modelName:(NSString *)name{
    NSError *error = nil;
    id de = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:context];
    if (![context save:&error]) {
        NSLog(@"sorry %@", [error localizedDescription]);
    }
    NSLog(@"insert obj++++++++++++++++++++++++++++++++ %@",name);
    return de;
    
}
/**
 *  查询数据,返回符合谓词条件的实体数组
 *
 *  @param context   NSManagedObjectContext
 *  @param name      modelName
 *  @param predicate NSPredicate
 *
 *  @return NSArray
 */
+ (NSArray *)retrieveData:(NSManagedObjectContext *)context modelName:(NSString *)name withPredicate:(NSPredicate *)predicate{
    
    NSError *error = nil;
    NSFetchRequest *request = [self fetchRequestReady:context modelName:name withPredicate:predicate];
    NSArray *results = [context executeFetchRequest:request error:&error];
    return results;
}
/**
 *  删除一条实体记录
 *
 *  @param context   NSManagedObjectContext
 *  @param name      modelName
 *  @param predicate NSPredicate
 */
+ (void)deleteData:(NSManagedObjectContext *)context modelName:(NSString *)name withPredicate:(NSPredicate *)predicate{
    NSArray *results = [self retrieveData:context modelName:name withPredicate:predicate];
    if (results.count > 0) {
        [context deleteObject:[results objectAtIndex:0]];
        
    }
}
/**
 *  删除实体模型的所有记录
 *
 *  @param context NSManagedObjectContext
 *  @param name    modelName
 */
+ (void)deleteModel:(NSManagedObjectContext *)context modelName:(NSString *)name{
    NSArray *results = [self retrieveData:context modelName:name withPredicate:nil];
    if (results.count > 0) {
        for (int i = 0; i<results.count; i++) {
            [context deleteObject:[results objectAtIndex:i]];
            NSLog(@"delete obj---------------------------------- %@[%d]",name,i);
        }
    }
}
+ (NSFetchRequest *)fetchRequestReady:(NSManagedObjectContext *)context modelName:(NSString *)name withPredicate:(NSPredicate *)predicate{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:name inManagedObjectContext:context]];
    if (predicate) {
        [request setPredicate:predicate];
    }
    return request;
}

@end
