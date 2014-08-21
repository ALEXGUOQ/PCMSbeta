//
//  KeShiTableViewCell.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-11.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <UIKit/UIKit.h>
/// # 科室列表TableViewCell
@interface KeShiTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *keShiName;
@property (weak, nonatomic) IBOutlet UILabel *sex;
@property (weak, nonatomic) IBOutlet UILabel *zhuRen;
@property (weak, nonatomic) IBOutlet UILabel *age;


@end
