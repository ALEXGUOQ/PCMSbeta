//
//  AddProductOrderViewController.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-15.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddProductOrderViewController : UIViewController
/**
 *  ProductOrder对象,用于存储临时数据
 */
@property (strong, nonatomic) ProductOrder *temp;
/**
 *  外键医院Id
 */
@property (strong, nonatomic) NSString *foreignkey;

@end
