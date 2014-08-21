//
//  RegisterViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-7-28.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "RegisterViewController.h"
#import "AlertTableViewCell.h"
/**
 *  # 用户注册
 */
@interface RegisterViewController () <HDHNSFetchedResultsDelegate> {
    UIDatePicker *datePicker;
    UITableView *alertTableView;
    PXAlertView *alert;
    HDHNSFetchedResultsController *result;
    NSString *selectedCompanyId;
    NSString *selectedCodeIdSex;
}
/**
 *  用户名
 */
@property (weak, nonatomic) IBOutlet UITextField *userId;
/**
 *  密码
 */
@property (weak, nonatomic) IBOutlet UITextField *password;
/**
 *  确认密码
 */
@property (weak, nonatomic) IBOutlet UITextField *confirmedPassword;
/**
 *  真实姓名
 */
@property (weak, nonatomic) IBOutlet UITextField *realName;
//tag=4
/**
 *  生日
 */
@property (weak, nonatomic) IBOutlet UITextField *birthday;
//tag=5
/**
 *  公司名称(查询Company)
 */
@property (weak, nonatomic) IBOutlet UITextField *companyId;
//tag=6
/**
 *  性别(查询Code)
 */
@property (weak, nonatomic) IBOutlet UITextField *sex;
/**
 *  电话号码
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneNo;
/**
 *  邮箱
 */
@property (weak, nonatomic) IBOutlet UITextField *email;

@end

@implementation RegisterViewController

#pragma mark - lyfeCycle

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

#pragma mark - Action
/**
 *  若用户取消注册,则返回登录界面
 */
