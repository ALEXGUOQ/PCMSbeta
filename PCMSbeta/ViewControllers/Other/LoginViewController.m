//
//  LoginViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-7-28.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "LoginViewController.h"
#import "Checkbox.h"
#import "FindCode.h"
#import "FindCompany.h"
#import "SetPwdRemembered.h"
/** # 登录界面,在此界面消失时,会执行网络操作, `FindCode`, `FindCompany` */
@interface LoginViewController () {
    LoginUser *user;
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
 *  记住密码
 */
@property (weak, nonatomic) IBOutlet Checkbox *isRememberPwd;


@end

@implementation LoginViewController

#pragma mark - lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_isRememberPwd.checked) {
        [SetPwdRemembered setIsRemembered:@"Y"];
    } else {
        [SetPwdRemembered setIsRemembered:@"N"];
    }
    [FindCode start];
    [FindCompany start];
}

#pragma mark - Action
/**
 *  `validateUser`验证输入,然后登录
 *
 *  @param sender <#sender description#>
 */
- (IBAction)login:(UIButton *)sender {
    user.userId = _userId.text;
    user.password = _password.text;
    if ([StringUtil isNull:_userId.text]|[StringUtil isNull:_password.text]) {
        [ViewBuilder autoDismissAlertViewWithTitle:@"用户名或密码不能为空!" afterDelay:1.0];
    } else {
        [self validateUser];
    }
}

#pragma mark - simple method
/**
 *  视图初始化
 */
- (void)configView {
    _isRememberPwd.tintColor = [UIColor blackColor];
    user = [[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"LoginUser" withPredicate:nil] lastObject];
    _userId.text = user.userId;
    if ([SetPwdRemembered getIsRemembered]) {
        _password.text = user.password;
        _isRememberPwd.checked = YES;
    }
    if (!user) {
        user = (LoginUser *)[CoreDataUtil createData:MANAGED_OBJECT_CONTEXT modelName:@"LoginUser"];
    }
}
/**
 *  验证用户输入
 */
- (void)validateUser {
    UIAlertView *alert = [ViewBuilder showAlertWithTitle:@"正在登录..."];
    
    NSString *post = [EntityUtil parseEntityToJsonObjectStr:user];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"check" forKey:@"method"];
    [params setValue:post forKey:@"data"];
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:HOST_IP
                                                                apiPath:LOGIN_PATH
                                                     customHeaderFields:nil];
    MKNetworkOperation *operation = [engine operationWithPath:nil params:params httpMethod:@"POST"];
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSString *s = [completedOperation responseString];
        NSLog(@"返回--------------------LoginUser-------------------数据\n%@",s);
        if (![s isEqualToString:@"N"]) {
            NSDictionary *dic = [EntityUtil parseJsonObjectStrToDic:(NSString *)s];
            //如果服务器返回正确数据,则数据中的password字段的值已经被md5加密,需要充值其值为非加密即用户输入的值
            [dic setValue:_password.text forKey:@"password"];
            BOOL ret = [EntityUtil reflectDataFromOtherObject4Entity:user withData:dic];
            if (ret) {
                NSError *error = nil;
                if (![MANAGED_OBJECT_CONTEXT save:&error]) {
                    NSLog(@"LoginUser保存失败,error:%@", error);
                } else {
                    NSLog(@"LoginUser保存成功");
                }
                [APP_DELEGATE setCurrentUser:user];
                [alert dismissWithClickedButtonIndex:0 animated:NO];
                [self presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TabContainer"]animated:YES completion:^{}];
            }else{
                [alert dismissWithClickedButtonIndex:0 animated:NO];
                [ViewBuilder autoDismissAlertViewWithTitle:@"用户名或密码错误!" afterDelay:1.0f];
            }
        }else{
            [alert dismissWithClickedButtonIndex:0 animated:NO];
            [ViewBuilder autoDismissAlertViewWithTitle:@"用户名或密码错误!" afterDelay:1.0f];
        }
        
    }
                       errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                           [alert dismissWithClickedButtonIndex:0 animated:NO];
                           [ViewBuilder autoDismissAlertViewWithTitle:@"连接到服务器失败,请检查网络!" afterDelay:1.0f];
                       }];
    [engine enqueueOperation:operation];
}

@end
