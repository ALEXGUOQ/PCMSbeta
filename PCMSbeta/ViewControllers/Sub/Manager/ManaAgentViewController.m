//
//  ManaAgentViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-7-31.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "ManaAgentViewController.h"
#import "AgentTableViewCell.h"
#import "AddAgentViewController.h"
#import "MyAreaPickerView.h"
#import "ManaAgentUserViewController.h"
#import "ManaTaskViewController.h"
/**
 *  # 代理商列表
 */
@interface ManaAgentViewController () <HDHNSFetchedResultsDelegate> {
    PXAlertView *alert;
    id longPressedRowData;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) HDHNSFetchedResultsController *mNSFetchedResultsController;

@end

@implementation ManaAgentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configTableView];
}

#pragma mark - simple method

- (void)configTableView {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isDelete == 'N'"];
    _mNSFetchedResultsController = [[HDHNSFetchedResultsController alloc] initWithTableView:_tableView];
    _mNSFetchedResultsController.hdhFetchedResultsController = [Agent fetchedResultsControllerWithPredicate:predicate];
    _mNSFetchedResultsController.delegate = self;
    _mNSFetchedResultsController.reuseIndentifier = @"AgentTableViewCell";
}

#pragma mark - HDHNSFetchedResultsDelegate

- (void)didSelectRowData:(id)data {
    AddAgentViewController *detail = (AddAgentViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddAgent"];
    detail.temp = (Agent *)data;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)configCellData:(id)data cell:(id)cell index:(NSIndexPath *)indexPath {
    AgentTableViewCell *mCell = (AgentTableViewCell *)cell;
    Agent *agent = (Agent *)data;
    mCell.agentName.text = agent.agentName;
    mCell.userName.text = [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"User" withPredicate:[NSPredicate predicateWithFormat:@"userId = %@", agent.userId]] lastObject] userName];;
    NSString *city = [[[MyAreaPickerView alloc] init] getAreaNameWithProvinceCode:agent.proviceId andCityCode:agent.cityId];
    if (city) {
        mCell.address.text = city;
        if (agent.address) {
            mCell.address.text = [city stringByAppendingString:agent.address];
        }
    }
    mCell.score.text = [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"Code" withPredicate:[NSPredicate predicateWithFormat:@"codeId = %@", agent.score]] lastObject] codeName];
}

- (void)didLongPressRowData:(id)data {
    longPressedRowData = data;
    UIView *view = [[[ViewBuilder alloc] init] buttonListByTitles:@[@"联系人",@"相关任务",@"删除"] viewWidth:120.0];
    if (![[(Agent *)data userId] isEqualToString:[[APP_DELEGATE currentUser] userId]]) {
        view = [[[ViewBuilder alloc] init] buttonListByTitles:@[@"联系人",@"相关任务"] viewWidth:120.0];
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
        ManaAgentUserViewController *agentUserList = (ManaAgentUserViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AgentUserTableView"];
        agentUserList.agentId = [(Agent *)longPressedRowData agentId];
        agentUserList.userId = [(Agent *)longPressedRowData userId];
        [self.navigationController pushViewController:agentUserList animated:YES];
    } else if ([[(UIButton *)sender titleForState:UIControlStateNormal] isEqualToString:@"相关任务"]) {
        ManaTaskViewController *taskList = (ManaTaskViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TaskTableView"];
        taskList.agentId = [(Agent *)longPressedRowData agentId];
        taskList.userId = [(Agent *)longPressedRowData userId];
        [self.navigationController pushViewController:taskList animated:YES];
    } else if ([[(UIButton *)sender titleForState:UIControlStateNormal] isEqualToString:@"删除"]) {
        [PXAlertView showAlertWithTitle:@"删除后不可恢复" message:@"确定删除?" cancelTitle:@"取消" otherTitle:@"确定"completion:^(BOOL cancelled) {
            if (!cancelled) {
                Agent *agent = (Agent *)[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"Agent" withPredicate:[NSPredicate predicateWithFormat:@"agentId = %@",[(Agent *)longPressedRowData agentId]]] lastObject];
                agent.isDelete = @"Y";
                agent.updateDateTime = [StringUtil get14BitDateStringFromDate:[NSDate date]];
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
