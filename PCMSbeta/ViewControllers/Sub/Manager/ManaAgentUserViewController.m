//
//  ManaAgentUserViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-11.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "ManaAgentUserViewController.h"
#import "AddAgentUserViewController.h"
#import "AgentUserTableViewCell.h"
/**
 *  # 代理商联系人列表
 */
@interface ManaAgentUserViewController () <HDHNSFetchedResultsDelegate> {
    PXAlertView *alert;
    id longPressedRowData;
}

@property(nonatomic, strong) HDHNSFetchedResultsController *mNSFetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ManaAgentUserViewController

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
    AddAgentUserViewController *detail = (AddAgentUserViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddAgentUser"];
    detail.temp = (AgentUser *)data;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)configCellData:(id)data cell:(id)cell index:(NSIndexPath *)indexPath {
    AgentUserTableViewCell *mCell = (AgentUserTableViewCell *)cell;
    AgentUser *user = (AgentUser *)data;
    mCell.agentUserName.text = user.agentUserName;
    mCell.age.text = user.age;
    mCell.job.text = user.job;
    mCell.score.text = [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"Code" withPredicate:[NSPredicate predicateWithFormat:@"codeId = %@", user.score]] lastObject] codeName];
}

- (void)didLongPressRowData:(id)data {
    longPressedRowData = data;
    if ([[(Client *)data userId] isEqualToString:[[APP_DELEGATE currentUser] userId]]) {
        UIView *view = [[[ViewBuilder alloc] init] buttonListByTitles:@[@"联系人",@"科室",@"相关任务",@"相关订单",@"删除"] viewWidth:120.0];
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
            AgentUser *user = (AgentUser *)[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"AgentUser" withPredicate:[NSPredicate predicateWithFormat:@"agentUserId = %@",[(AgentUser *)longPressedRowData agentUserId]]] lastObject];
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
    if (_agentId) {
        predicate = [NSPredicate predicateWithFormat:@"isDelete == 'N' AND agentId = %@",_agentId];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"isDelete == 'N'"];
    }
    _mNSFetchedResultsController = [[HDHNSFetchedResultsController alloc] initWithTableView:_tableView];
    _mNSFetchedResultsController.hdhFetchedResultsController = [AgentUser fetchedResultsControllerWithPredicate:predicate];
    _mNSFetchedResultsController.delegate = self;
    _mNSFetchedResultsController.reuseIndentifier = @"AgentUserTableViewCell";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddAgentUser"]) {
        if (_agentId) {
            [(AddAgentUserViewController *)segue.destinationViewController setAgentId:_agentId];
        }
    }
}

@end
