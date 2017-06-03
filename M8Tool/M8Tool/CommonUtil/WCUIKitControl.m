

#import "WCUIKitControl.h"
#import <AdSupport/AdSupport.h>

@implementation WCUIKitControl

+(NSString *)deviceIdForIDFA {
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

#pragma mark - UIKit
#pragma mark -- 创建View
+(UIView *)createViewWithFrame:(CGRect)frame
{
    return [self createViewWithFrame:frame
                             BgColor:nil];
}
+(UIView* )createViewWithFrame:(CGRect)frame
                       BgColor:(UIColor *)bgColor
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = bgColor;
    return view;
}


#pragma mark -- 创建 UILabel
// frame
+(UILabel *)createLabelWithFrame:(CGRect)frame
{
    return [self createLabelWithFrame:frame
                                 Text:nil
                             FontSize:[UIFont systemFontSize]
                        TextAlignment:NSTextAlignmentLeft
                            TextColor:nil
                              BgColor:nil];
}
+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
{
    return [self createLabelWithFrame:frame
                                 Text:text
                             FontSize:[UIFont systemFontSize]
                        TextAlignment:NSTextAlignmentLeft
                            TextColor:nil
                              BgColor:nil];
}
+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                        FontSize:(CGFloat)fontSize
{
    return [self createLabelWithFrame:frame
                                 Text:text
                             FontSize:fontSize
                        TextAlignment:NSTextAlignmentLeft
                            TextColor:nil
                              BgColor:nil];
}
+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                   TextAlignment:(NSTextAlignment)textAlignment
{
    return [self createLabelWithFrame:frame
                                 Text:text
                             FontSize:[UIFont systemFontSize]
                        TextAlignment:textAlignment
                            TextColor:nil
                              BgColor:nil];
}
+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                       TextColor:(UIColor *)textColor
{
    return [self createLabelWithFrame:frame
                                 Text:text
                             FontSize:[UIFont systemFontSize]
                        TextAlignment:NSTextAlignmentLeft
                            TextColor:textColor
                              BgColor:nil];
}

+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                        FontSize:(CGFloat)fontSize
                   TextAlignment:(NSTextAlignment)textAlignment
{
    return [self createLabelWithFrame:frame
                                 Text:text
                             FontSize:fontSize
                        TextAlignment:textAlignment
                            TextColor:nil
                              BgColor:nil];
}
+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                        FontSize:(CGFloat)fontSize
                       TextColor:(UIColor *)textColor
{
    return [self createLabelWithFrame:frame
                                 Text:text
                             FontSize:fontSize
                        TextAlignment:NSTextAlignmentLeft
                            TextColor:textColor
                              BgColor:nil];
}
+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                   TextAlignment:(NSTextAlignment)textAlignment
                       TextColor:(UIColor *)textColor
{
    return [self createLabelWithFrame:frame
                                 Text:text
                             FontSize:[UIFont systemFontSize]
                        TextAlignment:textAlignment
                            TextColor:textColor
                              BgColor:nil];
}

+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                        FontSize:(CGFloat)fontSize
                   TextAlignment:(NSTextAlignment)textAlignment
                       TextColor:(UIColor *)textColor
{
    return [self createLabelWithFrame:frame
                                 Text:text
                             FontSize:fontSize
                        TextAlignment:textAlignment
                            TextColor:textColor
                              BgColor:nil];
}

// frame + bgColor
+(UILabel *)createLabelWithFrame:(CGRect)frame
                         BgColor:(UIColor *)bgColor
{
    return [self createLabelWithFrame:frame
                                 Text:nil
                             FontSize:[UIFont systemFontSize]
                        TextAlignment:NSTextAlignmentLeft
                            TextColor:nil
                              BgColor:bgColor];
}
+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                         BgColor:(UIColor *)bgColor
{
    return [self createLabelWithFrame:frame
                                 Text:text
                             FontSize:[UIFont systemFontSize]
                        TextAlignment:NSTextAlignmentLeft
                            TextColor:nil
                              BgColor:bgColor];
}
+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                        FontSize:(CGFloat)fontSize
                         BgColor:(UIColor *)bgColor
{
    return [self createLabelWithFrame:frame
                                 Text:text
                             FontSize:fontSize
                        TextAlignment:NSTextAlignmentLeft
                            TextColor:nil
                              BgColor:bgColor];
}
+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                   TextAlignment:(NSTextAlignment)textAlignment
                         BgColor:(UIColor *)bgColor
{
    return [self createLabelWithFrame:frame
                                 Text:text
                             FontSize:[UIFont systemFontSize]
                        TextAlignment:textAlignment
                            TextColor:nil
                              BgColor:bgColor];
}
+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                       TextColor:(UIColor *)textColor
                         BgColor:(UIColor *)bgColor
{
    return [self createLabelWithFrame:frame
                                 Text:text
                             FontSize:[UIFont systemFontSize]
                        TextAlignment:NSTextAlignmentLeft
                            TextColor:textColor
                              BgColor:bgColor];
}

