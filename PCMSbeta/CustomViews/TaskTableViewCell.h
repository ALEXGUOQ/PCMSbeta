//
//  TaskTableViewCell.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-7-29.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <UIKit/UIKit.h>
/// # 任务列表TableViewCell
@interface TaskTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *taskName;
@property (weak, nonatomic) IBOutlet UILabel *isCompleted;
@property (weak, nonatomic) IBOutlet UILabel *clientName;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@end
