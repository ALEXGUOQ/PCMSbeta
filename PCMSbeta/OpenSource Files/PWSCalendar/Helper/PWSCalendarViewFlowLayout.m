//
//  PWSCalendarViewFlowLayout.m
//  PWSCalendar
//
//  Created by Sylar on 3/14/14.
//  Copyright (c) 2014 PWS. All rights reserved.
//

#import "PWSCalendarViewFlowLayout.h"

@implementation PWSCalendarViewFlowLayout

-(id)init
{
    self = [super init];
    if (self) {
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
    }
    
    return self;
}

@end