+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                        FontSize:(CGFloat)fontSize
                   TextAlignment:(NSTextAlignment)textAlignment
                         BgColor:(UIColor *)bgColor
{
    return [self createLabelWithFrame:frame
                                 Text:text
                             FontSize:fontSize
                        TextAlignment:textAlignment
                            TextColor:nil
                              BgColor:bgColor];
}
+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                        FontSize:(CGFloat)fontSize
                       TextColor:(UIColor *)textColor
                         BgColor:(UIColor *)bgColor
{
    return [self createLabelWithFrame:frame
                                 Text:text
                             FontSize:fontSize
                        TextAlignment:NSTextAlignmentLeft
                            TextColor:textColor
                              BgColor:bgColor];
}
+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                   TextAlignment:(NSTextAlignment)textAlignment
                       TextColor:(UIColor *)textColor
                         BgColor:(UIColor *)bgColor
{
    return [self createLabelWithFrame:frame
                                 Text:text
                             FontSize:[UIFont systemFontSize]
                        TextAlignment:textAlignment
                            TextColor:textColor
                              BgColor:bgColor];
}

+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                        FontSize:(CGFloat)fontSize
                   TextAlignment:(NSTextAlignment)textAlignment
                       TextColor:(UIColor *)textColor
                         BgColor:(UIColor *)bgColor
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textAlignment = textAlignment;
    if (textColor)
        label.textColor = textColor;
    if (bgColor)
        label.backgroundColor = bgColor;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.userInteractionEnabled = YES;
    label.adjustsFontSizeToFitWidth = YES;
    return label;
}


#pragma mark -- 创建 UIButton
+(UIButton *)createButtonWithFrame:(CGRect)frame
                            Target:(id)target
                            Action:(SEL)action
                             Title:(NSString *)title
{
    return [self createButtonWithFrame:frame
                             ImageName:nil
                                Target:target
                                Action:action
                                 Title:title];
}

+(UIButton *)createButtonWithFrame:(CGRect)frame
                            Target:(id)target
                            Action:(SEL)action
                         ImageName:(NSString*)imageName
{
    return [self createButtonWithFrame:frame
                             ImageName:imageName
                                Target:target
                                Action:action
                                 Title:nil];
}

+(UIButton*)createButtonWithFrame:(CGRect)frame
                        ImageName:(NSString*)imageName
                           Target:(id)target
                           Action:(SEL)action
                            Title:(NSString*)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+(UIButton *)createButtonWithFrame:(CGRect)frame
                        systemType:(UIButtonType)systemType
                            Target:(id)target
                            Action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:systemType];
    button.frame = frame;
    [button addTarget:target
               action:action
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}


#pragma mark -- 创建imageView
+(UIImageView*)createImageViewWithFrame:(CGRect)frame
                              ImageName:(NSString*)imageName
{
    return [self createImageViewWithFrame:frame
                                ImageName:imageName
                                  BgColor:nil];
}

+(UIImageView*)createImageViewWithFrame:(CGRect)frame
                              ImageName:(NSString*)imageName
                                BgColor:(UIColor *)bgColor
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imageName];
    if (bgColor)
        imageView.backgroundColor = bgColor;
    return imageView;
}


#pragma mark -- 创建UITableView
+(UITableView *)createTableViewWithFrame:(CGRect)frame
                                   style:(UITableViewStyle)style
                                delegate:(id)delegate
{
    return [self createTableViewWithFrame:frame
                                    style:style
                                 delegate:delegate
                               HeaderView:[self createViewWithFrame:CGRectZero]
                               FooterView:[self createViewWithFrame:CGRectZero]];
}

