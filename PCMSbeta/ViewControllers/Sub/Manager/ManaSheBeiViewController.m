//
//  ManaSheBeiViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-11.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "ManaSheBeiViewController.h"
#import "AddSheBeiViewController.h"
#import "SheBeiTableViewCell.h"
/**
 *  # 科室设备列表
 */
@interface ManaSheBeiViewController () <HDHNSFetchedResultsDelegate> {
    PXAlertView *alert;
    id longPressedRowData;
}

@property(nonatomic, strong) HDHNSFetchedResultsController *mNSFetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ManaSheBeiViewController

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
    AddSheBeiViewController *detail = (AddSheBeiViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddSheBei"];
    detail.temp = (ClientRoomDevice *)data;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)configCellData:(id)data cell:(id)cell index:(NSIndexPath *)indexPath {
    SheBeiTableViewCell *mCell = (SheBeiTableViewCell *)cell;
    ClientRoomDevice *sheBei = (ClientRoomDevice *)data;
    mCell.type.text = [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"Code" withPredicate:[NSPredicate predicateWithFormat:@"codeId = %@", sheBei.type]] lastObject] codeName];
    mCell.count.text = sheBei.count;
    mCell.brand.text = sheBei.brand;
    mCell.version.text = [@"型号:" stringByAppendingString:sheBei.version];
}

- (void)didLongPressRowData:(id)data {
    longPressedRowData = data;
    if ([[(Client *)data userId] isEqualToString:[[APP_DELEGATE currentUser] userId]]) {
        UIView *view = [[[ViewBuilder alloc] init] buttonListByTitles:@[@"删除"] viewWidth:120.0];
        for (UIButton *btn in view.subviews) {
            [btn addTarget:self action:@selector(tapButtonInButtonList:) forControlEvents:UIControlEventTouchUpInside];
        }
        alert = [PXAlertView showAlertWithTitle:nil message:nil cancelTitle:nil otherTitle:nil contentView:view completion:^(BOOL cancelled) {if(alert)alert = nil;}];
    }
}

#pragma mark - LongPressedButtonList Button

- (void)tapButtonInButtonList:(id)sender {
    [alert dismiss:sender];
    [PXAlertView showAlertWithTitle:@"删除后不可恢复" message:@"确定删除?" cancelTitle:@"取消" otherTitle:@"确定"completion:^(BOOL cancelled) {
        if (!cancelled) {
            ClientRoomDevice *sheBei = (ClientRoomDevice *)[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"ClientRoomDevice" withPredicate:[NSPredicate predicateWithFormat:@"deviceId = %@",[(ClientRoomDevice *)longPressedRowData deviceId]]] lastObject];
            sheBei.isDelete = @"Y";
            sheBei.updateDateTime = [StringUtil get14BitDateStringFromDate:[NSDate date]];
            NSError *error = nil;
            if (![MANAGED_OBJECT_CONTEXT save:&error]) {
                NSLog(@"sorry %@", [error localizedDescription]);
            } else {
                [ViewBuilder autoDismissAlertViewWithTitle:@"删除成功!" afterDelay:0.5f];
            }
        }
    }];
}

#pragma mark - simple method

- (void)configTableView {
    NSPredicate *predicate;
    if (_keShiId) {
        predicate = [NSPredicate predicateWithFormat:@"isDelete == 'N' AND roomId = %@",_keShiId];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"isDelete == 'N'"];
    }
    _mNSFetchedResultsController = [[HDHNSFetchedResultsController alloc] initWithTableView:_tableView];
    _mNSFetchedResultsController.hdhFetchedResultsController = [ClientRoomDevice fetchedResultsControllerWithPredicate:predicate];
    _mNSFetchedResultsController.delegate = self;
    _mNSFetchedResultsController.reuseIndentifier = @"SheBeiTableViewCell";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddSheBei"]) {
        if (_keShiId) {
            [(AddSheBeiViewController *)segue.destinationViewController setRoomId:_keShiId];
        }
    }
}

@end
