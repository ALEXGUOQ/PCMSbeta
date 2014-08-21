//
//  ManaAchievementViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-7-31.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "ManaAchievementViewController.h"
#import "AchievementTableViewCell.h"
#import "FindOrderFormByAchievement.h"
/**
 *  # 业绩列表
 */
@interface ManaAchievementViewController () <HDHNSFetchedResultsDelegate> {
    PXAlertView *alert;
}

@property(nonatomic, strong) HDHNSFetchedResultsController *mNSFetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ManaAchievementViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configTableView];
}

#pragma mark - HDHNSFetchedResultsDelegate

- (void)didSelectRowData:(id)data {
    [FindOrderFormByAchievement startFindByAchievement:(Achievement *)data];
    [self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderFormTableView"]animated:YES];
}

- (void)configCellData:(id)data cell:(id)cell index:(NSIndexPath *)indexPath {
    AchievementTableViewCell *mCell = (AchievementTableViewCell *)cell;
    Achievement *achie = (Achievement *)data;
    mCell.target.text = achie.target;
    mCell.start.text = [StringUtil getDateFormatStringFrom8BitString:achie.startDate];
    mCell.end.text = [StringUtil getDateFormatStringFrom8BitString:achie.endDate];
    mCell.done.text = achie.total;
    mCell.doneRate.text = achie.rate;
    mCell.userName.text = [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"User" withPredicate:[NSPredicate predicateWithFormat:@"userId = %@", achie.userId]] lastObject] userName];
}

- (void)didLongPressRowData:(id)data {}

#pragma mark - simple method

- (void)configTableView {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isDelete == 'N'"];
    _mNSFetchedResultsController = [[HDHNSFetchedResultsController alloc] initWithTableView:_tableView];
    _mNSFetchedResultsController.hdhFetchedResultsController = [Achievement fetchedResultsControllerWithPredicate:predicate];
    _mNSFetchedResultsController.delegate = self;
    _mNSFetchedResultsController.reuseIndentifier = @"AchievementTableViewCell";
}

@end
