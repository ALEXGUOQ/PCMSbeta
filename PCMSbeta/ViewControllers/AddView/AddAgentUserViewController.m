//
//  AddAgentUserViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-8-11.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "AddAgentUserViewController.h"
#import "AlertTableViewCell.h"
/**
 *  # 新增或者修改代理商联系人
 */
@interface AddAgentUserViewController () <HDHNSFetchedResultsDelegate> {
    UIDatePicker *datePicker;
    UITableView *alertTableView;
    PXAlertView *alert;
    HDHNSFetchedResultsController *result;
    NSString *selectedCodeIdSex;
    NSString *selectedCodeIdScore;
}

@property (weak, nonatomic) IBOutlet UITextField *agentUserName;
@property (weak, nonatomic) IBOutlet UITextField *job;
// tag == 2
@property (weak, nonatomic) IBOutlet UITextField *sex;
@property (weak, nonatomic) IBOutlet UITextField *age;
// tag == 4
@property (weak, nonatomic) IBOutlet UITextField *entryDate;
// tag == 5
@property (weak, nonatomic) IBOutlet UITextField *score;
@property (weak, nonatomic) IBOutlet UITextField *email;
// tag == 7
@property (weak, nonatomic) IBOutlet UITextField *birthday;
@property (weak, nonatomic) IBOutlet UITextField *remark;
@property (weak, nonatomic) IBOutlet UITextField *reamrkOne;
@property (weak, nonatomic) IBOutlet UITextField *remarkTwo;
@property (weak, nonatomic) IBOutlet UITextField *remarkThree;
@property (weak, nonatomic) IBOutlet UITextField *phoneOne;
@property (weak, nonatomic) IBOutlet UITextField *phoneTwo;
@property (weak, nonatomic) IBOutlet UITextField *phoneThree;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *save;

@end

@implementation AddAgentUserViewController

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
    if ([aNotification.object tag] == 4) {// entryDate
        datePicker = [ViewBuilder datePickerByDateString:[_entryDate.text  isEqual: @""] ? nil : [StringUtil get8BitDateStringFromFormatDateString:_entryDate.text]];
        [PXAlertView showAlertWithTitle:nil message:nil cancelTitle:@"取消" otherTitle:@"确定" contentView:datePicker completion:^(BOOL cancelled) {
            if (!cancelled) {
                [_entryDate setText:[StringUtil get8BitFormateDateString:datePicker.date]];
            }
            [_entryDate resignFirstResponder];
        }];
    } else if ([aNotification.object tag] == 7){// birthday
        datePicker = [ViewBuilder datePickerByDateString:[_birthday.text  isEqual: @""] ? nil : [StringUtil get8BitDateStringFromFormatDateString:_birthday.text]];
        [PXAlertView showAlertWithTitle:nil message:nil cancelTitle:@"取消" otherTitle:@"确定" contentView:datePicker completion:^(BOOL cancelled) {
            if (!cancelled) {
                [_birthday setText:[StringUtil get8BitFormateDateString:datePicker.date]];
            }
            [_birthday resignFirstResponder];
        }];
    } else if ([aNotification.object tag] == 2){// sex
        
        alert = [PXAlertView showAlertWithTitle:nil message:nil cancelTitle:nil otherTitle:nil contentView:[self buildSexOrScorePickerTableViewByTag:@"sex"] completion:^(BOOL cancelled) {if(alert)alert = nil;
            [_sex resignFirstResponder];
        }];
    } else if ([aNotification.object tag] == 5){// score
        
        alert = [PXAlertView showAlertWithTitle:nil message:nil cancelTitle:nil otherTitle:nil contentView:[self buildSexOrScorePickerTableViewByTag:@"score"] completion:^(BOOL cancelled) {if(alert)alert = nil;
            [_score resignFirstResponder];
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
    if ([code.codeTypeId isEqualToString:@"1"]) {
        _sex.text = code.codeName;
        selectedCodeIdSex = code.codeId;
    } else if ([code.codeTypeId isEqualToString:@"4"]) {
        _score.text = code.codeName;
        selectedCodeIdScore = code.codeId;
    }
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
 *  保存代理商联系热,联系人姓名不能为空
 *
 *  @param sender <#sender description#>
 */
- (IBAction)save:(UIBarButtonItem *)sender {
    if ([StringUtil isNull:_agentUserName.text]) {
        [ViewBuilder autoDismissAlertViewWithTitle:@"联系人姓名不能为空!" afterDelay:1.0f];
    } else {
        [self updateAgentUser];
    }
}
/**
 *  打电话按钮处理,号码不能为空
 *
 *  @param sender <#sender description#>
 */
- (IBAction)call:(UIButton *)sender {
    switch (sender.tag) {
        case 110:
            if ([StringUtil isNull:_phoneOne.text]) {
                [ViewBuilder autoDismissAlertViewWithTitle:@"空号码!" afterDelay:0.5f];
            } else {
                [self makeCall:_phoneOne.text];
            }
            break;
        case 210:
            if ([StringUtil isNull:_phoneTwo.text]) {
                [ViewBuilder autoDismissAlertViewWithTitle:@"空号码!" afterDelay:0.5f];
            } else {
                [self makeCall:_phoneTwo.text];
            }
            break;
        case 310:
            if ([StringUtil isNull:_phoneThree.text]) {
                [ViewBuilder autoDismissAlertViewWithTitle:@"空号码!" afterDelay:0.5f];
            } else {
                [self makeCall:_phoneThree.text];
            }
            break;
        default:
            break;
    }
}
/**
 *  发短信按钮处理,号码不能为空
 *
 *  @param sender <#sender description#>
 */
- (IBAction)msg:(UIButton *)sender {
    switch (sender.tag) {
        case 111:
            if ([StringUtil isNull:_phoneOne.text]) {
                [ViewBuilder autoDismissAlertViewWithTitle:@"空号码!" afterDelay:0.5f];
            } else {
                [self sendMsg:_phoneOne.text];
            }
            break;
        case 211:
            if ([StringUtil isNull:_phoneTwo.text]) {
                [ViewBuilder autoDismissAlertViewWithTitle:@"空号码!" afterDelay:0.5f];
            } else {
                [self sendMsg:_phoneTwo.text];
            }
            break;
        case 311:
            if ([StringUtil isNull:_phoneThree.text]) {
                [ViewBuilder autoDismissAlertViewWithTitle:@"空号码!" afterDelay:0.5f];
            } else {
                [self sendMsg:_phoneThree.text];
            }
            break;
        default:
            break;
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
        [_agentUserName setEnabled:FALSE];
        [_job setEnabled:FALSE];
        [_sex setEnabled:FALSE];
        [_age setEnabled:FALSE];
        [_entryDate setEnabled:FALSE];
        [_email setEnabled:FALSE];
        [_birthday setEnabled:FALSE];
        [_score setEnabled:FALSE];
        [_remark setEnabled:FALSE];
        [_reamrkOne setEnabled:FALSE];
        [_remarkTwo setEnabled:FALSE];
        [_remarkThree setEnabled:FALSE];
        [_phoneOne setEnabled:FALSE];
        [_phoneTwo setEnabled:FALSE];
        [_phoneThree setEnabled:FALSE];
    }
}
/**
 *  评价或性别选择器
 *
 *  @param flag 评价:@"score",性别:@"sex"
 *
 *  @return 评价或性别列表
 */
- (UIView *)buildSexOrScorePickerTableViewByTag:(NSString *)flag {
    UIView *view;
    NSPredicate *predicate;
    if ([flag isEqualToString:@"sex"]) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 100)];
        alertTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 120, 100)];
        predicate = [NSPredicate predicateWithFormat:@"codeTypeId == '1'"];
    } else if ([flag isEqualToString:@"score"]) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 180)];
        alertTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 180)];
        predicate = [NSPredicate predicateWithFormat:@"codeTypeId == '4'"];
    }
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
 *  更新(插入或修改)代理商联系人
 */
