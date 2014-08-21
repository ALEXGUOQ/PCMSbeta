//
//  ManaKeShiViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-11.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "ManaKeShiViewController.h"
#import "AddKeShiViewController.h"
#import "KeShiTableViewCell.h"
#import "ManaSheBeiViewController.h"
/**
 *  # 科室列表
 */
@interface ManaKeShiViewController () <HDHNSFetchedResultsDelegate> {
    PXAlertView *alert;
    id longPressedRowData;
}

@property(nonatomic, strong) HDHNSFetchedResultsController *mNSFetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ManaKeShiViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![_userId isEqualToString:[[APP_DELEGATE currentUser] userId]]) {
        [[self.navigationItem rightBarButtonItem] setEnabled:NO];
    }
    [self configTableView];
}

#pragma mark - HDHNSFetchedResultsDelegate

- (void)didSelectRowData:(id)data {
    AddKeShiViewController *detail = (AddKeShiViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddKeShi"];
    detail.temp = (ClientRoom *)data;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)configCellData:(id)data cell:(id)cell index:(NSIndexPath *)indexPath {
    KeShiTableViewCell *mCell = (KeShiTableViewCell *)cell;
    ClientRoom *room = (ClientRoom *)data;
    mCell.keShiName.text = room.roomName;
    mCell.age.text = room.age;
    mCell.zhuRen.text = room.zhuRenName;
    mCell.sex.text = [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"Code" withPredicate:[NSPredicate predicateWithFormat:@"codeId = %@", room.sex]] lastObject] codeName];
}

- (void)didLongPressRowData:(id)data {
    longPressedRowData = data;
    UIView *view = [[[ViewBuilder alloc] init] buttonListByTitles:@[@"设备",@"删除"] viewWidth:120.0];
    if (![[(Client *)data userId] isEqualToString:[[APP_DELEGATE currentUser] userId]]) {
        view = [[[ViewBuilder alloc] init] buttonListByTitles:@[@"设备"] viewWidth:120.0];
    }
    for (UIButton *btn in view.subviews) {
        [btn addTarget:self action:@selector(tapButtonInButtonList:) forControlEvents:UIControlEventTouchUpInside];
    }
    alert = [PXAlertView showAlertWithTitle:nil message:nil cancelTitle:nil otherTitle:nil contentView:view completion:^(BOOL cancelled) {if(alert)alert = nil;}];
}

#pragma mark - LongPressedButtonList Button

- (void)tapButtonInButtonList:(id)sender {
    [alert dismiss:sender];
    if ([[(UIButton *)sender titleForState:UIControlStateNormal] isEqualToString:@"设备"]) {
        ManaSheBeiViewController *clientUserList = (ManaSheBeiViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SheBeiTableView"];
        clientUserList.keShiId = [(ClientRoom *)longPressedRowData roomId];
        clientUserList.userId = [(ClientRoom *)longPressedRowData userId];
        [self.navigationController pushViewController:clientUserList animated:YES];
    } else if ([[(UIButton *)sender titleForState:UIControlStateNormal] isEqualToString:@"删除"]) {
        [PXAlertView showAlertWithTitle:@"删除后不可恢复" message:@"确定删除?" cancelTitle:@"取消" otherTitle:@"确定"completion:^(BOOL cancelled) {
            if (!cancelled) {
                ClientRoom *room = (ClientRoom *)[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"ClientRoom" withPredicate:[NSPredicate predicateWithFormat:@"roomId = %@",[(ClientRoom *)longPressedRowData roomId]]] lastObject];
                room.isDelete = @"Y";
                room.updateDateTime = [StringUtil get14BitDateStringFromDate:[NSDate date]];
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

#pragma mark - simple method

- (void)configTableView {
    NSPredicate *predicate;
    if (_clientId) {
        predicate = [NSPredicate predicateWithFormat:@"isDelete == 'N' AND clientId = %@",_clientId];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"isDelete == 'N'"];
    }
    _mNSFetchedResultsController = [[HDHNSFetchedResultsController alloc] initWithTableView:_tableView];
    _mNSFetchedResultsController.hdhFetchedResultsController = [ClientRoom fetchedResultsControllerWithPredicate:predicate];
    _mNSFetchedResultsController.delegate = self;
    _mNSFetchedResultsController.reuseIndentifier = @"KeShiTableViewCell";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddKeShi"]) {
        if (_clientId) {
            [(AddKeShiViewController *)segue.destinationViewController setClientId:_clientId];
        }
    }
}

@end