+(UITableView *)createTableViewWithFrame:(CGRect)frame
                                   style:(UITableViewStyle)style
                                delegate:(id)delegate
                              HeaderView:(UIView *)headerView
                              FooterView:(UIView *)footerView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:style];
    tableView.delegate = delegate;
    tableView.dataSource = delegate;
    tableView.tableHeaderView = headerView;
    tableView.tableFooterView = footerView;
    return tableView;
}


#pragma mark -- 创建 UITextField
+(UITextField*)createTextFieldWithFrame:(CGRect)frame
                            Placeholder:(NSString*)placeholder
                          TextAlignment:(NSTextAlignment)textAlignment
                              TextColor:(UIColor *)textColor
                               FontSize:(CGFloat)fontSize
                        SecureTextEntry:(BOOL)secureTextEntry
                            BorderStyle:(UITextBorderStyle)borderStyle
                           KeyboardType:(UIKeyboardType)keyboardType
{
    return [self createTextFieldWithFrame:frame
                              Placeholder:placeholder
                            TextAlignment:textAlignment
                                TextColor:textColor
                                 FontSize:fontSize
                          SecureTextEntry:secureTextEntry
                              BorderStyle:UITextBorderStyleNone
                             KeyboardType:keyboardType
                            LeftImageView:nil
                             LeftViewMode:UITextFieldViewModeNever
                           RightImageView:nil
                            RightViewMode:UITextFieldViewModeNever
                                InputView:[self createViewWithFrame:CGRectZero]];
}


+(UITextField*)createTextFieldWithFrame:(CGRect)frame
                            Placeholder:(NSString*)placeholder
                          TextAlignment:(NSTextAlignment)textAlignment
                              TextColor:(UIColor *)textColor
                               FontSize:(CGFloat)fontSize
                        SecureTextEntry:(BOOL)secureTextEntry
                            BorderStyle:(UITextBorderStyle)borderStyle
                           KeyboardType:(UIKeyboardType)keyboardType
                          LeftImageView:(UIImageView*)leftImageView
                           LeftViewMode:(UITextFieldViewMode)leftViewMode
                         RightImageView:(UIImageView*)rightImageView
                          RightViewMode:(UITextFieldViewMode)rightViewMode
                              InputView:(UIView *)inputView
{
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    textField.placeholder = placeholder;
    textField.textAlignment = textAlignment;
    textField.textColor = textColor;
    textField.font = [UIFont systemFontOfSize:fontSize];
    textField.secureTextEntry = secureTextEntry;
    textField.borderStyle = borderStyle;
    textField.keyboardType = keyboardType;
//    [textField becomeFirstResponder];
    if (leftImageView) {
        textField.leftView = leftImageView;         //左图片
        textField.leftViewMode = leftViewMode;
    }
    if (rightImageView) {
        textField.rightView = rightImageView;       //右图片
        textField.rightViewMode = rightViewMode;
    }
    if (inputView) {
        textField.inputView = inputView;            //自定义键盘
    }
    textField.autocapitalizationType = NO;          //关闭首字母大写
    textField.clearButtonMode = YES;                //清除按钮
    return textField;
}


#pragma mark -- 创建 UIBarButtonItem
+(UIBarButtonItem *)createBarButtonItemWithFrame:(CGRect)frame
                                           Title:(NSString *)title
                                       ImageName:(NSString *)imageName
                                          Target:(id)target
                                          Action:(SEL)action
{
    return [[UIBarButtonItem alloc] initWithCustomView:[self createButtonWithFrame:frame
                                                                          ImageName:imageName
                                                                             Target:target
                                                                             Action:action
                                                                              Title:title]];
}


#pragma mark -- 设置 view.layer
+(void)setterLayerView:(UIView *)view
                Radius:(CGFloat)radius
{
    [self setterLayerView:view
                   Radius:radius
                    Width:0
                    Color:nil];
}

+(void)setterLayerView:(UIView *)view
                 Width:(CGFloat)width
                 Color:(UIColor *)color
{
    [self setterLayerView:view
                   Radius:0
                    Width:width
                    Color:color];
}

+(void)setterLayerView:(UIView *)view
                Radius:(CGFloat)radius
                 Width:(CGFloat)width
                 Color:(UIColor *)color
{
    
    view.layer.cornerRadius = radius;
    view.layer.borderWidth = width;
    if (color)
        view.layer.borderColor = color.CGColor;
    view.layer.masksToBounds = YES;
}



@end
