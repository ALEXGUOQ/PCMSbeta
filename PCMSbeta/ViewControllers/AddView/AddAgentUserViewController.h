//
//  AddAgentUserViewController.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-11.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCo4TextFieldInScrollView.h"
@interface AddAgentUserViewController : BaseCo4TextFieldInScrollView
/**
 *  AgentUser对象,用于存储临时数据
 */
@property (strong, nonatomic) AgentUser *temp;
/**
 *  代理商Id
 */
@property (strong, nonatomic) NSString *agentId;

@end
