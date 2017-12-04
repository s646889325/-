//
//  Tool.m
//  AgingWeb
//
//  Created by qyhc on 17/8/28.
//  Copyright © 2017年 com.qykj. All rights reserved.
//

#import "Tool.h"

@implementation Tool

#pragma mark - 创建Button  Label
+ (UIButton *)creatButonWithType:(UIButtonType )type
                           Frame:(CGRect )frame
                           title:(NSString *)title
                      titleColor:(UIColor *)titleColor
                           image:(UIImage *)image font:(NSInteger )font {
    
    UIButton *button = [UIButton buttonWithType:type];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:font];
    
    return button;
}


+ (UILabel *)creatLabelWithFrame:(CGRect )frame
                           title:(NSString *)title
                      titleColor:(UIColor *)titleColor
                            font:(NSInteger )font {
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = titleColor;
    
    return label;
}



#pragma mark - 获取一个字符串的Size
+ (CGSize )getSizeWithString:(NSString *)str WithSize:(CGSize )allowSize font:(NSInteger )font {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:font],
                                 NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size = [str boundingRectWithSize:allowSize
                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                 attributes:attributes context:nil].size;
    
    return CGSizeMake(size.width,ceilf(size.height));
}



#pragma mark - 根据字典拼接URL字符串
+ (NSString *)getURLStrWithDict:(NSDictionary *)dict {
    
    //URL
    NSMutableString *URL = [NSMutableString string];
    //获取字典的所有keys
    NSArray * keys = [dict allKeys];
    
    //拼接字符串
    for (int j = 0; j < keys.count; j ++)
    {
        NSString *string;
        if (j == 0)
        {
            //拼接时加？
            string = [NSString stringWithFormat:@"?%@=%@", keys[j], [dict objectForKey:keys[j]]];
            
        }
        else
        {
            //拼接时加&
            string = [NSString stringWithFormat:@"&%@=%@", keys[j], [dict objectForKey:keys[j]]];
        }
        //拼接字符串
        [URL appendString:string];
        
    }
    
    NSMutableString *tempStr = [NSMutableString stringWithString:URL];
    [tempStr replaceOccurrencesOfString:@" " withString:@"+" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempStr length])];
    
    
    return [[NSString stringWithFormat:@"%@",tempStr] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet decimalDigitCharacterSet]];
}



#pragma mark - 弹出Alert
+ (void)showAlertControllerWithViewController:(UIViewController *)viewController
                                   alertStyle:(UIAlertControllerStyle)alertStyle
                                        title:(NSString *)title
                                      message:(NSString *)message
                                  alertAction:(NSArray *)alertActionArray
                                     isCancel:(BOOL)isCancel
                                  cancelBlock:(void(^)(UIAlertAction *action))handler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:alertStyle];
    for (NSInteger i = 0 ; i < alertActionArray.count; i ++ ) {
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:alertActionArray[i][actionTitle] style:[alertActionArray[i][actionStyle] integerValue] handler:alertActionArray[i][actionBlock]];
        [alert addAction:alertAction];
    }
    
    if (isCancel) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:handler];
        [alert addAction:cancel];
    }
    
    [viewController presentViewController:alert animated:YES completion:nil];
}



#pragma mark - Register&&Login LeftView
+ (UIView *)textFiledLeftViewWithText:(NSString *)text{
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 35)];
    whiteView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    label.frame = CGRectMake(5, 0, 45, 35);
    label.font = [UIFont systemFontOfSize:17];
    [whiteView addSubview:label];
    
    return whiteView;
}



#pragma mark - 导航栏标题
+ (UIView *)navigationTitleView:(NSString *)title{
    
    UIView *titleView = [[UIView alloc] init];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"version_logo"]];
    
    imageView.frame = CGRectMake(0, 0, 30, 30);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, [Tool getSizeWithString:title WithSize:CGSizeMake(1000, 30) font:18].width, 30)];
    
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleView.frame = CGRectMake(0, 0, 40 + Tool_GetWidthWithView(titleLabel), 30);
    
    
    [titleView addSubview:imageView];
    [titleView addSubview:titleLabel];
    
    return titleView;
}



#pragma mark - 正则检测
/**
 *  检测手机号码
 */
+ (BOOL)checkTel:(NSString *)str {
    
    if (str.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return NO;
    }
    
    NSString *regex = @"^((13[0-9])|(147)|(15[0-9])|(17[0,7-9])|(18[0-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return NO;
        
    }
    return YES;
}


/**
 *  检测密码 6-16位 数字 字母
 *
 */
+ (BOOL)checkPassword:(NSString *)str{
    
    if (str.length > 16 || str.length < 6) {
        [SVProgressHUD showErrorWithStatus:@"密码6-16位，可输入数字、字母、@、&、_"];
        return NO;
    }
    
    //6-16位，数字、字母和特殊字符（@、_、&）
    NSString *regex = @"^[A-Za-z0-9@&_]{6,16}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
        [SVProgressHUD showErrorWithStatus:@"密码6-16位，可输入数字、字母、@、&、_"];
        return NO;
    }
    return YES;
}


/**
 *  检测数字
 *
 */
+ (BOOL)checkNumber:(NSString *)number {
    NSString * regex = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:number];
    if (!isMatch) {
        [SVProgressHUD showErrorWithStatus:@"请输入数字"];
        return NO;
    }
    return isMatch;
}



@end
