//
//  AddClientViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-7-31.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "AddClientViewController.h"
#import "MyAreaPickerView.h"
#import "ManaTaskViewController.h"
#import "ManaClientUserViewController.h"
#import "ManaKeShiViewController.h"
#import "ManaProductOrderViewController.h"
#import "AlertTableViewCell.h"
/**
 *  # 新增或者修改医院
 */
@interface AddClientViewController () <HDHNSFetchedResultsDelegate> {
    MyAreaPickerView *areaPickerView;
    NSString *selectedProvinceCode;
    NSString *selectedCityCode;
    PXAlertView *alert;
    NSString *selectedCodeIdScore;
    UITableView *alertTableView;
    HDHNSFetchedResultsController *result;
}
/**
 *  医院名称
 */
@property (weak, nonatomic) IBOutlet UITextField *clientName;
//tag = 1
/**
 *  所在城市
 */
@property (weak, nonatomic) IBOutlet UITextField *city;
/**
 *  街道(具体地址)
 */
@property (weak, nonatomic) IBOutlet UITextField *street;
/**
 *  医院等级
 */
@property (weak, nonatomic) IBOutlet UITextField *clientRate;
/**
 *  财务状况
 */
@property (weak, nonatomic) IBOutlet UITextField *finance;
/**
 *  年收入
 */
@property (weak, nonatomic) IBOutlet UITextField *income;
/**
 *  日检查量
 */
@property (weak, nonatomic) IBOutlet UITextField *dayCount;
/**
 *  床位数
 */
@property (weak, nonatomic) IBOutlet UITextField *bedCount;
/**
 *  特色科室
 */
@property (weak, nonatomic) IBOutlet UITextField *teSeKeShi;
/**
 *  营业额
 */
@property (weak, nonatomic) IBOutlet UITextField *turnover;
/**
 *  客户群
 */
@property (weak, nonatomic) IBOutlet UITextField *clientGroup;
/**
 *  注册资本
 */
@property (weak, nonatomic) IBOutlet UITextField *registerCapital;
//tag = 12
/**
 *  评价(查询Code表)
 */
@property (weak, nonatomic) IBOutlet UITextField *score;
/**
 *  备注
 */
@property (weak, nonatomic) IBOutlet UITextField *remark;
/**
 *  保存按钮
 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *save;

@end

@implementation AddClientViewController

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
- (void)showAlertWhenEditing:(NSNotification *)aNotification{
    
    if ([aNotification.object tag] == 1) {// city
        [PXAlertView showAlertWithTitle:nil message:nil cancelTitle:@"取消" otherTitle:@"确定" contentView:areaPickerView completion:^(BOOL cancelled) {
            if (!cancelled) {
                _city.text = [areaPickerView selectedAreaName];
                selectedCityCode = [areaPickerView selectedCityCode];
                selectedProvinceCode = [areaPickerView selectedProvinceCode];
            }
            [_city resignFirstResponder];
            [_street becomeFirstResponder];
        }];
    } else if ([aNotification.object tag] == 12){// score
        alert = [PXAlertView showAlertWithTitle:nil message:nil cancelTitle:nil otherTitle:nil contentView:[self buildScorePickerTableView] completion:^(BOOL cancelled) {if(alert)alert = nil;
            [_score resignFirstResponder];
            [_remark becomeFirstResponder];
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
    _score.text = code.codeName;
    selectedCodeIdScore = code.codeId;
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
 *  保存医院对象,医院名称不能为空
 *
 *  @param sender <#sender description#>
 */
- (IBAction)save:(UIBarButtonItem *)sender {
    if ([StringUtil isNull:_clientName.text]) {
        [ViewBuilder autoDismissAlertViewWithTitle:@"医院名称不能为空!" afterDelay:1.0f];
    } else {
        [self updateClient];
    }
}
/**
 *  相关业务按钮,点击弹窗
 *
 *  @param sender <#sender description#>
 */
- (IBAction)related:(UIButton *)sender {
    UIView *view = [[[ViewBuilder alloc] init] buttonListByTitles:@[@"联系人",@"科室",@"相关任务",@"相关订单"] viewWidth:120.0];
    for (UIButton *btn in view.subviews) {
        [btn addTarget:self action:@selector(tapButtonInButtonList:) forControlEvents:UIControlEventTouchUpInside];
    }
    alert = [PXAlertView showAlertWithTitle:nil message:nil cancelTitle:nil otherTitle:nil contentView:view completion:^(BOOL cancelled) {if(alert)alert = nil;}];
}

#pragma mark - relatedButtonList Button
/**
 *  相关弹窗按钮处理
 *
 *  @param sender <#sender description#>
 */
