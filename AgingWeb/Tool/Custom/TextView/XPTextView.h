//
//  XPTextView.h
//  eXiaoTong
//
//  Created by 小鹏 on 16/5/3.
//  Copyright © 2016年 ZhangCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XPTextView : UITextView <UITextViewDelegate>

@property (nonatomic, copy) NSString *placeHolder;

@property (nonatomic, assign) NSInteger textNumber;

@end
