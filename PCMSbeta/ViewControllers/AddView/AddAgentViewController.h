//
//  AddAgentViewController.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-7-31.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCo4TextFieldInScrollView.h"
@interface AddAgentViewController : BaseCo4TextFieldInScrollView
/**
 *  Agent对象,用于存储临时数据
 */
@property (strong, nonatomic) Agent *temp;

@end
