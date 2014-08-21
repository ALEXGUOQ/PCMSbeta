//
//  AddAgentViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-7-31.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "AddAgentViewController.h"
#import "ManaAgentUserViewController.h"
#import "ManaTaskViewController.h"
#import "AlertTableViewCell.h"
/**
 *  # 新增或者修改代理商
 */
@interface AddAgentViewController () <HDHNSFetchedResultsDelegate> {
    MyAreaPickerView *areaPickerView;
    NSString *selectedProvinceCode;
    NSString *selectedCityCode;
    PXAlertView *alert;
    NSString *selectedCodeIdScore;
    UITableView *alertTableView;
    HDHNSFetchedResultsController *result;
}

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *agentName;
//tag = 2
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *street;
@property (weak, nonatomic) IBOutlet UITextField *businessType;
@property (weak, nonatomic) IBOutlet UITextField *count;
@property (weak, nonatomic) IBOutlet UITextField *registerCapital;
@property (weak, nonatomic) IBOutlet UITextField *clientGroup;
//tag = 8
@property (weak, nonatomic) IBOutlet UITextField *score;
@property (weak, nonatomic) IBOutlet UITextField *remark;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *save;

@end

@implementation AddAgentViewController

#pragma mark - lyfeCyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configView];
    if (_temp) {
        [self setViewContentEnabled];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showAlertWhenEditing:)
                                                 name:UITextFieldTextDidBeginEditingNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
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
    
    if ([aNotification.object tag] == 2) {// city
        [PXAlertView showAlertWithTitle:nil message:nil cancelTitle:@"取消" otherTitle:@"确定" contentView:areaPickerView completion:^(BOOL cancelled) {
            if (!cancelled) {
                _city.text = [areaPickerView selectedAreaName];
                selectedCityCode = [areaPickerView selectedCityCode];
                selectedProvinceCode = [areaPickerView selectedProvinceCode];
            }
            [_city resignFirstResponder];
        }];
    } else if ([aNotification.object tag] == 8) {// score
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
 *  保存代理商,代理商名称不能为空
 *
 *  @param sender <#sender description#>
 */
- (IBAction)save:(UIBarButtonItem *)sender {
    if ([StringUtil isNull:_agentName.text]) {
        [ViewBuilder autoDismissAlertViewWithTitle:@"代理商名称不能为空!" afterDelay:1.0f];
    } else {
        [self updateAgent];
    }
}
/**
 *  相关业务按钮,点击弹窗
 *
 *  @param sender <#sender description#>
 */
- (IBAction)related:(UIButton *)sender {
    UIView *view = [[[ViewBuilder alloc] init] buttonListByTitles:@[@"联系人",@"相关任务"] viewWidth:120.0];
    for (UIButton *btn in view.subviews) {
        [btn addTarget:self action:@selector(tapButtonInButtonList:) forControlEvents:UIControlEventTouchUpInside];
    }
    alert = [PXAlertView showAlertWithTitle:nil message:nil cancelTitle:nil otherTitle:nil contentView:view completion:^(BOOL cancelled) {if(alert)alert = nil;}];
}

#pragma mark - relatedButtonList Button
/**
 *  弹窗处理
 *
 *  @param sender <#sender description#>
 */
- (void)tapButtonInButtonList:(id)sender {
    [alert dismiss:sender];
    if ([(UIButton *)sender tag] == 0) {
        ManaAgentUserViewController *agentUserList = (ManaAgentUserViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AgentUserTableView"];
        agentUserList.agentId = _temp.agentId;
        agentUserList.userId = _temp.userId;
        [self.navigationController pushViewController:agentUserList animated:YES];
    } else if ([(UIButton *)sender tag] == 1) {
        ManaTaskViewController *taskList = (ManaTaskViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TaskTableView"];
        taskList.agentId = _temp.agentId;
        taskList.userId = _temp.userId;
        [self.navigationController pushViewController:taskList animated:YES];
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
        [_agentName setEnabled:FALSE];
        [_city setEnabled:FALSE];
        [_street setEnabled:FALSE];
        [_businessType setEnabled:FALSE];
        [_count setEnabled:FALSE];
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
    _userName.text = [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"User" withPredicate:[NSPredicate predicateWithFormat:@"userId = %@", _temp.userId]] lastObject] userName];
    _agentName.text = _temp.agentName;
    _city.text = [areaPickerView getAreaNameWithProvinceCode:_temp.proviceId andCityCode:_temp.cityId];
    _street.text = _temp.address;
    _businessType.text = _temp.businessType;
    _count.text = _temp.count;
    _clientGroup.text = _temp.clientGroup;
    _registerCapital.text = _temp.registerCapital;
    _score.text = [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"Code" withPredicate:[NSPredicate predicateWithFormat:@"codeId = %@", _temp.score]] lastObject] codeName];
    _remark.text = _temp.remark;
}
/**
 *  更新(插入或修改)代理商
 */
- (void)updateAgent {
    Agent *ag;
    if (_temp) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"agentId = %@",_temp.agentId];
        ag = (Agent *)[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"Agent" withPredicate:predicate] lastObject];
    } else {
        ag = (Agent *)[CoreDataUtil createData:[(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] modelName:@"Agent"];
        ag.agentId = [StringUtil createUUID];
        ag.createDateTime = [StringUtil get14BitDateStringFromDate:[NSDate date]] ;
    }
    if (selectedCityCode) {
        ag.cityId = selectedCityCode;
        ag.proviceId = selectedProvinceCode;
    }
    ag.agentName = _agentName.text;
    ag.address = _street.text;
    ag.businessType = _businessType.text;
    ag.count = _count.text;
    ag.registerCapital = _registerCapital.text;
    ag.clientGroup = _clientGroup.text;
    if (selectedCodeIdScore) {
        ag.score = selectedCodeIdScore;
    }
    ag.remark = _remark.text;
    ag.updateDateTime = [StringUtil get14BitDateStringFromDate:[NSDate date]];
    ag.isDelete = @"N";
    ag.lastOperatorId = [[APP_DELEGATE currentUser] userId];
    ag.userId = [[APP_DELEGATE currentUser] userId];
    NSError *error = nil;
    if (![MANAGED_OBJECT_CONTEXT save:&error]) {
        NSLog(@"sorry %@", [error localizedDescription]);
    } else {
        [ViewBuilder autoDismissAlertViewWithTitle:@"保存成功!" afterDelay:0.5f];
    }
    _temp = ag;
}

@end
