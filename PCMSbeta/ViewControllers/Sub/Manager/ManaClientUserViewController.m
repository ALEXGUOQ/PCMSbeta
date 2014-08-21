//
//  ManaClientUserViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-11.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "ManaClientUserViewController.h"
#import "AddClientUserViewController.h"
#import "ClientUserTableViewCell.h"
/**
 *  # 医院联系人列表
 */
@interface ManaClientUserViewController () <HDHNSFetchedResultsDelegate> {
    PXAlertView *alert;
    id longPressedRowData;
}

@property(nonatomic, strong) HDHNSFetchedResultsController *mNSFetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ManaClientUserViewController

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
    AddClientUserViewController *detail = (AddClientUserViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddClientUser"];
    detail.temp = (ClientUser *)data;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)configCellData:(id)data cell:(id)cell index:(NSIndexPath *)indexPath {
    ClientUserTableViewCell *mCell = (ClientUserTableViewCell *)cell;
    ClientUser *user = (ClientUser *)data;
    mCell.clientUserName.text = user.clientUserName;
    mCell.age.text = user.age;
    mCell.skill.text = user.skilled;
    mCell.score.text = [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"Code" withPredicate:[NSPredicate predicateWithFormat:@"codeId = %@", user.score]] lastObject] codeName];
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
            ClientUser *user = (ClientUser *)[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"ClientUser" withPredicate:[NSPredicate predicateWithFormat:@"clientUserId = %@",[(ClientUser *)longPressedRowData clientUserId]]] lastObject];
            user.isDelete = @"Y";
            user.updateDateTime = [StringUtil get14BitDateStringFromDate:[NSDate date]];
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
    if (_clientId) {
        predicate = [NSPredicate predicateWithFormat:@"isDelete == 'N' AND clientId = %@",_clientId];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"isDelete == 'N'"];
    }
    _mNSFetchedResultsController = [[HDHNSFetchedResultsController alloc] initWithTableView:_tableView];
    _mNSFetchedResultsController.hdhFetchedResultsController = [ClientUser fetchedResultsControllerWithPredicate:predicate];
    _mNSFetchedResultsController.delegate = self;
    _mNSFetchedResultsController.reuseIndentifier = @"ClientUserTableViewCell";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddClientUser"]) {
        if (_clientId) {
            [(AddClientUserViewController *)segue.destinationViewController setClientId:_clientId];
        }
    }
}

@end
