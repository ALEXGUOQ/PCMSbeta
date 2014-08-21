//
//  NumberClientViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-7-30.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "NumberClientViewController.h"
#import "PhoneBookNumberTableViewCell.h"
#import "DiscPhonesBookViewController.h"

@interface NumberClientViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSMutableDictionary *dic;
@property(nonatomic, strong) NSArray *keyArray;
@end

@implementation NumberClientViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@ AND isDelete == 'N'", [[APP_DELEGATE currentUser] userId]];
    NSArray *result = [CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"ClientUser" withPredicate:predicate];
    NSMutableDictionary *users = [[NSMutableDictionary alloc] init];
    
    if (result.count > 0) {
        for (ClientUser *user in result) {
            NSString *usersName = user.clientUserName;
            
            NSMutableArray *userNumbers = [[NSMutableArray alloc] init];
            if ((user.phoneOne != nil) & ![user.phoneOne isEqualToString:@""]) {
                NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
                [info setObject:@"NO" forKey:@"checked"];
                [info setObject:user.phoneOne forKey:@"phone"];
                [info setObject:user.remarkOne == nil ? @"" : user.remarkOne forKey:@"remark"];
                [userNumbers addObject:info];
            }
            
            if ((user.phoneTwo != nil)&![user.phoneTwo isEqualToString:@""]) {
                NSMutableDictionary *info1 = [[NSMutableDictionary alloc] init];
                [info1 setObject:@"NO" forKey:@"checked"];
                [info1 setObject:user.phoneTwo forKey:@"phone"];
                [info1 setObject:user.remarkTwo == nil ? @"" : user.remarkTwo forKey:@"remark"];
                [userNumbers addObject:info1];
            }
            
            if ((user.phoneThree != nil)&![user.phoneThree isEqualToString:@""]) {
                NSMutableDictionary *info2 = [[NSMutableDictionary alloc] init];
                [info2 setObject:@"NO" forKey:@"checked"];
                [info2 setObject:user.phoneThree forKey:@"phone"];
                [info2 setObject:user.remarkThree == nil ? @"" : user.remarkTwo forKey:@"remark"];
                [userNumbers addObject:info2];
            }
            if (userNumbers.count > 0) {
                [users setObject:userNumbers forKey:usersName];
            }
        }
    }
    _dic = users;
    _keyArray = [users allKeys];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_keyArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *valueArr = [_dic objectForKey:_keyArray[section]];
    return [valueArr count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(2, -4, 320, 30)];
    lable.textColor = [UIColor whiteColor];
    lable.font = [UIFont systemFontOfSize:14];
    lable.text = _keyArray[section];
    [view addSubview:lable];
    [view setBackgroundColor:UIColorFromRGB(0x59959D)];//(89,149,143)
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhoneBookNumberTableViewCell *cell = (PhoneBookNumberTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PhoneBookNumberTableViewCell"];
    NSDictionary *item = [_dic objectForKey:_keyArray[indexPath.section]][(NSUInteger)indexPath.row];
    cell.number.text = [item objectForKey:@"phone"];
    cell.remark.text = [item objectForKey:@"remark"];
    cell.checkBox.checked = [item[@"checked"] boolValue];
    return cell;
}

- (IBAction)checkBoxTapped:(id)sender forEvent:(UIEvent *)event {
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_tableView];
    
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath != nil) {
        NSMutableDictionary *selectedItem = [_dic objectForKey:_keyArray[indexPath.section]][(NSUInteger)indexPath.row];
        selectedItem[@"checked"] = @([(Checkbox *)sender isChecked]);
    } else {
        for (int i = 0; i < _keyArray.count; i++) {
            NSArray *arr = [_dic objectForKey:_keyArray[i]];
            for (int j = 0; j < arr.count; j++) {
                NSMutableDictionary *item = arr[j];
                item[@"checked"] = @([(Checkbox *)sender isChecked]);
                [_tableView reloadData];
                NSString *key = [NSString stringWithFormat:@"%d%dclient", i, j];
                if ([[(Checkbox *)sender accessibilityValue] isEqualToString:@"Enabled"]) {
                    [((DiscPhonesBookViewController *)self.parentViewController).phoneInfo setObject:item[@"phone"] forKey:key];
                } else {
                    [((DiscPhonesBookViewController *)self.parentViewController).phoneInfo removeObjectForKey:key];
                }
            }
        }
    }
    [self updateAccessibilityForCellAtIndexPath:indexPath tableView:_tableView];
}

- (void)updateAccessibilityForCellAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    PhoneBookNumberTableViewCell *cell = (PhoneBookNumberTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
    NSString *key = [NSString stringWithFormat:@"%ld%ldclient", (long)indexPath.section, (long)indexPath.row];
    cell.checkBox.accessibilityLabel = cell.number.text;
    if ([cell.checkBox.accessibilityValue isEqualToString:@"Enabled"]) {
        [((DiscPhonesBookViewController *)self.parentViewController).phoneInfo setObject:cell.checkBox.accessibilityLabel forKey:key];
    } else {
        [((DiscPhonesBookViewController *)self.parentViewController).phoneInfo removeObjectForKey:key];
    }
}

@end
