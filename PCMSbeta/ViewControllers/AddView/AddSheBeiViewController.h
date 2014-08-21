//
//  AddSheBeiViewController.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-11.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCo4TextFieldInScrollView.h"
@interface AddSheBeiViewController : BaseCo4TextFieldInScrollView
/**
 *  ClientRoomDevice对象,用于存储临时数据
 */
@property (strong, nonatomic) ClientRoomDevice *temp;
/**
 *  科室Id
 */
@property (strong, nonatomic) NSString *roomId;

@end
