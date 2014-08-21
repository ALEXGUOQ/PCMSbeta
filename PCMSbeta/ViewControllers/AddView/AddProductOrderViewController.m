//
//  AddProductOrderViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-15.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "AddProductOrderViewController.h"
#import "ProductTableViewCell.h"
/**
 *  # 新增或者修改产品订单
 */
@interface AddProductOrderViewController () <HDHNSFetchedResultsDelegate,UITextFieldDelegate> {
    UIDatePicker *datePicker;
    NSMutableDictionary *productCount;
}

@property (weak, nonatomic) IBOutlet UITextField *clientName;
@property (weak, nonatomic) IBOutlet UITextField *date;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *save;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) HDHNSFetchedResultsController *mNSFetchedResultsController;

@end

@implementation AddProductOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configView];
    if (_temp) {
        [self setViewContentEnabled];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    productCount = [[NSMutableDictionary alloc] init];
    [self configTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showAlertWhenEditing:)
                                                 name:UITextFieldTextDidBeginEditingNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidBeginEditingNotification
                                                  object:nil];
}

#pragma mark - Action

- (IBAction)save:(UIBarButtonItem *)sender {
    [self updateProductOrder];
}


#pragma mark - Listener
/**
 *  实现点击TextField弹出选择列表
 *
 *  @param aNotification <#aNotification description#>
 */
- (void)showAlertWhenEditing:(NSNotification *)aNotification {
    if ([aNotification.object tag] == 0) {// workDate
        datePicker = [ViewBuilder datePickerByDateString:[_date.text  isEqual: @""] ? nil : [StringUtil get8BitDateStringFromFormatDateString:_date.text]];
        [PXAlertView showAlertWithTitle:nil message:nil cancelTitle:@"取消" otherTitle:@"确定" contentView:datePicker completion:^(BOOL cancelled) {
            if (!cancelled) {
                [_date setText:[StringUtil get8BitFormateDateString:datePicker.date]];
            }
            [_date resignFirstResponder];
        }];
    }
}

#pragma mark - HDHNSFetchedResultsDelegate
/**
 *  @see HDHNSFetchedResultsDelegate
 *
 *  @param data      <#data description#>
 *  @param cell      <#cell description#>
 *  @param indexPath <#indexPath description#>
 */
- (void)configCellData:(id)data cell:(id)cell index:(NSIndexPath *)indexPath {
    ProductTableViewCell *mCell = (ProductTableViewCell *)cell;
    Product *sheBei = (Product *)data;
    mCell.productName.text = sheBei.productName;
    mCell.standard.text = sheBei.standard;
    mCell.count.tag = (long)indexPath.row + 1;
    NSString *key = [NSString stringWithFormat:@"%@",sheBei.productId];
    NSDictionary *pro = [self getOrderInfoDicFromString:_temp.orderInfo];
    mCell.count.text = [pro valueForKey:key];
    [productCount setObject:mCell.count forKey:key];
}
/**
 *  @see HDHNSFetchedResultsDelegate
 *
 *  @param data <#data description#>
 */
- (void)didSelectRowData:(id)data {}
/**
 *  @see HDHNSFetchedResultsDelegate
 *
 *  @param data <#data description#>
 */
- (void)didLongPressRowData:(id)data {}

#pragma mark - UITextFieldDelegate
/**
 *  输入框键盘处理
 *
 *  @param textField <#textField description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - simple method
/**
 *  把orderInfo字符串转换为Dictionary对象
 *
 *  @param info 当前ProductOrder对象的orderInfo
 *
 *  @return NSDictionary
 */
- (NSDictionary *)getOrderInfoDicFromString:(NSString *)info {
    NSDictionary *productsDic = [[NSMutableDictionary alloc] init];
    if (![StringUtil isNull:info]) {
        NSArray *products = [info componentsSeparatedByString:@";;"];
        for (int i = 0; i < products.count; i++) {
            NSArray *arr = [products[i] componentsSeparatedByString:@",,"];
            NSString *key = [arr firstObject];
            NSString *value = [arr lastObject];
            [productsDic setValue:value forKey:key];
        }
    }
    return productsDic;
}
/**
 *  获得当前ProductOrder对象的orderInfo内容
 *
 *  @return NSString
 */
- (NSString *)getOrderInfo {
    NSMutableString *infoString = [[NSMutableString alloc] init];
    NSArray *productIds = productCount.allKeys;
    for (int i = 0; i < productIds.count; i ++) {
        NSString *productId = productIds[i];
        UITextField *textField = [productCount objectForKey:productId];
        NSString *value = textField.text;
        if (![value isEqualToString:@""]) {
            [infoString appendString:[NSString stringWithFormat:@"%@,,%@;;",productId,value]];
        }
    }
    if (![infoString isEqualToString:@""]) {
        return [infoString substringToIndex:infoString.length - 2];
    } else {
        return nil;
    }
}
/**
 *  更新(插入或修改)产品订单
 */
- (void)updateProductOrder {
    ProductOrder *po;
    if (_temp) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"productOrderId = %@",_temp.productOrderId];
        po = (ProductOrder *)[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"ProductOrder" withPredicate:predicate] lastObject];
    } else {
        po = (ProductOrder *)[CoreDataUtil createData:[(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] modelName:@"ProductOrder"];
        po.productOrderId = [StringUtil createUUID];
    }
    po.date = [StringUtil get8BitDateStringFromFormatDateString:_date.text];
    po.foreignkey = _foreignkey;
    po.orderInfo = [self getOrderInfo];
    
    po.updateDateTime = [StringUtil get14BitDateStringFromDate:[NSDate date]];
    po.isDelete = @"N";
    po.userId = [[APP_DELEGATE currentUser] userId];
    NSError *error = nil;
    if (![MANAGED_OBJECT_CONTEXT save:&error]) {
        NSLog(@"sorry %@", [error localizedDescription]);
    } else {
        [ViewBuilder autoDismissAlertViewWithTitle:@"保存成功!" afterDelay:0.5f];
    }
    _temp = po;
}
/**
 *  设置视图编辑权限
 */
- (void)setViewContentEnabled {
    if (![_temp.userId isEqualToString:[[APP_DELEGATE currentUser] userId]]) {
        [ViewBuilder autoDismissAlertViewWithTitle:@"没有编辑权限" afterDelay:1.5f];
        [_date setEnabled:NO];
        [_save setEnabled:NO];
        NSArray *textFields = [productCount allValues];
        for (UITextField *textField in textFields) {
            [textField setEnabled:NO];
        }
    }
}
/**
 *  视图初始化
 */
- (void)configView {
    _clientName.text = [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"Client" withPredicate:[NSPredicate predicateWithFormat:@"clientId = %@", _foreignkey]] lastObject] clientName];
    _userName.text = !_temp ? [[APP_DELEGATE currentUser] userName] : [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"User" withPredicate:[NSPredicate predicateWithFormat:@"userId = %@", _temp.userId]] lastObject] userName];
    _date.text = !_temp ? [StringUtil get8BitFormateDateString:[NSDate date]] : [StringUtil getDateFormatStringFrom8BitString:_temp.date];
}
/**
 *  产品列表初始化
 */
- (void)configTableView {
    _mNSFetchedResultsController = [[HDHNSFetchedResultsController alloc] initWithTableView:_tableView];
    _mNSFetchedResultsController.hdhFetchedResultsController = [Product fetchedResultsControllerWithPredicate:nil];
    _mNSFetchedResultsController.delegate = self;
    _mNSFetchedResultsController.reuseIndentifier = @"ProductTableViewCell";
}

@end
