//
//  SegmentedView.h
//  law
//
//  Created by 小鹏 on 16/12/13.
//  Copyright © 2016年 小鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *  一个自定义的选项卡
 *  使用Block 作为回调
 */

typedef void(^DidSelectHandle)(NSInteger index);

@interface SegmentedView : UIView

@property (nonatomic, strong) UIColor *tinColor;

@property (nonatomic, assign) NSInteger selectedSegmentIndex;

@property (nonatomic, strong) NSArray *items;

- (instancetype)initWithFrame:(CGRect)frame andItmeTitles:(NSArray *)items;

- (void)segmentedDidSelectHandle:(DidSelectHandle)handle;

@end
