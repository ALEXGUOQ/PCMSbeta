//
//  EntityUtil.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-1.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "EntityUtil.h"
#import <objc/runtime.h>
@implementation EntityUtil
/**
 *  将JsonObjectString转换为模型实体数组
 *
 *  @param jsonStr <#jsonStr description#>
 *
 *  @return NSArray
 */
+ (NSArray *)parseJsonObjectStrToEntityArray:(NSString *)jsonStr {
    return [jsonStr componentsSeparatedByString:@"<dh-d>"];
}
/**
 *  将模型实体数组转换为JsonObjectString
 *
 *  @param entityArray <#entityArray description#>
 *
 *  @return NSString
 */
+ (NSString *)parseEntityArrayToJsonObjectStr:(id)entityArray {
    NSMutableString *jsonObjectStr = [[NSMutableString alloc] init];
    if ([entityArray isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < ((NSArray *)entityArray).count; i++) {
            NSString *entityStr = [self parseEntityToJsonObjectStr:entityArray[i]];
            if (entityStr) {
                [jsonObjectStr
                 appendString:[NSString stringWithFormat:@"%@<dh-d>", entityStr]];
            }
        }
    } else {
        [jsonObjectStr appendString:@"N"];
    }
    
    return jsonObjectStr;
}
/**
 *  将JsonObjectString转换为模型实体字典
 *
 *  @param jsonStr <#jsonStr description#>
 *
 *  @return NSDictionary
 */
+ (NSDictionary *)parseJsonObjectStrToDic:(NSString *)jsonStr {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    NSArray *arrs = [jsonStr componentsSeparatedByString:@"<dh-x>"];
    for (int i = 0; i < arrs.count; i++) {
        NSArray *arr = [arrs[i] componentsSeparatedByString:@"<mh>"];
        NSString *key = [arr firstObject];
        NSString *value = [arr lastObject];
        if ([key isEqualToString:@"id"]) {
            key = @"companyId";
        }
        if ([key isEqualToString:@"description"]) {
            key = @"deScription";
        }
        [dic setValue:value forKey:key];
    }
    
    return dic;
}
/**
 *  将一个实体转换为JsonObjectString
 *
 *  @param entity 实体
 *
 *  @return NSString
 */
+ (NSString *)parseEntityToJsonObjectStr:(id)entity {
    if (entity != nil) {
        unsigned int outCount, i;
        objc_property_t *properties =
        class_copyPropertyList([entity class], &outCount);
        NSMutableString *jsonObjectStr = [[NSMutableString alloc] init];
        for (i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            
            NSString *propertyName =
            [[NSString alloc] initWithCString:property_getName(property)
                                     encoding:NSUTF8StringEncoding];
            
            SEL selector = NSSelectorFromString(propertyName);
            id propertyValue;
            if ([entity respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                if ([propertyName
                     isEqualToString:
                     @"password"]) { //存到本地数据库的密码字段没有被md5加密,在此处对其用md5加密
                    propertyValue =
                    [StringUtil getMd5String:[entity performSelector:selector]];
                } else {
                    propertyValue = [entity performSelector:selector];
                }
#pragma clang diagnostic pop
            }
            if (propertyValue != nil) {
                if ([propertyValue isKindOfClass:[NSNumber class]]) {
                    propertyValue = [propertyValue stringValue];
                }
                if (![[propertyValue
                       stringByTrimmingCharactersInSet:
                       [NSCharacterSet whitespaceAndNewlineCharacterSet]]
                      isEqualToString:@""]) {
                    [jsonObjectStr
                     appendString:[NSString stringWithFormat:@"%@<mh>%@<dh-x>",
                                   propertyName,
                                   propertyValue]];
                }
            }
        }
        free(properties);
        if (![jsonObjectStr isEqualToString:@""])
            return [jsonObjectStr substringToIndex:jsonObjectStr.length - 6];
    }
    
    return nil;
}
/**
 *  实体查询结果
 *
 *  @param name      模型名
 *  @param sortStr   排序名
 *  @param predicate 条件
 *
 *  @return NSFetchedResultsController
 */
+ (NSFetchedResultsController *)fetchedResultsControllerWithEntityName:(NSString *)name sortProperty:(NSString *)sortStr predicate:(NSPredicate *)predicate {
    //创建一个查询请求
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //查询条件
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:MANAGED_OBJECT_CONTEXT];
    [fetchRequest setEntity:entity];
    //查询排序，必须的
    if (![sortStr isEqualToString:@""]) {
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:sortStr
                                                         ascending:NO];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    }
    //设置查询的个数
    [fetchRequest setFetchBatchSize:20];
    if (predicate) {
        [fetchRequest setPredicate:predicate];
    }
    //创建一个赋给全局的，然后就可以自动运作了
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:MANAGED_OBJECT_CONTEXT sectionNameKeyPath:nil
                                                   cacheName:nil];
    
    return theFetchedResultsController;
}
/**
 *  对一个实体进行赋值
 *
 *  @param entity     实体
 *  @param dataSource NSDictionary
 *
 *  @return BOOL
 */
+ (BOOL)reflectDataFromOtherObject4Entity:(id)entity withData:(NSObject *)dataSource {
    BOOL ret = NO;
    for (NSString *key in [self propertyKeys4Entity:entity]) {
        if ([dataSource isKindOfClass:[NSDictionary class]]) {
            ret = ([dataSource valueForKey:key]==nil)?NO:YES;
        }
        else
        {
            ret = [dataSource respondsToSelector:NSSelectorFromString(key)];
        }
        if (ret) {
            id propertyValue = [dataSource valueForKey:key];
            //该值不为NSNULL，并且也不为nil
            if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue!=nil) {
                [entity setValue:propertyValue forKey:key];
            }
        }
    }
    return ret;
}
/**
 *  获取一个实体的属性数组
 *
 *  @param entity 实体
 *
 *  @return NSArray
 */
+ (NSArray *)propertyKeys4Entity:(id)entity {
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([entity class], &outCount);
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        //        property_copyAttributeValue(property, [propertyName cStringUsingEncoding:kCFStringEncodingUTF8]);
        [keys addObject:propertyName];
    }
    free(properties);
    return keys;
}


@end
