//
//  SelectPhotoView.h
//  LoveUniversity
//
//  Created by 小鹏 on 16/8/4.
//  Copyright © 2016年 小鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *  自定义的照片选择器 基于 TZImagePickerController
 *  包含 三个按钮 
 *  使用Block回调
 *  Bug ：有潜在内存泄漏风险
 */

@interface SelectPhotoView : UIView

@property (nonatomic, assign) NSInteger maxPhotoCount;

@property (nonatomic, strong) UIViewController *returnController;

@property (nonatomic, copy) void (^DidFinishPickingPhotosHandle)(NSArray *imageList);

@end
