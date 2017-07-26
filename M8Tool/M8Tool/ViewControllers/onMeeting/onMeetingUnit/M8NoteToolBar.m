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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // 键盘隐藏时的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

// 实现键盘出现的时候 计算键盘的高度 显示输入框位置
- (void)keyboardWasShown:(NSNotification *)notity {
    
    NSDictionary *info = [notity userInfo];
    
    // 获取键盘的 size
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    NSLog(@"kb_height = %f", kbSize.height);
    
    [self beginMoveUpAnimation:kbSize.height];
}

// 键盘隐藏时
- (void)keyboardWillHidden:(NSNotification *)notify {
    
    NSLog(@"键盘隐藏");
    
    [self endAnimation];
}

- (void)dealloc {
    
    [self releaseNotify];
}

- (void)releaseNotify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -- 处理键盘动画
- (void)beginMoveUpAnimation:(CGFloat)kbHeight
{
    self.hidden = NO;
    
    CGRect frame = self.frame;
    
    frame.origin.y = SCREEN_HEIGHT - kbHeight - self.height /* - kDefaultNaviHeight */;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.frame = frame;
        
    } completion:^(BOOL finished) {
        
        if (finished) {

            if ([self.WCDelegate respondsToSelector:@selector(noteToolBarOriginY:isHidden:)])
            {
                [self.WCDelegate noteToolBarOriginY:frame.origin.y isHidden:self.isHidden];
            }
        }
    }];
}

- (void)endAnimation
{
    self.hidden = YES;
    
    CGRect frame = self.frame;
    
    frame.origin.y = SCREEN_HEIGHT - self.height /* - kDefaultNaviHeight */;
    
    [UIView animateWithDuration:1 animations:^{
        
        self.frame = frame;
        
    } completion:^(BOOL finished) {
        
        if (finished)
        {
            if ([self.WCDelegate respondsToSelector:@selector(noteToolBarOriginY:isHidden:)])
            {
                [self.WCDelegate noteToolBarOriginY:frame.origin.y isHidden:self.isHidden];
            }
        }
    }];
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
        
        [self addSubview:(_textView = textView)];
    }
    
    return _textView;
}

- (void)onSendAction
{
    WCLog(@"发送");

    if ([self.WCDelegate respondsToSelector:@selector(noteToolBarSendMsg:)])
    {
        [self.WCDelegate noteToolBarSendMsg:self.textView.text];
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
