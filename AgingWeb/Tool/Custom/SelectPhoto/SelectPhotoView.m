//
//  SelectPhotoView.m
//  LoveUniversity
//
//  Created by 小鹏 on 16/8/4.
//  Copyright © 2016年 小鹏. All rights reserved.
//

#import "SelectPhotoView.h"

#import "Tool.h"

#import <TZImagePickerController.h>

#import <Photos/Photos.h>

@interface SelectPhotoView () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIButton *camera;

@property (nonatomic, strong) UIButton *photo;

@property (nonatomic, strong) UIButton *cancel;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@end

@implementation SelectPhotoView

- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, Common_Distance_ScreenWidth, Common_Distance_ScreenHeight);
        self.backgroundColor = [UIColor clearColor];
        [self setView];
        self.layer.opacity = 0.0f;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        self.layer.opacity = 1.0f;
        [UIView commitAnimations];
    }
}

- (void)setView {
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, Common_Distance_ScreenWidth, Common_Distance_ScreenHeight - 250);
    [effectView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)]];
    [self addSubview:effectView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, Common_Distance_ScreenHeight - 250, Common_Distance_ScreenWidth, 250)];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.opacity = 1.0f;
    [bottomView addSubview:self.camera];
    [bottomView addSubview:self.photo];
    [bottomView addSubview:self.cancel];
    
    [self addSubview:bottomView];

}

#pragma mark - imagePickDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {

}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *OriginalImage = info[@"UIImagePickerControllerOriginalImage"];
    
    UIImage *shrunkenImage = [self imageByScalingAndCroppingForSizeByInt:960 withImage:OriginalImage];

//    NSData *imageData = UIImageJPEGRepresentation(OriginalImage,0.3);
//    
//    UIImage *image = [UIImage imageWithData:imageData];
    
    
    if (_DidFinishPickingPhotosHandle) {
        _DidFinishPickingPhotosHandle(@[shrunkenImage]);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self cancelClick];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self cancelClick];
}

#pragma mark - event response
- (void)cameraClick {
    
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.layer.opacity = .0f;
    }];
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS8Later) {
        // 无权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [_returnController presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
    
}

- (void)photoClick {
    [self cancelClick];
    
    TZImagePickerController *photoController = [[TZImagePickerController alloc] initWithMaxImagesCount:_maxPhotoCount delegate:nil];
    
    photoController.allowPickingVideo = NO;
    photoController.allowPickingOriginalPhoto = NO;
    
    //Todo :可能存在内存泄漏
    
//    __weak typeof (self) weakSelf = self;
    [photoController setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
//        __strong __typeof(weakSelf) self = weakSelf;
        
        if (self.DidFinishPickingPhotosHandle) {
            self.DidFinishPickingPhotosHandle(photos);
        }
        
    }];
    
    [_returnController presentViewController:photoController animated:YES completion:nil];
}

- (void)cancelClick {
    
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.layer.opacity = .0f;
    } completion:^(BOOL finished) {
        if (finished) {
            [weakSelf removeFromSuperview];
        }
    }];
    
}

#pragma mark - getter
- (UIButton *)camera {
    if (!_camera) {
        _camera = [Tool creatButonWithType:UIButtonTypeCustom Frame:CGRectMake(15, 20, Common_Distance_ScreenWidth - 30, 50) title:@"拍  照" titleColor:[UIColor whiteColor] image:nil font:17];
        
        _camera.backgroundColor = Common_system_Blus;
        
        _camera.layer.cornerRadius = 5;
        
        [_camera addTarget:self action:@selector(cameraClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _camera;
}

- (UIButton *)photo {
    if (!_photo) {
        _photo = [Tool creatButonWithType:UIButtonTypeCustom Frame:CGRectMake(15, 90, Common_Distance_ScreenWidth - 30, 50) title:@"相   册" titleColor:[UIColor whiteColor] image:nil font:17];

        _photo.backgroundColor = Common_system_Blus;

        _photo.layer.cornerRadius = 5;
        
        [_photo addTarget:self action:@selector(photoClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photo;
}

- (UIButton *)cancel {
    if (!_cancel) {
        _cancel = [Tool creatButonWithType:UIButtonTypeSystem Frame:CGRectMake(15, 160, Common_Distance_ScreenWidth - 30, 50) title:@"取  消" titleColor:RGB(85, 85, 85) image:nil font:17];
        
        _cancel.layer.borderColor = Common_system_Black.CGColor;
        _cancel.layer.borderWidth = 1;
        _cancel.layer.cornerRadius = 5;
        
        [_cancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancel;
}

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}


#pragma mark -把图片按照先大小进行裁剪，生成一个新图片
-(UIImage *)imageByScalingAndCroppingForSizeByInt:(int)targetSize withImage:(UIImage *)image{
    
    UIImage *imageTemp = [self rotateImage:image];
    
    CGSize imageSize = imageTemp.size;
    CGFloat sourceWidth = imageSize.width;
    CGFloat sourceHeight = imageSize.height;
    
    //压缩的比例
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = sourceWidth;
    CGFloat scaledHeight = sourceHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    //假如原始图片的宽  或者 高 大于所给的尺寸时，需要进行压缩
    if (sourceWidth > targetSize || sourceHeight > targetSize)
    {
        //图片的宽大于高时，压缩的比例按图片的宽度值走,否则按高度值走
        if (sourceWidth >= sourceHeight) {
            scaleFactor = targetSize / sourceWidth;
        }
        else{
            scaleFactor = targetSize / sourceHeight;
        }
        
        scaledWidth = sourceWidth * scaleFactor;
        scaledHeight = sourceHeight * scaleFactor;
        UIGraphicsBeginImageContext(CGSizeMake(scaledWidth, scaledHeight));
        CGRect thumbnailRect = CGRectZero;
        thumbnailRect.origin = thumbnailPoint;
        thumbnailRect.size.width= scaledWidth;
        thumbnailRect.size.height = scaledHeight;
        [imageTemp drawInRect:thumbnailRect];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        newImage = [UIImage imageWithData:UIImageJPEGRepresentation(newImage, 1.0)];
        return newImage;
    }
    else{
        imageTemp = [UIImage imageWithData:UIImageJPEGRepresentation(imageTemp, 1.0)];
        return imageTemp;
    }
}


#pragma mark - 图像的旋转
-(UIImage *)rotateImage:(UIImage *)image{
    
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    
    switch (orient) {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            break;
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
        
    }else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}


- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    //返回新的改变大小后的图片
    return scaledImage;
}


@end
