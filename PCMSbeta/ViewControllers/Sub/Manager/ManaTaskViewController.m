//
//  ManaTaskViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-7-31.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "ManaTaskViewController.h"
#import "TaskTableViewCell.h"
#import "AddTaskViewController.h"
/**
 *  # 任务列表
 */
@interface ManaTaskViewController () <HDHNSFetchedResultsDelegate> {
    PXAlertView *alert;
    id longPressedRowData;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) HDHNSFetchedResultsController *mNSFetchedResultsController;

@end

@implementation ManaTaskViewController

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
    AddTaskViewController *detail = (AddTaskViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddTask"];
    detail.temp = (Task *)data;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)configCellData:(id)data cell:(id)cell index:(NSIndexPath *)indexPath {
    TaskTableViewCell *mCell = (TaskTableViewCell *)cell;
    Task *task = (Task *)data;
    NSString *visitedClient = [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"Client" withPredicate:[NSPredicate predicateWithFormat:@"clientId = %@", task.clientId]] lastObject] clientName];
    NSString *visitedAgent = [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"Agent" withPredicate:[NSPredicate predicateWithFormat:@"agentId = %@", task.clientId]] lastObject] agentName];
    mCell.clientName.text = visitedAgent == nil ? visitedClient == nil ? nil : visitedClient : visitedAgent;
    mCell.userName.text = [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"User" withPredicate:[NSPredicate predicateWithFormat:@"userId = %@", task.userId]] lastObject] userName];
    mCell.taskName.text = task.task;
    if (task.startDateTime) {
        if (task.endDateTime) {
            mCell.isCompleted.text = @"签到完成";
            mCell.isCompleted.textColor = [UIColor lightGrayColor];
        } else {
            mCell.isCompleted.text = @"一次签到";
            mCell.isCompleted.textColor = [UIColor purpleColor];
        }
    } else {
        mCell.isCompleted.text = @"未签到";
        mCell.isCompleted.textColor = [UIColor redColor];
    }
    mCell.date.text = [StringUtil getDateFormatStringFrom8BitString:task.workDate];
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
            Task *task = (Task *)[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"Task" withPredicate:[NSPredicate predicateWithFormat:@"taskId = %@",[(Task *)longPressedRowData taskId]]] lastObject];
            task.isDelete = @"Y";
            task.updateDateTime = [StringUtil get14BitDateStringFromDate:[NSDate date]];
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

- (void)deleteTaskRowData:(id)data {
    Task *task = [[CoreDataUtil retrieveData:[(AppDelegate *)[[UIApplication sharedApplication] delegate]managedObjectContext] modelName:@"Task" withPredicate:[NSPredicate predicateWithFormat:@"taskId == %@", ((Task *)data).taskId]] lastObject];
    task.isDelete = @"Y";
    task.updateDateTime = [StringUtil get14BitDateStringFromDate:[NSDate date]];
}

- (void)configTableView {
    NSPredicate *predicate;
    if (_clientId) {
        predicate = [NSPredicate predicateWithFormat:@"isDelete == 'N' AND clientId = %@",_clientId];
    } else if (_agentId) {
        predicate = [NSPredicate predicateWithFormat:@"isDelete == 'N' AND clientId = %@",_agentId];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"isDelete == 'N'"];
    }
    _mNSFetchedResultsController = [[HDHNSFetchedResultsController alloc] initWithTableView:_tableView];
    _mNSFetchedResultsController.hdhFetchedResultsController = [Task fetchedResultsControllerWithPredicate:predicate];
    _mNSFetchedResultsController.delegate = self;
    _mNSFetchedResultsController.reuseIndentifier = @"ManagerTaskTableViewCell";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ManagerAddTask"]) {
        [(AddTaskViewController *)segue.destinationViewController setReadyDate:[StringUtil get8BitFormateDateString:[NSDate date]]];
        if (_clientId) {
            [(AddTaskViewController *)segue.destinationViewController setClientId:_clientId];
        }
        if (_agentId) {
            [(AddTaskViewController *)segue.destinationViewController setAgentId:_agentId];
        }
    }
}

@end
