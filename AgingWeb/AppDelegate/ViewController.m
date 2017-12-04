//
//  ViewController.m
//  AgingWeb
//
//  Created by qyhc on 17/8/28.
//  Copyright © 2017年 com.qykj. All rights reserved.
//

#import "ViewController.h"

#import "AddressView.h"

#import "SelectInfoModel.h"

@interface ViewController ()

@property (nonatomic, strong) SelectInfoModel *selectModel;

@property (nonatomic, strong) NSArray *addressArray; //地址数组

@property (nonatomic, strong) NSString *addressid; //地址所选id

@property (nonatomic, strong) UIButton *addressButton;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:self.addressButton];
    
    
    if (_selectModel == nil) {
        self.selectModel = [[SelectInfoModel alloc] init];
    }
    
}


- (void)buttonClick{
    
    __weak typeof (self) weakSelf = self;
    
    [AddressView showWithSelectHandle:^(NSString *name, NSString *areaid) {
        weakSelf.selectModel.areaStr = name;
        weakSelf.selectModel.areaid = areaid;
        
        [_addressButton setTitle:self.selectModel.areaStr  forState:UIControlStateNormal];
        
    }];
    
   }



- (UIButton *)addressButton{
    
    if(!_addressButton){
        _addressButton = [Tool creatButonWithType:UIButtonTypeCustom Frame:CGRectMake(Common_Distance_Space, 100, Common_Distance_ScreenWidth - 2 *Common_Distance_Space , 30) title:@"请选择" titleColor:Common_system_Black image:nil font:17];
        [_addressButton addTarget:self action:@selector(buttonClick ) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _addressButton;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
