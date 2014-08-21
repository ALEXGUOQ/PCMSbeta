//
//  AgentUserTableViewCell.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-11.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <UIKit/UIKit.h>
/// # 代理商联系人TableViewCell
@interface AgentUserTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *agentUserName;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UILabel *job;
@property (weak, nonatomic) IBOutlet UILabel *score;

@end
