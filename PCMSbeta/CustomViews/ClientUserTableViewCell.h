//
//  ClientUserTableViewCell.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-11.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <UIKit/UIKit.h>
/// # 医院联系人TableViewCell
@interface ClientUserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *clientUserName;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UILabel *skill;
@property (weak, nonatomic) IBOutlet UILabel *score;


@end
