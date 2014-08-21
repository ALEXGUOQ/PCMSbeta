//
//  BaseCo4TextFieldInScrollView.m
//  testScorllKeyboardDismiss
//
//  Created by 胡大函 on 14-7-16.
//  Copyright (c) 2014年 天津米索软件有限公司. All rights reserved.
//

#import "BaseCo4TextFieldInScrollView.h"
/** # 适用于有大量输入框(UITextField)作为childView的scrollView滚动视图
使用这个类时,需要将scrollView的tag设置为100或者自己指定一个tag,以获取scrollView的实例
实现输入框不被键盘挡住并自动滚动到下一个输入框的效果
 
    #define ScrollView_TAG 100
    scrollView = (UIScrollView *)[self.view viewWithTag:ScrollView_TAG];
 
 */
#define ScrollView_TAG 100
@interface BaseCo4TextFieldInScrollView () {
    UITextField *activeField;
    UIScrollView *scrollView;
}

@end

@implementation BaseCo4TextFieldInScrollView

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    scrollView = (UIScrollView *)[self.view viewWithTag:ScrollView_TAG];
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(activeField.returnKeyType==UIReturnKeyNext) {
        UIView *next = [[activeField superview] viewWithTag:activeField.tag+1];
        [next becomeFirstResponder];
    } else if (activeField.returnKeyType==UIReturnKeyDone) {
        [activeField resignFirstResponder];
    } else if (activeField.returnKeyType==UIReturnKeyDefault) {
        [activeField resignFirstResponder];
    }
    return YES;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// 当发送 UIKeyboardDidShowNotification 通知时调用
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    if (CGRectContainsPoint([[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue], activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// 当发送 UIKeyboardWillHideNotification 通知时调用
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

@end
