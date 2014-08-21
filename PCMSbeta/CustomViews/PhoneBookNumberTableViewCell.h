//
//  PhoneBookNumberTableViewCell.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-14.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Checkbox.h"
/// # 电话本TableViewCell
@interface PhoneBookNumberTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *remark;
@property (weak, nonatomic) IBOutlet Checkbox *checkBox;

@end