- (void)updateAgentUser {
    AgentUser *au;
    if (_temp) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"agentUserId = %@",_temp.agentUserId];
        au = (AgentUser *)[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"AgentUser" withPredicate:predicate] lastObject];
    } else {
        au = (AgentUser *)[CoreDataUtil createData:[(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] modelName:@"AgentUser"];
        au.createDateTime = [StringUtil get14BitDateStringFromDate:[NSDate date]];
        au.agentUserId = [StringUtil createUUID];
        au.agentId = _agentId;
    }
    au.agentUserName = _agentUserName.text;
    au.job = _job.text;
    if (selectedCodeIdSex) {
        au.sex = selectedCodeIdSex;
    }
    au.age = _age.text;
    au.entryDate = [StringUtil get8BitDateStringFromFormatDateString:_entryDate.text];
    if (selectedCodeIdScore) {
        au.score = selectedCodeIdScore;
    }
    au.email = _email.text;
    au.birthday = [StringUtil get8BitDateStringFromFormatDateString:_birthday.text];
    au.remarkOne = _reamrkOne.text;
    au.remarkTwo = _remarkTwo.text;
    au.remarkThree = _remarkThree.text;
    au.phoneOne = _phoneOne.text;
    au.phoneTwo = _phoneTwo.text;
    au.phoneThree = _phoneThree.text;
    
    au.remark = _remark.text;
    au.updateDateTime = [StringUtil get14BitDateStringFromDate:[NSDate date]];
    au.isDelete = @"N";
    au.lastOperatorId = [[APP_DELEGATE currentUser] userId];
    au.userId = [[APP_DELEGATE currentUser] userId];
    NSError *error = nil;
    if (![MANAGED_OBJECT_CONTEXT save:&error]) {
        NSLog(@"sorry %@", [error localizedDescription]);
    } else {
        [ViewBuilder autoDismissAlertViewWithTitle:@"保存成功!" afterDelay:0.5f];
    }
    _temp = au;
}
/**
 *  视图初始化
 */
- (void)configView {
    _agentUserName.text = _temp.agentUserName;
    _job.text = _temp.job;
    _sex.text = [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"Code" withPredicate:[NSPredicate predicateWithFormat:@"codeId = %@", _temp.sex]] lastObject] codeName];
    _age.text = _temp.age;
    _entryDate.text = [StringUtil getDateFormatStringFrom8BitString:_temp.entryDate];
    _score.text = [[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"Code" withPredicate:[NSPredicate predicateWithFormat:@"codeId = %@", _temp.score]] lastObject] codeName];
    _email.text = _temp.email;
    _birthday.text = [StringUtil getDateFormatStringFrom8BitString:_temp.birthday];
    _remark.text = _temp.remark;
    _reamrkOne.text = _temp.remarkOne;
    _remarkTwo.text = _temp.remarkTwo;
    _remarkThree.text = _temp.remarkThree;
    _phoneOne.text = _temp.phoneOne;
    _phoneTwo.text = _temp.phoneTwo;
    _phoneThree.text = _temp.phoneThree;
}
/**
 *  调用打电话,不返回应用
 *
 *  @param number 号码
 */
- (void)makeCall:(NSString *)number {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",number]]];
}
/**
 *  调用发短信,不返回应用
 *
 *  @param number 号码
 */
- (void)sendMsg :(NSString *)number {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",number]]];
}

@end
