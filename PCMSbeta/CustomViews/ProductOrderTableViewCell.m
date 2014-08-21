//
//  ProductOrderTableViewCell.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-15.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "ProductOrderTableViewCell.h"

@implementation ProductOrderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
