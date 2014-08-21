//
//  ProductOrderTableViewCell.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-15.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <UIKit/UIKit.h>
/// # 产品订单TableViewCell
@interface ProductOrderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *clientId;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *date;


@end
