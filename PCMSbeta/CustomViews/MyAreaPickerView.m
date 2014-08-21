//
//  MyAreaPickerView.m
//  CustomUIPickerView
//
//  Created by hudahan on 14-4-9.
//  Copyright (c) 2014年 天津米索软件有限公司. All rights reserved.
//

#import "MyAreaPickerView.h"

@implementation MyAreaPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *plistPath = [bundle pathForResource:@"Areaplist" ofType:@"plist"];
        _areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        NSArray *components = [_areaDic allKeys];
        NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *tmp = [[_areaDic objectForKey: index] allKeys];
            [provinceTmp addObject: [tmp objectAtIndex:0]];
        }
        _province = [[NSArray alloc] initWithArray: provinceTmp];
        
        NSString *index = [sortedArray objectAtIndex:0];
        NSString *selected = [_province objectAtIndex:0];
        
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [[_areaDic objectForKey:index]objectForKey:selected]];
        NSArray *cityComponents = [cityDic allKeys];
        NSArray *sortedCityArray = [cityComponents sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *cityTmp = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedCityArray count]; i++) {
            NSString *index = [sortedCityArray objectAtIndex:i];
            NSArray *tmp = [[cityDic objectForKey: index] allKeys];
            [cityTmp addObject: [tmp objectAtIndex:0]];
        }
        _city = [[NSArray alloc] initWithArray: cityTmp];
        self.dataSource = self;
        self.delegate = self;
        self.showsSelectionIndicator = YES;
        [self selectRow: 0 inComponent: 0 animated: YES];
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == PROVINCE_COMPONENT) {
        return _province.count;
    } else {
        return _city.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == PROVINCE_COMPONENT) {
        return  [_province objectAtIndex:row];
    } else {
        return  [_city objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == PROVINCE_COMPONENT) {
        _selectedProvinceRow = [NSString stringWithFormat:@"%ld",(long)row];
        _selectedProvinceName = [_province objectAtIndex: row];
        NSString *keyString = row < 9 ? [NSString stringWithFormat:@"0%ld",(long)(row+1)] : [NSString stringWithFormat:@"%ld", (long)(row+1)];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [_areaDic objectForKey: keyString]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: _selectedProvinceName]];
        NSArray *cityArray = [dic allKeys];
        NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;//递减
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;//上升
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *temp = [[dic objectForKey: index] allKeys];
            [array addObject: [temp objectAtIndex:0]];
        }
        
        _city = [[NSArray alloc] initWithArray: array];
        
        [self selectRow:0 inComponent:CITY_COMPONENT animated: YES];
        [self reloadComponent: CITY_COMPONENT];
    } else {
        _selectedCityRow = [NSString stringWithFormat:@"%ld",(long)row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component == PROVINCE_COMPONENT) {
        return 120;
    } else {
        return 125;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *myView = nil;
    
    if (component == PROVINCE_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 120, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [_province objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    } else {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 125, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [_city objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    
    return myView;
}

- (NSString *)getAreaNameWithProvinceCode:(NSString *)provineCode andCityCode:(NSString *)cityCode{
    if (provineCode) {
        NSDictionary *provinceNamePair_Key = [_areaDic objectForKey:provineCode];
        NSArray *provinceNameArray_Key = [provinceNamePair_Key allKeys];
        NSArray *cityNameArray_Values = [provinceNamePair_Key allValues];
        
        NSDictionary *cityCodePairs = [cityNameArray_Values lastObject];
        NSDictionary *cityNamePair = [cityCodePairs objectForKey:cityCode];
        NSArray *cityNameArray_Key = [cityNamePair allKeys];
        
        
        NSString *cityNameKey = [cityNameArray_Key lastObject];
        NSString *provinceNameKey = [provinceNameArray_Key lastObject];
        
        
        return [NSString stringWithFormat:@"%@%@",provinceNameKey,cityNameKey];
    }
    return @"";
}

- (NSString *)selectedCityCode{
    return [NSString stringWithFormat:@"%@%@",[self selectedProvinceCode],[self selectedCityRow]];
}

- (NSString *)selectedCityRow{
    NSInteger cityIndex = [self selectedRowInComponent: CITY_COMPONENT];
    if (cityIndex < 9) {
        NSString *cityKey = [NSString stringWithFormat:@"0%ld",(long)(cityIndex+1)];
        return cityKey;
    }else{
        NSString *cityKey = [NSString stringWithFormat:@"%ld",(long)(cityIndex+1)];
        return cityKey;
    }
}

- (NSString *)selectedProvinceCode{
    NSInteger provinceIndex = [self selectedRowInComponent: PROVINCE_COMPONENT];
    if (provinceIndex < 9) {
        NSString *provinceKey = [NSString stringWithFormat:@"0%ld",(long)(provinceIndex+1)];
        return provinceKey;
    }else{
        NSString *provinceKey = [NSString stringWithFormat:@"%ld",(long)(provinceIndex+1)];
        return provinceKey;
    }
    
}

- (NSString *)selectedAreaName{
    NSInteger provinceIndex = [self selectedRowInComponent: PROVINCE_COMPONENT];
    NSInteger cityIndex = [self selectedRowInComponent: CITY_COMPONENT];
    
    NSString *provinceStr = [_province objectAtIndex:provinceIndex];
    NSString *cityStr =[_city objectAtIndex:cityIndex];
    
    NSString *areaName = [NSString stringWithFormat: @"%@%@", provinceStr, cityStr];
    return areaName;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