- (void)tapButtonInButtonList:(id)sender {
    [alert dismiss:sender];
    if ([(UIButton *)sender tag] == 0) {
        
        ManaClientUserViewController *clientUserList = (ManaClientUserViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ClientUserTableView"];
        clientUserList.clientId = _temp.clientId;
        clientUserList.userId = _temp.userId;
        [self.navigationController pushViewController:clientUserList animated:YES];
        
    } else if ([(UIButton *)sender tag] == 1) {
        
        ManaKeShiViewController *keShiList = (ManaKeShiViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"KeShiTableView"];
        keShiList.clientId = _temp.clientId;
        keShiList.userId = _temp.userId;
        [self.navigationController pushViewController:keShiList animated:YES];
        
    } else if ([(UIButton *)sender tag] == 2) {
        
        ManaTaskViewController *taskList = (ManaTaskViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TaskTableView"];
        taskList.clientId = _temp.clientId;
        taskList.userId = _temp.userId;
        [self.navigationController pushViewController:taskList animated:YES];
        
    } else if ([(UIButton *)sender tag] == 3) {
        ManaProductOrderViewController *productOrderList = (ManaProductOrderViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductOrderTableView"];
        productOrderList.foreignkey = _temp.clientId;
        productOrderList.userId = _temp.userId;
        [self.navigationController pushViewController:productOrderList animated:YES];
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
        [_clientName setEnabled:FALSE];
        [_city setEnabled:FALSE];
        [_street setEnabled:FALSE];
        [_clientRate setEnabled:FALSE];
        [_finance setEnabled:FALSE];
        [_income setEnabled:FALSE];
        [_dayCount setEnabled:FALSE];
        [_bedCount setEnabled:FALSE];
        [_teSeKeShi setEnabled:FALSE];
        [_turnover setEnabled:FALSE];
        [_clientGroup setEnabled:FALSE];
        [_registerCapital setEnabled:FALSE];
        [_score setEnabled:FALSE];
        [_remark setEnabled:FALSE];
    }
}
/**
 *  评价选择器
 *
 *  @return 评价列表
 */
- (UIView *)buildScorePickerTableView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 180)];
    alertTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 180)];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"codeTypeId == '4'"];
    [alertTableView setBackgroundColor:[UIColor clearColor]];
    [alertTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    result = [[HDHNSFetchedResultsController alloc] initWithTableView:alertTableView];
    result.hdhFetchedResultsController = [Code fetchedResultsControllerWithPredicate:predicate];
    result.delegate = self;
    result.reuseIndentifier = @"AlertTableViewCell";
    [view addSubview:alertTableView];
    return view;
}
/**
 *  视图初始化
 */
- (void)configView {
    areaPickerView = [ViewBuilder areaPickerView];
    _clientName.text = _temp.clientName;
    _city.text = [areaPickerView getAreaNameWithProvinceCode:_temp.provinceId andCityCode:_temp.cityId];
    _street.text = _temp.address;
    _clientRate.text = _temp.levelRate;
    _income.text = _temp.income;
    _turnover.text = _temp.turnover;
    _dayCount.text = _temp.dayCount;
    _bedCount.text = _temp.bedCount;
    _teSeKeShi.text = _temp.teSeKeShi;
    _finance.text = _temp.finance;
    _clientGroup.text = _temp.clientGroup;
    _registerCapital.text = _temp.registerCapital;
    _score.text = [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"Code" withPredicate:[NSPredicate predicateWithFormat:@"codeId = %@", _temp.score]] lastObject] codeName];
    _remark.text = _temp.remark;
}
/**
 *  更新(插入或修改)医院记录
 */
- (void)updateClient {
    Client *cl;
    if (_temp) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"clientId = %@",_temp.clientId];
        cl = (Client *)[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"Client" withPredicate:predicate] lastObject];
    } else {
        cl = (Client *)[CoreDataUtil createData:[(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] modelName:@"Client"];
        cl.createDateTime =[StringUtil get14BitDateStringFromDate:[NSDate date]];
        cl.clientId = [StringUtil createUUID];
    }
    if (selectedCityCode) {
        cl.cityId = selectedCityCode;
        cl.provinceId = selectedProvinceCode;
    }
    cl.clientName = _clientName.text;
    cl.address = _street.text;
    cl.levelRate = _clientRate.text;
    cl.finance = _finance.text;
    cl.income = _income.text;
    cl.dayCount = _dayCount.text;
    cl.bedCount = _bedCount.text;
    cl.teSeKeShi = _teSeKeShi.text;
    cl.turnover = _turnover.text;
    cl.clientGroup = _clientGroup.text;
    cl.registerCapital = _registerCapital.text;
    cl.score = selectedCodeIdScore;
    cl.remark = _remark.text;
    cl.updateDateTime = [StringUtil get14BitDateStringFromDate:[NSDate date]];
    cl.isDelete = @"N";
    cl.lastOperatorId = [[APP_DELEGATE currentUser] userId];
    cl.userId = [[APP_DELEGATE currentUser] userId];
    NSError *error = nil;
    if (![MANAGED_OBJECT_CONTEXT save:&error]) {
        NSLog(@"sorry %@", [error localizedDescription]);
    } else {
        [ViewBuilder autoDismissAlertViewWithTitle:@"保存成功!" afterDelay:0.5f];
    }
    _temp = cl;
}

@end
