//
//  ManaClientViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-7-31.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "ManaClientViewController.h"
#import "ClientTableViewCell.h"
#import "AddClientViewController.h"
#import "MyAreaPickerView.h"
#import "ManaTaskViewController.h"
#import "ManaClientUserViewController.h"
#import "ManaKeShiViewController.h"
#import "ManaProductOrderViewController.h"
/**
 *  # 医院列表
 */
@interface ManaClientViewController () <HDHNSFetchedResultsDelegate> {
    PXAlertView *alert;
    id longPressedRowData;
}

@property(nonatomic, strong) HDHNSFetchedResultsController *mNSFetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ManaClientViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configTableView];
}

#pragma mark - simple method

- (void)configTableView {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isDelete == 'N'"];
    _mNSFetchedResultsController = [[HDHNSFetchedResultsController alloc] initWithTableView:_tableView];
    _mNSFetchedResultsController.hdhFetchedResultsController = [Client fetchedResultsControllerWithPredicate:predicate];
    _mNSFetchedResultsController.delegate = self;
    _mNSFetchedResultsController.reuseIndentifier = @"ClientTableViewCell";
}

#pragma mark - HDHNSFetchedResultsDelegate

- (void)didSelectRowData:(id)data {
    AddClientViewController *detail = (AddClientViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddClient"];
    detail.temp = (Client *)data;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)configCellData:(id)data cell:(id)cell index:(NSIndexPath *)indexPath {
    ClientTableViewCell *mCell = (ClientTableViewCell *)cell;
    Client *client = (Client *)data;
    mCell.clientName.text = client.clientName;
    mCell.userName.text = [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"User" withPredicate:[NSPredicate predicateWithFormat:@"userId = %@", client.userId]] lastObject] userName];
    NSString *city = [[[MyAreaPickerView alloc] init] getAreaNameWithProvinceCode:client.provinceId andCityCode:client.cityId];
    if (city) {
        mCell.address.text = city;
        if (client.address) {
            mCell.address.text = [city stringByAppendingString:client.address];
        }
    }
    mCell.score.text = [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"Code" withPredicate:[NSPredicate predicateWithFormat:@"codeId = %@", client.score]] lastObject] codeName];
}

- (void)didLongPressRowData:(id)data {
    longPressedRowData = data;
    UIView *view = [[[ViewBuilder alloc] init] buttonListByTitles:@[@"联系人",@"科室",@"相关任务",@"相关订单",@"删除"] viewWidth:120.0];
    if (![[(Client *)data userId] isEqualToString:[[APP_DELEGATE currentUser] userId]]) {
        view = [[[ViewBuilder alloc] init] buttonListByTitles:@[@"联系人",@"科室",@"相关任务",@"相关订单"] viewWidth:120.0];
    }
    for (UIButton *btn in view.subviews) {
        [btn addTarget:self action:@selector(tapButtonInButtonList:) forControlEvents:UIControlEventTouchUpInside];
    }
    alert = [PXAlertView showAlertWithTitle:nil message:nil cancelTitle:nil otherTitle:nil contentView:view completion:^(BOOL cancelled) {if(alert)alert = nil;}];
}

#pragma mark - LongPressedButtonList Button

- (void)tapButtonInButtonList:(id)sender {
    [alert dismiss:sender];
    if ([[(UIButton *)sender titleForState:UIControlStateNormal] isEqualToString:@"联系人"]) {
        ManaClientUserViewController *clientUserList = (ManaClientUserViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ClientUserTableView"];
        clientUserList.clientId = [(Client *)longPressedRowData clientId];
        clientUserList.userId = [(Client *)longPressedRowData userId];
        [self.navigationController pushViewController:clientUserList animated:YES];
    } else if ([[(UIButton *)sender titleForState:UIControlStateNormal] isEqualToString:@"科室"]) {
        ManaKeShiViewController *keShiList = (ManaKeShiViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"KeShiTableView"];
        keShiList.clientId = [(Client *)longPressedRowData clientId];
        keShiList.userId = [(Client *)longPressedRowData userId];
        [self.navigationController pushViewController:keShiList animated:YES];
    } else if ([[(UIButton *)sender titleForState:UIControlStateNormal] isEqualToString:@"相关任务"]) {
        ManaTaskViewController *taskList = (ManaTaskViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TaskTableView"];
        taskList.clientId = [(Client *)longPressedRowData clientId];
        taskList.userId = [(Client *)longPressedRowData userId];
        [self.navigationController pushViewController:taskList animated:YES];
    } else if ([[(UIButton *)sender titleForState:UIControlStateNormal] isEqualToString:@"相关订单"]) {
        ManaProductOrderViewController *productOrderList = (ManaProductOrderViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductOrderTableView"];
        productOrderList.foreignkey = [(Client *)longPressedRowData clientId];
        productOrderList.userId = [(Client *)longPressedRowData userId];
        [self.navigationController pushViewController:productOrderList animated:YES];
    } else if ([[(UIButton *)sender titleForState:UIControlStateNormal] isEqualToString:@"删除"]) {
        [PXAlertView showAlertWithTitle:@"删除后不可恢复" message:@"确定删除?" cancelTitle:@"取消" otherTitle:@"确定"completion:^(BOOL cancelled) {
            if (!cancelled) {
                Client *client = (Client *)[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"Client" withPredicate:[NSPredicate predicateWithFormat:@"clientId = %@",[(Client *)longPressedRowData clientId]]] lastObject];
                client.isDelete = @"Y";
                client.updateDateTime = [StringUtil get14BitDateStringFromDate:[NSDate date]];
                NSError *error = nil;
                if (![MANAGED_OBJECT_CONTEXT save:&error]) {
                    NSLog(@"sorry %@", [error localizedDescription]);
                } else {
                    [ViewBuilder autoDismissAlertViewWithTitle:@"删除成功!" afterDelay:0.5f];
                }
            }
        }];
    }
}

@end
