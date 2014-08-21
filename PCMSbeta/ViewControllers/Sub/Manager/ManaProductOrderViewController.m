//
//  ManaProductOrderViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-15.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "ManaProductOrderViewController.h"
#import "ProductOrderTableViewCell.h"
#import "AddProductOrderViewController.h"
/**
 *  # 产品订单列表
 */
@interface ManaProductOrderViewController () <HDHNSFetchedResultsDelegate> {
    PXAlertView *alert;
    id longPressedRowData;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) HDHNSFetchedResultsController *mNSFetchedResultsController;

@end

@implementation ManaProductOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![_userId isEqualToString:[[APP_DELEGATE currentUser] userId]]) {
        [[self.navigationItem rightBarButtonItem] setEnabled:NO];
    }
    [self configTableView];
}

#pragma mark - simple method

- (void)configTableView {
    NSPredicate *predicate;
    if (_foreignkey) {
        predicate = [NSPredicate predicateWithFormat:@"isDelete == 'N' AND foreignkey = %@",_foreignkey];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"isDelete == 'N'"];
    }    _mNSFetchedResultsController = [[HDHNSFetchedResultsController alloc] initWithTableView:_tableView];
    _mNSFetchedResultsController.hdhFetchedResultsController = [ProductOrder fetchedResultsControllerWithPredicate:predicate];
    _mNSFetchedResultsController.delegate = self;
    _mNSFetchedResultsController.reuseIndentifier = @"ProductOrderTableViewCell";
}

#pragma mark - HDHNSFetchedResultsDelegate

- (void)configCellData:(id)data cell:(id)cell index:(NSIndexPath *)indexPath {
    ProductOrderTableViewCell *mCell = (ProductOrderTableViewCell *)cell;
    ProductOrder *of = (ProductOrder *)data;
    mCell.clientId.text = [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"Client" withPredicate:[NSPredicate predicateWithFormat:@"clientId = %@", of.foreignkey]] lastObject] clientName];
    mCell.userName.text = [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"User" withPredicate:[NSPredicate predicateWithFormat:@"userId = %@", of.userId]] lastObject] userName];
    mCell.date.text = [StringUtil getDateFormatStringFrom8BitString:of.date];
}

- (void)didSelectRowData:(id)data {
    AddProductOrderViewController *detail = (AddProductOrderViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddProductOrder"];
    detail.temp = (ProductOrder *)data;
    detail.foreignkey = _foreignkey;
    [self.navigationController pushViewController:detail animated:YES];
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
            ProductOrder *productOrder = (ProductOrder *)[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"ProductOrder" withPredicate:[NSPredicate predicateWithFormat:@"productOrderId = %@",[(ProductOrder *)longPressedRowData productOrderId]]] lastObject];
            productOrder.isDelete = @"Y";
            productOrder.updateDateTime = [StringUtil get14BitDateStringFromDate:[NSDate date]];
            NSError *error = nil;
            if (![MANAGED_OBJECT_CONTEXT save:&error]) {
                NSLog(@"sorry %@", [error localizedDescription]);
            } else {
                [ViewBuilder autoDismissAlertViewWithTitle:@"删除成功!" afterDelay:0.5f];
            }
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddProductOrder"]) {
        if (_foreignkey) {
            [(AddProductOrderViewController *)segue.destinationViewController setForeignkey:_foreignkey];
        }
    }
}

@end
