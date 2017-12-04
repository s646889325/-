//
//  SegmentedView.m
//  law
//
//  Created by 小鹏 on 16/12/13.
//  Copyright © 2016年 小鹏. All rights reserved.
//

#import "SegmentedView.h"

#define View_Width [UIScreen mainScreen].bounds.size.width / _items.count

#define Self_Height CGRectGetHeight(self.frame)

@interface SegmentedView ()

@property (nonatomic, strong) UIView *line;

@property (nonatomic, copy) DidSelectHandle handle;

@end

@implementation SegmentedView

- (instancetype)initWithFrame:(CGRect)frame andItmeTitles:(NSArray *)items {
    if (self = [super initWithFrame:frame]) {
        _items = items;
        [self setTopView];
        [self addSubview:self.line];
        
    }
    return self;
}
#pragma mark - public Methods
- (void)segmentedDidSelectHandle:(DidSelectHandle)handle {
    if (handle) {
        _handle = handle;
    }
}

#pragma mark - private Methods
- (void)setTopView {
    for (NSInteger i= 0 ; i < _items.count; i ++) {
        UILabel *view = [[UILabel alloc] initWithFrame:CGRectMake(View_Width * i, 0, View_Width, Self_Height - 2)];
        
        view.backgroundColor = [UIColor whiteColor];
        
        view.text = _items[i];
        
        view.textAlignment = NSTextAlignmentCenter;
        
        view.tag = i + 100;
        
        view.userInteractionEnabled = YES;
        
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(segmentedDidSelect:)]];
       
        [self addSubview:view];
    }
    
    self.tinColor = [UIColor blueColor];
}

#pragma mark - GestureRecognizer
- (void)segmentedDidSelect:(UITapGestureRecognizer *)obj {
    if (_handle) {
        _handle(obj.view.tag - 100);
    }
    self.selectedSegmentIndex = obj.view.tag - 100;
  
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex {
    
    _selectedSegmentIndex = selectedSegmentIndex;
    
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = weakSelf.line.frame;
        frame.origin.x = _selectedSegmentIndex * View_Width + View_Width / 4;
        weakSelf.line.frame = frame;
    }];
    
    for (UILabel *view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            label.textColor = [UIColor blackColor];
            if ((view.tag - 100) == _selectedSegmentIndex) {
                label.textColor = _tinColor;
            }
        }
    }
}

#pragma mark - Getter Setter
- (void)setTinColor:(UIColor *)tinColor {
    
    _tinColor = tinColor;
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            if (view.tag == 100) {
                UILabel *label = (UILabel *)view;
                label.textColor = _tinColor;
            }
        }
        else {
            view.backgroundColor = _tinColor;
        }
    }
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(View_Width / 4, Self_Height - 1, View_Width / 2, 1)];
        _line.backgroundColor = _tinColor;
    }
    return _line;
}

@end
