//
//  M8NoteToolBar.m
//  M8Tool
//
//  Created by chao on 2017/7/26.
//  Copyright © 2017年 ibuildtek. All rights reserved.
//

#import "M8NoteToolBar.h"




static int const kTextViewHeight = 28;


@interface M8NoteToolBar ()<UITextViewDelegate>


/**
 发送按钮
 */
@property (nonatomic, strong) UIButton *sendButton;

/**
 文本输入框
 */
@property (nonatomic, strong) UITextView *textView;


@end




@implementation M8NoteToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame])
    {
        [WCNotificationCenter addObserver:self selector:@selector(onEndEditingAction) name:kHiddenKeyboard_Notifycation object:nil];
        
        self.barTintColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.97 alpha:1];
        
        self.layer.borderColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.89 alpha:1].CGColor;
        
        self.layer.borderWidth = 0.5;
        
        [self createUI];
    }
    
    return self;
}
#pragma mark - -- 添加键盘通知
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self registerForKeyboardNotifycations];
}

- (void)registerForKeyboardNotifycations {
    
    // 键盘出现时的通知
    [WCNotificationCenter addObserver:self
                             selector:@selector(keyboardWillShow:)
                                 name:UIKeyboardWillShowNotification
                               object:nil];
    
    // 键盘隐藏时的通知
    [WCNotificationCenter addObserver:self
                             selector:@selector(keyboardWillHidden:)
                                 name:UIKeyboardWillHideNotification
                               object:nil];
}

// 实现键盘出现的时候 计算键盘的高度 显示输入框位置
- (void)keyboardWillShow:(NSNotification *)notification
{
    [M8UserDefault setKeyboardShow:YES];
    
    self.hidden = NO;
    
    [self keyboardAnimationWithKeyboardNotification:notification];
}

// 键盘隐藏时
- (void)keyboardWillHidden:(NSNotification *)notification
{
    [M8UserDefault setKeyboardShow:NO];
    
    self.hidden = YES;
    
    [self keyboardAnimationWithKeyboardNotification:notification];
}

- (void)dealloc {
    
    [self releaseNotify];
}

- (void)releaseNotify
{
    [WCNotificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [WCNotificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [WCNotificationCenter removeObserver:self name:kHiddenKeyboard_Notifycation object:nil];
}

#pragma mark -- 处理键盘动画
- (void)keyboardAnimationWithKeyboardNotification:(NSNotification *)notification
{
    // 获取通知的信息字典
    NSDictionary *userInfo = [notification userInfo];
    
    // 获取键盘弹出后的rect
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    // 获取键盘弹出动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    NSValue *animationCurveValue = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve;
    [animationCurveValue getValue:&animationCurve];
    
    [self selfAnimation:keyboardRect.size.height duration:animationDuration curve:animationCurve];
}

- (void)selfAnimation:(CGFloat)kbHeight duration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve
{
    CGFloat originY = SCREEN_HEIGHT - kbHeight - self.height;    
//    //首尾式动画
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationCurve:curve];
//    [UIView setAnimationDuration:duration];
//    self.y = originY;
//    [UIView commitAnimations];
    
    if ([self.WCDelegate respondsToSelector:@selector(noteToolBarOriginY:isHidden:animationDuration:animationCurve:)])
    {
        [self.WCDelegate noteToolBarOriginY:originY isHidden:self.isHidden animationDuration:duration animationCurve:curve];
    }
}


#pragma mark - -- 创建UI
- (void)createUI
{
    [self sendButton];
    [self textView];
}


- (UIButton *)sendButton
{
    if (!_sendButton)
    {
        UIButton *sendButton = [WCUIKitControl createButtonWithFrame:CGRectMake(self.width - kDefaultMargin - kDefaultCellHeight, kDefaultMargin, kDefaultCellHeight, kTextViewHeight) Target:self Action:@selector(onSendAction) Title:@"发送"];
        sendButton.titleLabel.font = [UIFont systemFontOfSize:kAppMiddleFontSize];
        sendButton.backgroundColor = WCButtonColor;
        WCViewBorder_Radius(sendButton, 2);
        [self addSubview:(_sendButton = sendButton)];
    }
    
    return _sendButton;
}

- (UITextView *)textView
{
    if (!_textView)
    {
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(kDefaultMargin, kDefaultMargin, self.sendButton.x - 2 * kDefaultMargin, kTextViewHeight)];
        
        textView.layer.cornerRadius = 4.f;
        
        textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        textView.layer.borderWidth = 0.5;
        
        textView.layer.masksToBounds = YES;
        
        textView.delegate = self;
        
        textView.font = [UIFont fontWithName:@"MicrosoftYaHei" size:14];
        
        textView.backgroundColor = [UIColor whiteColor];
        
        textView.showsVerticalScrollIndicator = NO;
        
        [self addSubview:(_textView = textView)];
    }
    
    return _textView;
}

- (void)onSendAction
{
    WCLog(@"发送");

    if ([self.WCDelegate respondsToSelector:@selector(noteToolBarSendMsg:)])
    {
        if (!self.textView.text.length)
        {
            return ;
        }
        
        [self.WCDelegate noteToolBarSendMsg:self.textView.text];
        
        self.textView.text = nil;
    }
}

- (void)onBeginEditingAction
{
    [self.textView becomeFirstResponder];
}

- (void)onEndEditingAction
{
    [self.textView resignFirstResponder];
}


@end