- (IBAction)registCancel {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
/**
 *  `validateInputInfo`验证用户输入,`checkUserIdIsExsistFromServer`访问服务器检查用户名是否存在
 */
- (IBAction)registSubmit {
    if ([self validateInputInfo]) {
        [self checkUserIdIsExsistFromServer];
    }
}

#pragma mark - Listener
/**
 *  输入框弹窗
 *
 *  @param aNotification <#aNotification description#>
 */
- (void)showAlertWhenEditing:(NSNotification *)aNotification{
    
    if ([aNotification.object tag] == 4) {// birthday
        datePicker = [ViewBuilder datePickerByDateString:[_birthday.text  isEqual: @""] ? nil : [StringUtil get8BitDateStringFromFormatDateString:_birthday.text]];
        [PXAlertView showAlertWithTitle:nil message:nil cancelTitle:@"取消" otherTitle:@"确定" contentView:datePicker completion:^(BOOL cancelled) {
            if (!cancelled) {
                [_birthday setText:[StringUtil get8BitFormateDateString:datePicker.date]];
            }
            [_birthday resignFirstResponder];
        }];
    } else if ([aNotification.object tag] == 5){// companyId
        alert = [PXAlertView showAlertWithTitle:nil message:nil cancelTitle:nil otherTitle:nil contentView:[self buildCompanyPickerTableView] completion:^(BOOL cancelled) {if(alert)alert = nil;
            [_companyId resignFirstResponder];
        }];
    } else if ([aNotification.object tag] == 6){// sex
        alert = [PXAlertView showAlertWithTitle:nil message:nil cancelTitle:nil otherTitle:nil contentView:[self buildSexPickerTableView] completion:^(BOOL cancelled) {if(alert)alert = nil;
            [_sex resignFirstResponder];
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
    if ([data isKindOfClass:[Company class]]) {
        Company *company = (Company *)data;
        _companyId.text = company.name;
        selectedCompanyId = company.companyId;
    } else if ([data isKindOfClass:[Code class]]) {
        Code *code = (Code *)data;
        _sex.text = code.codeName;
        selectedCodeIdSex = code.codeId;
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
    if ([data isKindOfClass:[Company class]]) {
        Company *company = (Company *)data;
        aCell.textLabel.text = company.name;
    } else if ([data isKindOfClass:[Code class]]) {
        Code *code = (Code *)data;
        aCell.textLabel.text = code.codeName;
    }
}
/**
 *  @see HDHNSFetchedResultsDelegate
 *
 *  @param data <#data description#>
 */
- (void)didLongPressRowData:(id)data {}

#pragma mark - simple method
/**
 *  用户必须输入所有的项
 *
 *  @return <#return value description#>
 */
- (BOOL)validateInputInfo {
    if ([StringUtil isNull:_userId.text]|[StringUtil isNull:_password.text]|[StringUtil isNull:_confirmedPassword.text]|[StringUtil isNull:_realName.text]|[StringUtil isNull:_birthday.text]|[StringUtil isNull:_companyId.text]|[StringUtil isNull:_sex.text]|[StringUtil isNull:_phoneNo.text]|[StringUtil isNull:_email.text]) {
        [ViewBuilder autoDismissAlertViewWithTitle:@"必须填写所有的项!" afterDelay:1.0];
        return NO;
    } else {
        if ([_password.text isEqualToString:_confirmedPassword.text]) {
            return YES;
        } else {
            [ViewBuilder autoDismissAlertViewWithTitle:@"两次输入的密码不匹配,请重新输入!" afterDelay:1.0];
            return NO;
        }
    }
}
/**
 *  创建一个User对象
 *
 *  @return User
 */
- (User *)addUser {
    User *user = (User *)[CoreDataUtil createData:MANAGED_OBJECT_CONTEXT modelName:@"User"];
    user.userId = _userId.text;
    user.password = _password.text;
    user.userName = _realName.text;
    user.birthday = [StringUtil get8BitDateStringFromFormatDateString:_birthday.text];
    user.companyId = selectedCompanyId;
    user.sex = selectedCodeIdSex;
    user.phoneOne = _phoneNo.text;
    user.email = _email.text;
    user.isJob = @"C";
    user.createDateTime = [StringUtil get14BitDateStringFromDate:[NSDate date]];
    user.updateDateTime = [StringUtil get14BitDateStringFromDate:[NSDate date]];
    return user;
}
/**
 *  提交注册数据到服务器
 *
 *  @param user User对象
 */
- (void)submitUserDataToServer:(User *)user {
    UIAlertView *alertL = [[UIAlertView alloc] initWithTitle:@"正在提交注册信息,请稍候..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertL show];
    NSString *post = [EntityUtil parseEntityToJsonObjectStr:user];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"save" forKey:@"method"];
    [params setValue:post forKey:@"data"];
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:HOST_IP apiPath:LOGIN_PATH customHeaderFields:nil];
    MKNetworkOperation *operation = [engine operationWithPath:nil params:params httpMethod:@"POST"];
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSString *s = [completedOperation responseString];
        if (![s isEqualToString:@"N"]) {
            [alertL dismissWithClickedButtonIndex:0 animated:NO];
            [ViewBuilder autoDismissAlertViewWithTitle:@"注册成功!请等待管理员审核通过." afterDelay:2.0f];
            [self dismissViewControllerAnimated:YES completion:^{}];
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [alertL dismissWithClickedButtonIndex:0 animated:NO];
        [ViewBuilder autoDismissAlertViewWithTitle:@"注册失败!连接到服务器错误!" afterDelay:2.0f];
    }];
    [engine enqueueOperation:operation];
}
/**
 *  检查用户名是否存在,若不存在,则`submitUserDataToServer:`,参数`addUser`
 */
- (void)checkUserIdIsExsistFromServer {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"findOneByUserId" forKey:@"method"];
    [params setValue:_userId.text forKey:@"data"];
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:HOST_IP apiPath:LOGIN_PATH customHeaderFields:nil];
    MKNetworkOperation *operation = [engine operationWithPath:nil params:params httpMethod:@"POST"];
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSString *s = [completedOperation responseString];
        if ([s isEqualToString:@"N"]) {
            [self submitUserDataToServer:[self addUser]];
        }else{
            [ViewBuilder autoDismissAlertViewWithTitle:@"用户名已经存在!" afterDelay:2.0f];
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {}];
    [engine enqueueOperation:operation];
}
/**
 *  公司选择器
 *
 *  @return 公司列表
 */
- (UIView *)buildCompanyPickerTableView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 250)];
    alertTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 150, 250)];
    [alertTableView setBackgroundColor:[UIColor clearColor]];
    [alertTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    result = [[HDHNSFetchedResultsController alloc] initWithTableView:alertTableView];
    result.hdhFetchedResultsController = [Company fetchedResultsControllerWithPredicate:nil];
    result.delegate = self;
    result.reuseIndentifier = @"AlertTableViewCell";
    [view addSubview:alertTableView];
    return view;
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

@end
