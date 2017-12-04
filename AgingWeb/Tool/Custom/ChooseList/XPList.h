//
//  XPList.h
//  eXiaoTong
//
//  Created by 小鹏 on 16/5/10.
//  Copyright © 2016年 ZhangCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectBlock)(NSArray *selectArray);

@interface XPList : UIView

@property (nonatomic, copy) SelectBlock selectBlock;

@property (nonatomic, assign) BOOL multiSelect;

- (instancetype)initWithDataSource:(NSArray *)dataSource andKey:(NSString *)key;

- (void)confirmBlock:(SelectBlock)selectBlock ;

- (void)showView;

@end
