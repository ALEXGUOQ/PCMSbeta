//
//  MyAreaPickerView.h
//  CustomUIPickerView
//
//  Created by hudahan on 14-4-9.
//  Copyright (c) 2014年 天津米索软件有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
/**
 *  # 省市选择器视图
 */
@interface MyAreaPickerView : UIPickerView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) NSDictionary *areaDic;
@property (nonatomic, strong) NSArray *province;
@property (nonatomic, strong) NSArray *city;
@property (nonatomic, strong) NSString *selectedProvinceName;
@property (nonatomic, strong) NSString *selectedProvinceRow;
@property (nonatomic, strong) NSString *selectedCityRow;

- (NSString *)selectedAreaName;
- (NSString *)selectedProvinceCode;
- (NSString *)selectedCityCode;
- (NSString *)getAreaNameWithProvinceCode:(NSString *)provineCode andCityCode:(NSString *)cityCode;

@end
