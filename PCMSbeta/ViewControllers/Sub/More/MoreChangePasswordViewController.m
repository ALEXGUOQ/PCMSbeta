//
//  MoreChangePasswordViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-7-30.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "MoreChangePasswordViewController.h"

@interface MoreChangePasswordViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldPwd;
@property (weak, nonatomic) IBOutlet UITextField *neWPwd;
@property (weak, nonatomic) IBOutlet UITextField *neWPwdConfirmed;


@end

@implementation MoreChangePasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)submit:(UIBarButtonItem *)sender {
    if ([self validatePwds]) {
        NSString *post = [NSString stringWithFormat: @"oldPassword<mh>%@<dh-x>newPassword<mh>%@<dh-x>userId<mh>%@",[StringUtil getMd5String:_oldPwd.text],[StringUtil getMd5String:_neWPwd.text],[[APP_DELEGATE currentUser] userId]];
        NSString *path = [NSString
                          stringWithFormat:@"sale-manage/UserServlet?method=modifyPassword"];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:post forKey:@"data"];
        MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:HOST_IP apiPath:path customHeaderFields:nil];
        MKNetworkOperation *operation = [engine operationWithPath:nil params:params httpMethod:@"POST"];
        [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            NSString *result = [completedOperation responseString]; // responseData 二进制形式
            NSLog(@"返回------------------------修改密码-------------------------数据：\n%@", result);
            if (![result isEqualToString:@"N"]) {
                LoginUser *loginUser = (LoginUser *)[[CoreDataUtil retrieveData:MANAGED_OBJECT_CONTEXT modelName:@"LoginUser" withPredicate:nil]lastObject];
                loginUser.password = _neWPwd.text;
                [ViewBuilder autoDismissAlertViewWithTitle:@"密码修改成功!" afterDelay:2.0f];
            }
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) { NSLog(@"修改密码请求出错"); }];
        [engine enqueueOperation:operation];
    }
}

- (BOOL)validatePwds{
    if ([_oldPwd.text isEqualToString:@""]|[_neWPwd.text isEqualToString:@""]|[_neWPwdConfirmed.text isEqualToString:@""]) {
        [ViewBuilder autoDismissAlertViewWithTitle:@"必须填写所有的项" afterDelay:1.5f];
        return NO;
    } else {
        if ([_neWPwd.text isEqualToString:_neWPwdConfirmed.text]) {
            if ([_oldPwd.text isEqualToString:[[APP_DELEGATE currentUser] password]]) {
                return YES;
            } else {
                [ViewBuilder autoDismissAlertViewWithTitle:@"原密码验证错误,请重新输入" afterDelay:1.5f];
                return NO;
            }
        } else {
            [ViewBuilder autoDismissAlertViewWithTitle:@"两次输入的新密码不一致,请重新输入" afterDelay:1.5f];
            return NO;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField.returnKeyType==UIReturnKeyNext) {
        UIView *next = [[textField superview] viewWithTag:textField.tag+1];
        [next becomeFirstResponder];
    } else if (textField.returnKeyType==UIReturnKeyDone) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

@end
