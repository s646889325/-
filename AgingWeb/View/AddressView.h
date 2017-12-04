//
//  AddressView.h
//  JianShu
//
//  Created by 小鹏 on 2017/7/11.
//  Copyright © 2017年 小鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressModel;
typedef void(^AddressHandle)(NSString *name, NSString *areaid);

@interface AddressView : UIView

+ (void)showWithSelectHandle:(AddressHandle)handle;


@end

@interface AddressData : NSObject

@property (nonatomic, strong) NSMutableArray *provinceList;

@property (nonatomic, strong) NSMutableArray *cityList;

@property (nonatomic, strong) NSMutableArray *countyList;

@end

@interface AddressModel : NSObject

@property (nonatomic, copy) NSString *areaid;

@property (nonatomic, copy) NSString *areaname;

@end
