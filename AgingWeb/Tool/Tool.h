//
//  Tool.h
//  AgingWeb
//
//  Created by qyhc on 17/8/28.
//  Copyright © 2017年 com.qykj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *actionTitle = @"actionTitle";
static NSString *actionStyle = @"actiontStyle";
static NSString *actionBlock = @"actionBlock";

@interface Tool : NSObject

#pragma mark - 创建Button  Label
/**
 *  创建一个Button
 *
 */
+ (UIButton *)creatButonWithType:(UIButtonType )type
                           Frame:(CGRect )frame
                           title:(NSString *)title
                      titleColor:(UIColor *)titleColor
                           image:(UIImage *)image font:(NSInteger )font;

/**
 *  创建一个Label
 *
 */
+ (UILabel *)creatLabelWithFrame:(CGRect )frame
                           title:(NSString *)title
                      titleColor:(UIColor *)titleColor
                            font:(NSInteger )font;


#pragma mark - 获取一个字符串的Size
/**
 *  返回一个字符串的Size
 *
 *  @param str       字符串
 *  @param allowSize 允许的Size
 *  @param font      字体
 *
 *  @return 字符串Size
 */
+ (CGSize )getSizeWithString:(NSString *)str WithSize:(CGSize )allowSize font:(NSInteger )font;


#pragma mark - 根据字典拼接URL字符串
/**
 *  根据字典拼接URL参数
 *
 *  @param dict Key为字段名 Value为字段内容
 *
 *  @return 带有 ? 的参数字符串
 */

+ (NSString *)getURLStrWithDict:(NSDictionary *)dict;


#pragma mark - 弹出Alert
/**
 *  弹出一个Alert
 *
 *  @param viewController   需要弹出的VC
 *  @param alertStyle       alertStyle
 *  @param title            alertTitle
 *  @param message          alertMessage
 *  @param alertActionArray alertActionArray : 数组里是字典 需要包含 actionTitle、actiontStyle、actionBlock
 *  @param isCancel         是否需要取消键
 *  @param handler      取消的 Block 回调 可为nil
 */

+ (void)showAlertControllerWithViewController:(UIViewController *)viewController
                                   alertStyle:(UIAlertControllerStyle)alertStyle
                                        title:(NSString *)title
                                      message:(NSString *)message
                                  alertAction:(NSArray *)alertActionArray
                                     isCancel:(BOOL)isCancel
                                  cancelBlock:(void(^)(UIAlertAction *action))handler;



#pragma mark - Register&&Login LeftView
/**
 *  Register&&Login LeftView文字
 *
 *  @param text 文字
 */

+ (UIView *)textFiledLeftViewWithText:(NSString *)text;



#pragma mark - 导航栏标题
/**
 *  设置导航栏的标题（文字和图片）
 *
 *  @param title title
 */
+ (UIView *)navigationTitleView:(NSString *)title;



#pragma mark - 正则检测
/**
 *  检测手机号码
 *
 *  @param str 输入待检测字符串
 */
+ (BOOL)checkTel:(NSString *)str ;


/**
 *  检测密码 6-16位 数字 字母
 *
 */
+ (BOOL)checkPassword:(NSString *)str ;


/**
 *  检测数字
 *
 */
+ (BOOL)checkNumber:(NSString *)number;





@end
