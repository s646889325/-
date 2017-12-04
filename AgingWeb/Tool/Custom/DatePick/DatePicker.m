//
//  SSXXDatePicker.m
//  Video
//
//  Created by 小鹏 on 16/9/23.
//  Copyright © 2016年 小鹏. All rights reserved.
//

#import "DatePicker.h"

#define ViewHeight 230

#define ButtonHeight 40

//#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
//
//#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define DataFormate @"yyyy-MM-dd"

@interface DatePicker ()

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) UIButton *confirm;

@property (nonatomic, strong) UIButton *cancel;

@end

@implementation DatePicker

- (instancetype)init {
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, Common_Distance_TabHeight - ViewHeight, Common_Distance_ScreenWidth, ViewHeight);
        self.layer.opacity = 0.0;
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.datePicker];
        [self addSubview:self.confirm];
        [self addSubview:self.cancel];
    }
    return self;
}

- (void)confirmClick {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = DataFormate;
    
    if (_TimeSelectHandle) {
        _TimeSelectHandle([dateFormatter stringFromDate:_datePicker.date]);
    }
    
    [self hideView];
}

- (void)show {
    
    [[[UIApplication sharedApplication].delegate window] addSubview:self.backView];
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    self.backView.layer.opacity = 0.6;
    self.layer.opacity = 1;
    
    [UIView commitAnimations];
}

- (void)hideView {
    
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.backView.layer.opacity = .0f;
        weakSelf.layer.opacity = .0f;
    } completion:^(BOOL finished) {
        if (finished) {
            [weakSelf.backView removeFromSuperview];
            [weakSelf removeFromSuperview];
        }
    }];
    
    [UIView commitAnimations];
}

- (void)setMinTime:(NSString *)minTime {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = DataFormate;
    
    NSDate *date = [dateFormatter dateFromString:minTime];
    
    _datePicker.minimumDate = date;
    
}

- (void)setMaxTime:(NSString *)maxTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = DataFormate;
    
    NSDate *date = [dateFormatter dateFromString:maxTime];
    
    _datePicker.maximumDate = date;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Common_Distance_ScreenWidth, Common_Distance_ScreenHeight)];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.layer.opacity = 0.0;
        
        [_backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)]];
        
    }
    return _backView;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, ButtonHeight, Common_Distance_ScreenWidth, ViewHeight - ButtonHeight)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.maximumDate = [NSDate date];
    }
    return _datePicker;
}

- (UIButton *)confirm {
    if (!_confirm) {
        _confirm = [Tool creatButonWithType:UIButtonTypeSystem Frame:CGRectMake(Common_Distance_ScreenWidth / 2, 0, Common_Distance_ScreenWidth / 2, ButtonHeight) title:@"确定  " titleColor:[UIColor blueColor] image:nil font:17];
        
        [_confirm addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        
        _confirm.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _confirm;
}

- (UIButton *)cancel {
    if (!_cancel) {
        _cancel = [Tool creatButonWithType:UIButtonTypeSystem Frame:CGRectMake(0, 0, Common_Distance_ScreenWidth / 2, ButtonHeight) title:@"  取消" titleColor:[UIColor blueColor] image:nil font:17];
        [_cancel addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
        
        _cancel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        

    }
    return _cancel;
}

@end
