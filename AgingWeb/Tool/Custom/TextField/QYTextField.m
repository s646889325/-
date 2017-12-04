//
//  QYTextField.m
//  eXiaoTong
//
//  Created by qyhc on 16/6/15.
//  Copyright © 2016年 ZhangCheng. All rights reserved.
//

#import "QYTextField.h"

@interface QYTextField ()

@end

@implementation QYTextField


- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:self];
    }
    return self;
}


#pragma mark - 限制textField的长度
-(void)textFiledEditChanged:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > _textNumber) {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"输入最多是%ld个字",(long)_textNumber]];
                textField.text = [toBeString substringToIndex:_textNumber];
            }
        }
        
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > _textNumber){
            
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:_textNumber];
            
            if (rangeIndex.length == 1){
                textField.text = [toBeString substringToIndex:_textNumber];
            }
            else{
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, _textNumber)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self];
}



@end
