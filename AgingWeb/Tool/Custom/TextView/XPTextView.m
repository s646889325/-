//
//  XPTextView.m
//  eXiaoTong
//
//  Created by 小鹏 on 16/5/3.
//  Copyright © 2016年 ZhangCheng. All rights reserved.
//

#import "XPTextView.h"
@interface XPTextView ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation XPTextView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setPlaceHolderLabel];
    
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:)
                                                    name:@"UITextViewTextDidChangeNotification"
                                                  object:self];
    
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setPlaceHolderLabel];
        
    }
    return self;
}

- (void)awakeFromNib {
    [self setPlaceHolderLabel];
    
    [super awakeFromNib];
}

- (void)setPlaceHolderLabel {
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = [UIColor lightGrayColor];
        [self addSubview:_label];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidBeginEditing) name:UITextViewTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _label.text = placeHolder;
    CGSize size = [self setLabelSizeWithStr:_label.text];
    _label.frame = CGRectMake(5, 5, size.width, size.height);
}


- (CGSize )setLabelSizeWithStr:(NSString *)str {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributeDic = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor groupTableViewBackgroundColor]};
    CGSize size = [str boundingRectWithSize:self.bounds.size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributeDic context:nil].size;
    return size;
}

- (void)textViewDidBeginEditing {
    if (self.text.length == 0) {
        _label.layer.opacity = 1.0f;
    }
    else {
        _label.layer.opacity = 0.0f;
    }
    
}

- (void)textViewDidChange{
    if (self.text.length == 0) {
        _label.layer.opacity = 1.0f;
    }
    else {
        _label.layer.opacity = 0.0f;
    }
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification"  object:self];
}



#pragma mark - 限制标题长度
-(void)textViewEditChanged:(NSNotification *)obj{
    
    UITextView *textView = (UITextView *)obj.object;
    NSString *toBeString = textView.text;
    
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > _textNumber) {
                 [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"输入最多是%ld个字",(long)_textNumber]];
                textView.text = [toBeString substringToIndex:_textNumber];
            }
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > _textNumber){
            
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex: _textNumber];
            
            if (rangeIndex.length == 1){
                textView.text = [toBeString substringToIndex: _textNumber];
            }
            else{
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, _textNumber)];
                textView.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}


@end
