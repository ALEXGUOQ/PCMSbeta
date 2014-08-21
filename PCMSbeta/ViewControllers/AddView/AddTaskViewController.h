//
//  AddTaskViewController.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-7-31.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCo4TextFieldInScrollView.h"

@interface AddTaskViewController : BaseCo4TextFieldInScrollView 
/**
 *  Task对象,用于存储临时数据
 */
@property (strong, nonatomic) Task *temp;
/**
 *  预配置添加任务的任务日期
 */
@property (strong, nonatomic) NSString *readyDate;
/**
 *  医院Id
 */
@property (strong, nonatomic) NSString *clientId;
/**
 *  代理商Id
 */
@property (strong, nonatomic) NSString *agentId;

@end
