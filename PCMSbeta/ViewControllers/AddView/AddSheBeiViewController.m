//
//  AddSheBeiViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-11.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "AddSheBeiViewController.h"
#import "AlertTableViewCell.h"
/**
 *  # 新增或者修改科室设备
 */
@interface AddSheBeiViewController () <HDHNSFetchedResultsDelegate> {
    UIDatePicker *datePicker;
    UITableView *alertTableView;
    PXAlertView *alert;
    HDHNSFetchedResultsController *result;
    NSString *selectedCodeId;
}

// tag == 0
@property (weak, nonatomic) IBOutlet UITextField *type;
@property (weak, nonatomic) IBOutlet UITextField *count;
@property (weak, nonatomic) IBOutlet UITextField *brand;
@property (weak, nonatomic) IBOutlet UITextField *version;
// tag == 4
@property (weak, nonatomic) IBOutlet UITextField *buyDate;
@property (weak, nonatomic) IBOutlet UITextField *salCompanyName;
@property (weak, nonatomic) IBOutlet UITextField *useState;
@property (weak, nonatomic) IBOutlet UITextField *dayCheckCount;
@property (weak, nonatomic) IBOutlet UITextField *remark;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *save;

@end

@implementation AddSheBeiViewController

#pragma mark - lyfeCyle

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

#pragma mark - Listener
/**
 *  实现点击TextField弹出选择列表
 *
 *  @param aNotification <#aNotification description#>
 */
- (void)showAlertWhenEditing:(NSNotification *)aNotification {
    if ([aNotification.object tag] == 4) {// buyDate
        datePicker = [ViewBuilder datePickerByDateString:[_buyDate.text  isEqual: @""] ? nil : [StringUtil get8BitDateStringFromFormatDateString:_buyDate.text]];
        [PXAlertView showAlertWithTitle:nil message:nil cancelTitle:@"取消" otherTitle:@"确定" contentView:datePicker completion:^(BOOL cancelled) {
            if (!cancelled) {
                [_buyDate setText:[StringUtil get8BitFormateDateString:datePicker.date]];
            }
            [_buyDate resignFirstResponder];
            [_count becomeFirstResponder];
        }];
    } else if ([aNotification.object tag] == 0){// type
        alert = [PXAlertView showAlertWithTitle:nil message:nil cancelTitle:nil otherTitle:nil contentView:[self buildTypePickerTableView] completion:^(BOOL cancelled) {if(alert)alert = nil;
            [_type resignFirstResponder];
            [_count becomeFirstResponder];
        }];
    }
}

#pragma mark - HDHNSFetchedResultsDelegate
/**
 *  @see HDHNSFetchedResultsDelegate
 *
 *  @param data <#data description#>
 */
- (void)didSelectRowData:(id)data {
    [alert dismiss:[[UIButton alloc] init]];
    Code *code = (Code *)data;
    _type.text = code.codeName;
    selectedCodeId = code.codeId;
}
/**
 *  @see HDHNSFetchedResultsDelegate
 *
 *  @param data      <#data description#>
 *  @param cell      <#cell description#>
 *  @param indexPath <#indexPath description#>
 */
- (void)configCellData:(id)data cell:(id)cell index:(NSIndexPath *)indexPath {
    AlertTableViewCell *aCell = (AlertTableViewCell *)cell;
    Code *code = (Code *)data;
    aCell.textLabel.text = code.codeName;
}
/**
 *  @see HDHNSFetchedResultsDelegate
 *
 *  @param data <#data description#>
 */
- (void)didLongPressRowData:(id)data{}

#pragma mark - Action
/**
 *  保存科室设备,科室设备的类型不能为空
 *
 *  @param sender <#sender description#>
 */
- (IBAction)save:(UIBarButtonItem *)sender {
    if ([StringUtil isNull:_type.text]) {
        [ViewBuilder autoDismissAlertViewWithTitle:@"设备类型不能为空!" afterDelay:1.0f];
    } else {
        [self updateSheBei];
    }
}

#pragma mark - simple method
/**
 *  设置视图编辑权限
 */
- (void)setViewContentEnabled {
    if (![_temp.userId isEqualToString:[[APP_DELEGATE currentUser] userId]]) {
        [ViewBuilder autoDismissAlertViewWithTitle:@"没有编辑权限" afterDelay:1.5f];
        [_save setEnabled:FALSE];
        [_count setEnabled:FALSE];
        [_brand setEnabled:FALSE];
        [_version setEnabled:FALSE];
        [_buyDate setEnabled:FALSE];
        [_salCompanyName setEnabled:FALSE];
        [_useState setEnabled:FALSE];
        [_dayCheckCount setEnabled:FALSE];
        [_remark setEnabled:FALSE];
    }
}
/**
 *  设备类型选择器
 *
 *  @return 设备类型列表
 */
- (UIView *)buildTypePickerTableView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 300)];
    alertTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 130, 300)];
    [alertTableView setBackgroundColor:[UIColor clearColor]];
    [alertTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    result = [[HDHNSFetchedResultsController alloc] initWithTableView:alertTableView];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"codeTypeId == '2'"];
    result.hdhFetchedResultsController = [Code fetchedResultsControllerWithPredicate:predicate];
    result.delegate = self;
    result.reuseIndentifier = @"AlertTableViewCell";
    [view addSubview:alertTableView];
    return view;
}
/**
 *  更新(插入或修改)科室设备
 */
- (void)updateSheBei {
    ClientRoomDevice *crd;
    if (_temp) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"deviceId = %@",_temp.deviceId];
        crd = (ClientRoomDevice *)[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"ClientRoomDevice" withPredicate:predicate] lastObject];
    } else {
        crd = (ClientRoomDevice *)[CoreDataUtil createData:[(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] modelName:@"ClientRoomDevice"];
        crd.createDateTime = [StringUtil get14BitDateStringFromDate:[NSDate date]];
        crd.deviceId = [StringUtil createUUID];
        crd.roomId = _roomId;
    }
    if (selectedCodeId) {
        crd.type = selectedCodeId;
    }
    crd.count = _count.text;
    crd.brand = _brand.text;
    crd.version = _version.text;
    crd.buyDate = [StringUtil get8BitDateStringFromFormatDateString:_buyDate.text];
    crd.saleCompanyName = _salCompanyName.text;
    crd.useState = _useState.text;
    crd.dayCheckCount = _dayCheckCount.text;
    
    crd.remark = _remark.text;
    crd.updateDateTime = [StringUtil get14BitDateStringFromDate:[NSDate date]];
    crd.isDelete = @"N";
    crd.lastOperatorId = [[APP_DELEGATE currentUser] userId];
    crd.userId = [[APP_DELEGATE currentUser] userId];
    NSError *error = nil;
    if (![MANAGED_OBJECT_CONTEXT save:&error]) {
        NSLog(@"sorry %@", [error localizedDescription]);
    } else {
        [ViewBuilder autoDismissAlertViewWithTitle:@"保存成功!" afterDelay:0.5f];
    }
    _temp = crd;
}
/**
 *  视图初始化
 */
- (void)configView {
    _type.text = [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"Code" withPredicate:[NSPredicate predicateWithFormat:@"codeId = %@", _temp.type]] lastObject] codeName];
    _count.text = _temp.count;
    _brand.text = _temp.brand;
    _version.text = _temp.version;
    _buyDate.text = [StringUtil getDateFormatStringFrom8BitString:_temp.buyDate];
    _salCompanyName.text = _temp.saleCompanyName;
    _useState.text = _temp.useState;
    _dayCheckCount.text = _temp.dayCheckCount;
    _remark.text = _temp.remark;
}

@end
