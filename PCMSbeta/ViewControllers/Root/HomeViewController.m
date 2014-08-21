//
//  HomeViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-7-29.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "HomeViewController.h"
#import "CalenderViewController.h"
#import "TaskTableViewCell.h"
#import "AddTaskViewController.h"
/**
 *  # 主页
 */
@interface HomeViewController ()<HDHNSFetchedResultsDelegate> {
    NSDate *previousDate, *nextDate, *showDate;
    BOOL isSwipedLeft;
    BOOL isSwipedRight;
    PXAlertView *alert;
    id longPressedRowData;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *yearAndMonth;
@property (weak, nonatomic) IBOutlet UILabel *day;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property(nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property(nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property(nonatomic, strong) HDHNSFetchedResultsController *mNSFetchedResultsController;

@end

@implementation HomeViewController

#pragma mark - lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _userName.text = [[APP_DELEGATE currentUser] userName];
    [self addSwipeGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (showDate) {
        if (_userSelectedDate) {
            showDate = _userSelectedDate;
        }
    } else {
        showDate = [NSDate date];
    }
    _mNSFetchedResultsController = [[HDHNSFetchedResultsController alloc]
                                        initWithTableView:_tableView];
    _mNSFetchedResultsController.delegate = self;
    _mNSFetchedResultsController.reuseIndentifier = @"HomeTaskTableViewCell";
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:
                              @"workDate = %@ AND isDelete == 'N' AND userId = %@",
                              [StringUtil get8BitDateStringFromDate:showDate],[[APP_DELEGATE currentUser] userId]];
    _mNSFetchedResultsController.hdhFetchedResultsController =
    [Task fetchedResultsControllerWithPredicate:predicate];
    
    _yearAndMonth.text =
    [[StringUtil get8BitFormateDateString:showDate] substringToIndex:7];
    _day.text = [[StringUtil get8BitFormateDateString:showDate]
                          substringWithRange:NSMakeRange(8, 2)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _userSelectedDate = nil;
}

- (void)addSwipeGestureRecognizer {
    _leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(handleSwipeGestureFrom:)];
    _rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]
                                    initWithTarget:self
                                    action:@selector(handleSwipeGestureFrom:)];
    [_leftSwipeGestureRecognizer
     setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:_leftSwipeGestureRecognizer];
    [_rightSwipeGestureRecognizer
     setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:_rightSwipeGestureRecognizer];
}

#pragma mark - Action

- (IBAction)showCalender {
    CalenderViewController *calender =
    [[CalenderViewController alloc] initWithNibName:nil bundle:nil];
    calender.hidesBottomBarWhenPushed = YES;
    calender.home = self;
    [self.navigationController pushViewController:calender
                                         animated:YES];
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
    UIView *view = [[[ViewBuilder alloc] init] buttonListByTitles:@[@"删除"] viewWidth:120.0];
    for (UIButton *btn in view.subviews) {
        [btn addTarget:self action:@selector(tapButtonInButtonList:) forControlEvents:UIControlEventTouchUpInside];
    }
    alert = [PXAlertView showAlertWithTitle:nil message:nil cancelTitle:nil otherTitle:nil contentView:view completion:^(BOOL cancelled) {if(alert)alert = nil;}];
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

#define SECONDS_PER_DAY 24 * 60 * 60

- (void)handleSwipeGestureFrom:(UISwipeGestureRecognizer *)recognizer {
    NSTimeInterval secondsPerDay = SECONDS_PER_DAY;
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        isSwipedLeft = YES;
        previousDate = [showDate dateByAddingTimeInterval:-secondsPerDay];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                     @"workDate = %@ AND isDelete == 'N' AND userId = %@",
                     [StringUtil get8BitDateStringFromDate:previousDate],[[APP_DELEGATE currentUser] userId]];
        
        _mNSFetchedResultsController.hdhFetchedResultsController =
        [Task fetchedResultsControllerWithPredicate:predicate];
        if (isSwipedLeft == YES) {
            showDate = previousDate;
        }
        _yearAndMonth.text = [previousDate.description substringToIndex:7];
        _day.text =
        [previousDate.description substringWithRange:NSMakeRange(8, 2)];
        
    } else if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        isSwipedRight = YES;
        nextDate = [showDate dateByAddingTimeInterval:secondsPerDay];
        NSPredicate *predicate = [NSPredicate
                     predicateWithFormat:
                     @"workDate = %@ AND isDelete == 'N' AND userId = %@",
                     [StringUtil get8BitDateStringFromDate:nextDate],[[APP_DELEGATE currentUser] userId]];
        _mNSFetchedResultsController.hdhFetchedResultsController =
        [Task fetchedResultsControllerWithPredicate:predicate];
        if (isSwipedRight) {
            showDate = nextDate;
        }
        _yearAndMonth.text = [nextDate.description substringToIndex:7];
        _day.text = [nextDate.description substringWithRange:NSMakeRange(8, 2)];
    }
    [_tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"HomeAddTask"]) {
        [(AddTaskViewController *)segue.destinationViewController setReadyDate:[StringUtil get8BitFormateDateString:showDate]];
    }
}

@end
