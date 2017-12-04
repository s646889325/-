//
//  SSXXDatePicker.h
//  Video
//
//  Created by 小鹏 on 16/9/23.
//  Copyright © 2016年 小鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *  一个时间选择器
 *  使用Block 作为回调
 */

@interface DatePicker : UIView

@property (nonatomic, copy) void(^TimeSelectHandle)(NSString *date);

@property (nonatomic, copy) NSString *minTime;

@property (nonatomic, copy) NSString *maxTime;

- (void)show;

@end
