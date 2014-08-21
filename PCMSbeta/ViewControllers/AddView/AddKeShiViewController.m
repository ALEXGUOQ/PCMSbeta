//
//  AddKeShiViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-11.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "AddKeShiViewController.h"
#import "AlertTableViewCell.h"
#import "ManaSheBeiViewController.h"
/**
 *  # 新增或者修改科室
 */
@interface AddKeShiViewController () <HDHNSFetchedResultsDelegate> {
    UITableView *alertTableView;
    PXAlertView *alert;
    HDHNSFetchedResultsController *result;
    NSString *selectedCodeId;
}

@property (weak, nonatomic) IBOutlet UITextField *roomName;
@property (weak, nonatomic) IBOutlet UITextField *zhuRenName;
// tag == 2
@property (weak, nonatomic) IBOutlet UITextField *sex;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *income;
@property (weak, nonatomic) IBOutlet UITextField *remark;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *save;

@end

@implementation AddKeShiViewController

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
    if ([aNotification.object tag] == 2) {// sex
        alert = [PXAlertView showAlertWithTitle:nil message:nil cancelTitle:nil otherTitle:nil contentView:[self buildSexPickerTableView] completion:^(BOOL cancelled) {if(alert)alert = nil;
            [_sex resignFirstResponder];
            [_age becomeFirstResponder];
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
    _sex.text = code.codeName;
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
- (void)didLongPressRowData:(id)data {}

#pragma mark - Action
/**
 *  保存科室,科室名称不能为空
 *
 *  @param sender <#sender description#>
 */
- (IBAction)save:(UIBarButtonItem *)sender {
    if ([StringUtil isNull:_roomName.text]) {
        [ViewBuilder autoDismissAlertViewWithTitle:@"科室名称不能为空!" afterDelay:1.0f];
    } else {
        [self updateKeShi];
    }
}
/**
 *  相关业务按钮,点击弹窗
 *
 *  @param sender <#sender description#>
 */
- (IBAction)related:(UIButton *)sender {
    UIView *view = [[[ViewBuilder alloc] init] buttonListByTitles:@[@"科室设备"] viewWidth:120.0];
    for (UIButton *btn in view.subviews) {
        [btn addTarget:self action:@selector(tapButtonInButtonList:) forControlEvents:UIControlEventTouchUpInside];
    }
    alert = [PXAlertView showAlertWithTitle:nil message:nil cancelTitle:nil otherTitle:nil contentView:view completion:^(BOOL cancelled) {if(alert)alert = nil;}];
}

#pragma mark - relatedButtonList Button
/**
 *  相关业务按钮处理
 *
 *  @param sender <#sender description#>
 */
- (void)tapButtonInButtonList:(id)sender {
    [alert dismiss:sender];        
    ManaSheBeiViewController *clientUserList = (ManaSheBeiViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SheBeiTableView"];
    clientUserList.keShiId = _temp.roomId;
    clientUserList.userId = _temp.userId;
    [self.navigationController pushViewController:clientUserList animated:YES];
}

#pragma mark - simple method
/**
 *  设置视图编辑权限
 */
- (void)setViewContentEnabled {
    if (![_temp.userId isEqualToString:[[APP_DELEGATE currentUser] userId]]) {
        [ViewBuilder autoDismissAlertViewWithTitle:@"没有编辑权限" afterDelay:1.5f];
        [_save setEnabled:FALSE];
        [_roomName setEnabled:FALSE];
        [_zhuRenName setEnabled:FALSE];
        [_age setEnabled:FALSE];
        [_income setEnabled:FALSE];
        [_remark setEnabled:FALSE];
    }
}
/**
 *  性别选择器
 *
 *  @return 性别列表
 */
- (UIView *)buildSexPickerTableView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 100)];
    alertTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 120, 100)];
    [alertTableView setBackgroundColor:[UIColor clearColor]];
    [alertTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    result = [[HDHNSFetchedResultsController alloc] initWithTableView:alertTableView];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"codeTypeId == '1'"];
    result.hdhFetchedResultsController = [Code fetchedResultsControllerWithPredicate:predicate];
    result.delegate = self;
    result.reuseIndentifier = @"AlertTableViewCell";
    [view addSubview:alertTableView];
    return view;
}
/**
 *  更新(插入或修改)科室
 */
- (void)updateKeShi {
    ClientRoom *cr;
    if (_temp) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"roomId = %@",_temp.roomId];
        cr = (ClientRoom *)[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"ClientRoom" withPredicate:predicate] lastObject];
    } else {
        cr = (ClientRoom *)[CoreDataUtil createData:[(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] modelName:@"ClientRoom"];
        cr.createDateTime = [StringUtil get14BitDateStringFromDate:[NSDate date]];
        cr.roomId = [StringUtil createUUID];
        cr.clientId = _clientId;
    }
    cr.roomName = _roomName.text;
    cr.zhuRenName = _zhuRenName.text;
    if (selectedCodeId) {
        cr.sex = selectedCodeId;
    }
    cr.age = _age.text;
    cr.income = _income.text;
    
    cr.remark = _remark.text;
    cr.updateDateTime = [StringUtil get14BitDateStringFromDate:[NSDate date]];
    cr.isDelete = @"N";
    cr.lastOperatorId = [[APP_DELEGATE currentUser] userId];
    cr.userId = [[APP_DELEGATE currentUser] userId];
    NSError *error = nil;
    if (![MANAGED_OBJECT_CONTEXT save:&error]) {
        NSLog(@"sorry %@", [error localizedDescription]);
    } else {
        [ViewBuilder autoDismissAlertViewWithTitle:@"保存成功!" afterDelay:0.5f];
    }
    _temp = cr;
}
/**
 *  视图初始化
 */
- (void)configView {
    _roomName.text = _temp.roomName;
    _zhuRenName.text = _temp.zhuRenName;
    _sex.text = [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"Code" withPredicate:[NSPredicate predicateWithFormat:@"codeId = %@", _temp.sex]] lastObject] codeName];
    _age.text = _temp.age;
    _income.text = _temp.income;
    _remark.text = _temp.remark;
}

@end
