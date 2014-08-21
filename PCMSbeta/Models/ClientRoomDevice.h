//
//  ClientRoomDevice.h
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
@interface ClientRoomDevice : NSManagedObject
/**
 *  品牌
 */
@property (nonatomic, retain) NSString * brand;
/**
 *  购买日期
 */
@property (nonatomic, retain) NSString * buyDate;
/**
 *  数量
 */
@property (nonatomic, retain) NSString * count;
/**
 *  创建时间
 */
@property (nonatomic, retain) NSString * createDateTime;
/**
 *  日检查量
 */
@property (nonatomic, retain) NSString * dayCheckCount;
/**
 *  设备Id
 */
@property (nonatomic, retain) NSString * deviceId;
/**
 *  是否已删除
 */
@property (nonatomic, retain) NSString * isDelete;
/**
 *  最后操作员id
 */
@property (nonatomic, retain) NSString * lastOperatorId;
/**
 *  科室Id
 */
@property (nonatomic, retain) NSString * roomId;
/**
 *  备注
 */
@property (nonatomic, retain) NSString * remark;
/**
 *  卖方公司名称
 */
@property (nonatomic, retain) NSString * saleCompanyName;
/**
 *  类型
 */
@property (nonatomic, retain) NSString * type;
/**
 *  更新时间
 */
@property (nonatomic, retain) NSString * updateDateTime;
/**
 *  用户Id
 */
@property (nonatomic, retain) NSString * userId;
/**
 *  使用状况
 */
@property (nonatomic, retain) NSString * useState;
/**
 *  型号
 */
@property (nonatomic, retain) NSString * version;

+ (NSFetchedResultsController *)fetchedResultsControllerWithPredicate:(NSPredicate *)predicate;

@end
