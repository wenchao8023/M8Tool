

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WCUIKitControl : NSObject

#pragma mark - 判断设备型号
//+(NSString *)platformString;
+(NSString *)deviceIdForIDFA;

#pragma mark - UIKit
#pragma mark -- 创建 UIView
+(UIView *)createViewWithFrame:(CGRect)frame ;
+(UIView* )createViewWithFrame:(CGRect)frame
                       BgColor:(UIColor *)bgColor ;

#pragma mark -- 创建 UILabel
+(UILabel *)createLabelWithFrame:(CGRect)frame ;
+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text ;
+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                        FontSize:(CGFloat)fontSize ;
+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                   TextAlignment:(NSTextAlignment)textAlignment ;
+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                       TextColor:(UIColor *)textColor ;
+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                        FontSize:(CGFloat)fontSize
                   TextAlignment:(NSTextAlignment)textAlignment ;
+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                        FontSize:(CGFloat)fontSize
                       TextColor:(UIColor *)textColor ;
+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                   TextAlignment:(NSTextAlignment)textAlignment
                       TextColor:(UIColor *)textColor;
+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                        FontSize:(CGFloat)fontSize
                   TextAlignment:(NSTextAlignment)textAlignment
                       TextColor:(UIColor *)textColor ;
// frame + bgColor
+(UILabel *)createLabelWithFrame:(CGRect)frame
                         BgColor:(UIColor *)bgColor;
+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                         BgColor:(UIColor *)bgColor;
+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                        FontSize:(CGFloat)fontSize
                         BgColor:(UIColor *)bgColor;
+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                   TextAlignment:(NSTextAlignment)textAlignment
                         BgColor:(UIColor *)bgColor;
+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                       TextColor:(UIColor *)textColor
                         BgColor:(UIColor *)bgColor;
+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                        FontSize:(CGFloat)fontSize
                   TextAlignment:(NSTextAlignment)textAlignment
                         BgColor:(UIColor *)bgColor;
+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                        FontSize:(CGFloat)fontSize
                       TextColor:(UIColor *)textColor
                         BgColor:(UIColor *)bgColor;
+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                   TextAlignment:(NSTextAlignment)textAlignment
                       TextColor:(UIColor *)textColor
                         BgColor:(UIColor *)bgColor ;
+(UILabel *)createLabelWithFrame:(CGRect)frame
                            Text:(NSString *)text
                        FontSize:(CGFloat)fontSize
                   TextAlignment:(NSTextAlignment)textAlignment
                       TextColor:(UIColor *)textColor
                         BgColor:(UIColor *)bgColor ;

#pragma mark -- 创建 UIButton
+(UIButton *)createButtonWithFrame:(CGRect)frame
                            Target:(id)target
                            Action:(SEL)action
                             Title:(NSString *)title ;
+(UIButton *)createButtonWithFrame:(CGRect)frame
                            Target:(id)target
                            Action:(SEL)action
                         ImageName:(NSString*)imageName ;
+(UIButton*)createButtonWithFrame:(CGRect)frame
                        ImageName:(NSString*)imageName
                           Target:(id)target
                           Action:(SEL)action
                            Title:(NSString*)title ;
+(UIButton *)createButtonWithFrame:(CGRect)frame
                        systemType:(UIButtonType)systemType
                            Target:(id)target
                            Action:(SEL)action ;

#pragma mark -- 创建 UIImageView
+(UIImageView*)createImageViewWithFrame:(CGRect)frame
                              ImageName:(NSString*)imageName;
+(UIImageView*)createImageViewWithFrame:(CGRect)frame
                              ImageName:(NSString*)imageName
                                BgColor:(UIColor *)bgColor;

#pragma mark -- 创建 UITableView
+(UITableView *)createTableViewWithFrame:(CGRect)frame
                                   style:(UITableViewStyle)style
                                delegate:(id)delegate ;
+(UITableView *)createTableViewWithFrame:(CGRect)frame
                                   style:(UITableViewStyle)style
                                delegate:(id)delegate
                              HeaderView:(UIView *)headerView
                              FooterView:(UIView *)footerView ;


#pragma mark -- 创建 UITextField
+(UITextField*)createTextFieldWithFrame:(CGRect)frame
                            Placeholder:(NSString*)placeholder
                          TextAlignment:(NSTextAlignment)textAlignment
                              TextColor:(UIColor *)textColor
                               FontSize:(CGFloat)fontSize
                        SecureTextEntry:(BOOL)secureTextEntry
                            BorderStyle:(UITextBorderStyle)borderStyle
                           KeyboardType:(UIKeyboardType)keyboardType ;
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
                              InputView:(UIView *)inputView ;


#pragma mark -- 创建 UIBarButtonItem
+(UIBarButtonItem *)createBarButtonItemWithFrame:(CGRect)frame
                                           Title:(NSString *)title
                                       ImageName:(NSString *)imageName
                                          Target:(id)target
                                          Action:(SEL)action ;


#pragma mark -- 设置 view.layer
+(void)setterLayerView:(UIView *)view
                Radius:(CGFloat)radius ;
+(void)setterLayerView:(UIView *)view
                 Width:(CGFloat)width
                 Color:(UIColor *)color ;
+(void)setterLayerView:(UIView *)view
                Radius:(CGFloat)radius
                 Width:(CGFloat)width
                 Color:(UIColor *)color ;

@end
