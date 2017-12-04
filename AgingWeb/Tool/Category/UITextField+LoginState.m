//
//  UITextField+LoginState.m
//  LoveUniversity
//
//  Created by 小鹏 on 16/7/18.
//  Copyright © 2016年 小鹏. All rights reserved.
//

#import "UITextField+LoginState.h"

@implementation UITextField (LoginState)

- (void)setStateWithPlaceHolder:(NSString *)placeholder placeHoderColor:(UIColor *)color {
    
    self.leftViewMode = UITextFieldViewModeAlways;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = RGB(144, 144, 144).CGColor;
    self.layer.cornerRadius = 3;
    self.font = [UIFont systemFontOfSize:13];
    self.placeholder = placeholder;
    [self setValue:RGB(208, 208, 213) forKeyPath:@"_placeholderLabel.textColor"];
}

@end
