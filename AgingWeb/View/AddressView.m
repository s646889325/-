//
//  AddressView.m
//  JianShu
//
//  Created by 小鹏 on 2017/7/11.
//  Copyright © 2017年 小鹏. All rights reserved.
//

#import "AddressView.h"

@interface AddressView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) NSArray *tableData;

@property (nonatomic, assign) NSInteger state;

@property (nonatomic, strong) AddressData *addressData;

@property (nonatomic, strong) AddressModel *selectModel;

@property (nonatomic, copy) AddressHandle selectHandle;

@end

@implementation AddressView


+ (void)showWithSelectHandle:(AddressHandle)handle {
    
    AddressView *addressView = [[AddressView alloc] init];
    
    addressView.selectHandle = handle;
    
    UIWindow *rootwindow = [UIApplication sharedApplication].delegate.window;
    
    [rootwindow addSubview:addressView];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        addressView.layer.opacity = 1.0f;
        
    }];
}

- (instancetype)init {
    if (self = [super initWithFrame:[UIApplication sharedApplication].delegate.window.frame]) {
        self.state = 0;
        
        self.layer.opacity = 0.0f;
        
        self.addressData = [[AddressData alloc] init];
                
        self.tableData = self.addressData.provinceList;
        
        [self requestAddressListWithParentid:@"0"];
        
        [self addSubview:self.backView];
        
        [self addSubview:self.tableView];
        [self addSubview:self.addressLabel];
    }
    return self;
}

- (void)remove {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.layer.opacity = 0.0f;
        
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (UIView *)backView {
    if (!_backView) {
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Common_Distance_ScreenWidth, Common_Distance_ScreenHeight - 240)];
        
        _backView.backgroundColor = [UIColor blackColor];
        _backView.layer.opacity = 0.5;
        
        [_backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)]];
    }
    return _backView;
}

#pragma mark - tableDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell"];
    
    AddressModel *model = _tableData[indexPath.row];
    
    cell.textLabel.text = model.areaname;
    
    return cell;
}

- (void)requestAddressListWithParentid:(NSString *)parentid {
    
    __weak typeof (self) weakSelf = self;
    [[NetworkingManager shareManager] Agent_AddressWithParameter:@{@"parentid":parentid} success:^(NSDictionary *responseDict) {
        
        NSMutableArray *item = [NSMutableArray array];
        
        if ([responseDict[@"arealist"] count] == 0) {
            if (weakSelf.selectHandle) {
                weakSelf.selectHandle(weakSelf.addressLabel.text, weakSelf.selectModel.areaid);
                
            }
        }
        
        for (NSDictionary *area in responseDict[@"arealist"]) {
            AddressModel *model = [[AddressModel alloc] init];
            [model setValuesForKeysWithDictionary:area];
            [item addObject:model];
        }
        
        switch (weakSelf.state) {
            case 0://获取省
                
                
                [weakSelf.addressData.provinceList addObjectsFromArray:item];;
                weakSelf.tableData = weakSelf.addressData.provinceList;
                break;
            case 1://获取市
                
                [weakSelf.addressData.cityList addObjectsFromArray:item];;
                
                weakSelf.tableData = weakSelf.addressData.cityList;
                
                break;
            case 2://获取县
                
                [weakSelf.addressData.countyList addObjectsFromArray:item];;
                
                weakSelf.tableData = weakSelf.addressData.countyList;
                
                break;
        }
        
        [weakSelf.tableView reloadData];
        
    } fail:^(NSError *error) {
        
        
    }];
}

#pragma mark - tableDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [UIView animateWithDuration:0.2 animations:^{
        tableView.contentOffset = CGPointMake(0, 0);
    }];
    
    if (indexPath.row == 0) {
        
        if (_selectHandle) {
            if (self.addressLabel.text.length == 0) {
              self.selectHandle(@"全国", self.selectModel.areaid);
            }
            else {
                self.selectHandle(self.addressLabel.text, self.selectModel.areaid);
            }
            [self remove];
        }
        
        return;
    }
    
    self.state ++;
    
    _selectModel = _tableData[indexPath.row];
    
    NSString *str = self.addressLabel.text;
    
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@",str,_selectModel.areaname];
    
    
    
    if (self.state == 3) {
        
        NSLog(@"回调");
        if (_selectHandle) {
            self.selectHandle(self.addressLabel.text, self.selectModel.areaid);
            [self remove];
        }
    }
    else {
        AddressModel *model = _tableData[indexPath.row];
        [self requestAddressListWithParentid:model.areaid];
    }
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Common_Distance_ScreenHeight - 200, Common_Distance_ScreenWidth, 200) style:UITableViewStyleGrouped];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"addressCell"];
    }
    return _tableView;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        
        UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, Common_Distance_ScreenHeight - 240, 20, 40)];
        spaceView.backgroundColor = [UIColor whiteColor];
        [self addSubview:spaceView];
        
        UILabel *tipLabel = [Tool creatLabelWithFrame:CGRectMake(0, Common_Distance_ScreenHeight - 280, Common_Distance_ScreenWidth, 40) title:@"所选地区" titleColor:[UIColor grayColor] font:14];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:tipLabel];
        
        _addressLabel = [Tool creatLabelWithFrame:CGRectMake(20, Common_Distance_ScreenHeight - 240, Common_Distance_ScreenWidth, 40) title:@"" titleColor:[UIColor blackColor] font:16];
        
        _addressLabel.backgroundColor = [UIColor whiteColor];
    }
    return _addressLabel;
}


@end

@implementation AddressData

- (instancetype)init {
    if (self = [super init]) {
        
        AddressModel *province = [[AddressModel alloc] init];
        province.areaname = @"全国";
        province.areaid = @"0";
        
        AddressModel *city = [[AddressModel alloc] init];
        city.areaname = @"全省";
        
        AddressModel *county = [[AddressModel alloc] init];
        county.areaname = @"全市";
        
        self.provinceList = [NSMutableArray arrayWithObject:province];
        self.cityList = [NSMutableArray arrayWithObject:city];
        self.countyList = [NSMutableArray arrayWithObject:county];
        
    }
    return self;
}

@end

@implementation AddressModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
