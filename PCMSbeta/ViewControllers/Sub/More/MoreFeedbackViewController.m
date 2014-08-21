//
//  MoreFeedbackViewController.m
//  PCMSbeta
//
//  Created by 胡大函 on 14-7-30.
//  Copyright (c) 2014年 Dahan@misol. All rights reserved.
//

#import "MoreFeedbackViewController.h"
/**
 *  # 意见反馈页面
 */
@interface MoreFeedbackViewController ()<UITextViewDelegate>{
    BOOL contentIsEmpty;
}

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation MoreFeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _textView.text = @"请输入您的意见...";
    _textView.textColor = [UIColor lightGrayColor];
    contentIsEmpty = YES;
}

- (IBAction)submit:(UIBarButtonItem *)sender {
    [_textView resignFirstResponder];
    if (contentIsEmpty) {
        [ViewBuilder autoDismissAlertViewWithTitle:@"请先填写您的意见" afterDelay:1.0f];
    } else {
        if ([_textView.text isEqualToString:@""]) {
            [ViewBuilder autoDismissAlertViewWithTitle:@"请先填写您的意见" afterDelay:1.0f];
        } else {
            [self submitToServerWithString:_textView.text];
        }
    }
}

- (void)submitToServerWithString:(NSString *)str {
    NSString *path = [NSString stringWithFormat:@"sale-manage//AdviceServlet?method=save"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:str forKey:@"data"];
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:HOST_IP apiPath:path customHeaderFields:nil];
    MKNetworkOperation *operation = [engine operationWithPath:nil params:params httpMethod:@"POST"];
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSString *result = [completedOperation responseString]; // responseData 二进制形式
        NSLog(@"返回------------------------意见反馈-------------------------数据：\n%@", result);
        if (![result isEqualToString:@"N"]) {
            [ViewBuilder autoDismissAlertViewWithTitle:@"意见反馈成功!" afterDelay:2.0f];
            _textView.text = @"请输入您的意见...";
            _textView.textColor = [UIColor lightGrayColor];
            contentIsEmpty = YES;
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"意见反馈请求出错");
        [ViewBuilder autoDismissAlertViewWithTitle:@"意见反馈失败!请检查网络设置!" afterDelay:2.0f];
    }];
    [engine enqueueOperation:operation];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if (contentIsEmpty) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
        contentIsEmpty = NO;
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        
        textView.text = @"请输入您的意见...";
        textView.textColor = [UIColor lightGrayColor];
        contentIsEmpty = YES;
    }
}

/**
 *  用此方法隐藏键盘或限制输入字符数
 *
 *  @param textView <#textView description#>
 *  @param range    <#range description#>
 *  @param text     <#text description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //换行符 @"\n"
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSInteger location = replacementTextRange.location;
    //如果要查找的字符@"\n"的位置存在,则取消textView的第一响应者身份,进而隐藏键盘
    if (location != NSNotFound) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
