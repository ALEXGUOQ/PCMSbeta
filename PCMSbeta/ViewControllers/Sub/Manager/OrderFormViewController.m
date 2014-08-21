//
//  OrderFormViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-15.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "OrderFormViewController.h"
#import "OrderFormTableViewCell.h"

@interface OrderFormViewController () <HDHNSFetchedResultsDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) HDHNSFetchedResultsController *mNSFetchedResultsController;
@end

@implementation OrderFormViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configTableView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [CoreDataUtil deleteModel:MANAGED_OBJECT_CONTEXT modelName:@"OrderForm"];
}

#pragma mark - simple method

- (void)configTableView {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isDelete == 'N'"];
    _mNSFetchedResultsController = [[HDHNSFetchedResultsController alloc] initWithTableView:_tableView];
    _mNSFetchedResultsController.hdhFetchedResultsController = [OrderForm fetchedResultsControllerWithPredicate:predicate];
    _mNSFetchedResultsController.delegate = self;
    _mNSFetchedResultsController.reuseIndentifier = @"OrderFormTableViewCell";
}

#pragma mark - HDHNSFetchedResultsDelegate

- (void)configCellData:(id)data cell:(id)cell index:(NSIndexPath *)indexPath {
    OrderFormTableViewCell *mCell = (OrderFormTableViewCell *)cell;
    OrderForm *of = (OrderForm *)data;
    mCell.companyName.text = of.companyName;
    mCell.userName.text = [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"User" withPredicate:[NSPredicate predicateWithFormat:@"userId = %@", of.userId]] lastObject] userName];
    mCell.money.text = of.money;
    mCell.date.text = [StringUtil getDateFormatStringFrom8BitString:of.date];
    mCell.deScription.text = of.deScription;
    mCell.remark.text = of.remark;
}

- (void)didSelectRowData:(id)data {}

- (void)didLongPressRowData:(id)data {}

@end
