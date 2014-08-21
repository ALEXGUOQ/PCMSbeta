//
//  BaseViewController.m
//  common
//
//  Created by 胡大函 on 14-7-16.
//  Copyright (c) 2014年 天津米索软件有限公司. All rights reserved.
//

#import "BaseViewController.h"
/**
 *  # 适用于有大量输入框(UITextField)的非滚动视图
 *  非滚动视图实现输入款不被键盘遮盖并自动滚动到下一个输入框的效果
 */
@interface BaseViewController ()

@end

@implementation BaseViewController

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField.returnKeyType==UIReturnKeyNext) {
        UIView *next = [[textField superview] viewWithTag:textField.tag+1];
        [next becomeFirstResponder];
    } else if (textField.returnKeyType==UIReturnKeyDone) {
        [textField resignFirstResponder];
    } else if (textField.returnKeyType==UIReturnKeyDefault) {
        [textField resignFirstResponder];
    }
    
    //[textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

/*
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +
 + 此方法不完美,输入框编辑完成以后,若使用此方法回复视图,
 + 由于要实现每当一个编辑框结束编辑下一个编辑框开始编辑时的动画效果
 + 则会出现视图的"跳动"现象,故采用观察模式监听键盘消失,
 + 在键盘消失的时候恢复视图,这样才能有不错的效果
 +
 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 
//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}
 */

//键盘消失时，将视图恢复到原始状态
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSTimeInterval animationDuration = 0.25f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

@end
