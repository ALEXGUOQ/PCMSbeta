//
//  ProductTableViewCell.h
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-15.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import <UIKit/UIKit.h>
/// # 产品TableViewCell
@interface ProductTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *standard;
@property (weak, nonatomic) IBOutlet UITextField *count;


@end
