//
//  AgentTableViewCell.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-7-31.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <UIKit/UIKit.h>
/// # 代理商列表TableViewCell
@interface AgentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *agentName;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *score;

@end
