//
//  XPList.m
//  eXiaoTong
//
//  Created by 小鹏 on 16/5/10.
//  Copyright © 2016年 ZhangCheng. All rights reserved.
//

#import "XPList.h"

#import "AppDelegate.h"

@interface XPList ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIButton *confirm;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *selectArray;

@property (nonatomic, strong) NSMutableArray *selectedArray;

@property (nonatomic, strong) NSString *key;

@property (nonatomic, assign) BOOL selectAll;

@end
@implementation XPList

- (instancetype)initWithDataSource:(NSArray *)dataSource andKey:(NSString *)key {
    
    if (self = [super initWithFrame:[UIApplication sharedApplication].delegate.window.bounds]) {
         self.layer.opacity = 0.0f;
        self.key = key;
        [self prepareData:dataSource];
        
        [self addSubview:self.backView];
        [self addSubview:self.tableView];
        [self addSubview:self.confirm];
    }
    return self;
}

#pragma mark - Public methods
- (void)confirmBlock:(SelectBlock)selectBlock {
    
    _selectBlock = selectBlock;
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_multiSelect) {
        return 2;
    }
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_multiSelect) {
        if (section == 0) {
            return 1;
        }
        else {
            return _dataSource.count;
        }
    }
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    
    if (_key) {
        cell.textLabel.text = [_dataSource[indexPath.row] objectForKey:_key];
    }
    else {
        cell.textLabel.text = _dataSource[indexPath.row];
    }
    
    if ([_selectArray[indexPath.row] boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (_multiSelect && indexPath.section == 0) {
        cell.textLabel.text = @"选择全部";
        _selectAll ? (cell.accessoryType = UITableViewCellAccessoryCheckmark) : (cell.accessoryType = UITableViewCellAccessoryNone);
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_multiSelect) {
        if (indexPath.section == 0) {
            _selectAll = !_selectAll;
            if (_selectAll) {
                _selectedArray = [_dataSource mutableCopy];
                for (NSInteger i = 0; i < _selectArray.count; i ++) {
                    _selectArray[i] = @YES;
                }
            }
            else {
                [_selectedArray removeAllObjects];
                for (NSInteger i = 0; i < _selectArray.count; i ++) {
                    _selectArray[i] = @NO;
                }
            }
        }
        else {
            _selectArray[indexPath.row] = [NSNumber numberWithBool:![_selectArray[indexPath.row] boolValue]];
            [_selectArray[indexPath.row] boolValue] ? [_selectedArray addObject:_dataSource[indexPath.row]] : [_selectedArray removeObject:_dataSource[indexPath.row]];
            
            (_selectedArray.count == _selectArray.count) ? (_selectAll = YES) : (_selectAll = NO);
            
        }
    }
    else {
        for (NSInteger i = 0; i < _selectArray.count; i ++) {
            _selectArray[i] = @NO;
        }
        _selectArray[indexPath.row] = @YES;
        
        _selectedArray = [@[_dataSource[indexPath.row]] mutableCopy];
    }
    
    [tableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark - Event response
- (void)showView {
    [[UIApplication sharedApplication].delegate.window addSubview:self];

    [UIView animateWithDuration:0.2 animations:^{
        self.layer.opacity = 1.0f;
    }];
    [UIView commitAnimations];
}

- (void)remove {
    [UIView animateWithDuration:0.3 animations:^{
        self.layer.opacity = .0f;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
    [UIView commitAnimations];
}

- (void)confirmClick {

    if (_selectBlock && self.selectedArray.count > 0) {
        _selectBlock(self.selectedArray);
    }
    [self remove];
}

#pragma mark - Private methods
- (void)prepareData:(NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    
    if (_key) {
        for (NSDictionary *dict in dataSource) {
            [_dataSource addObject:dict];
        }
    }
    else {
        [_dataSource addObjectsFromArray:dataSource];
    }
    
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
        for (NSInteger i = 0; i < _dataSource.count; i ++) {
            [_selectArray addObject:@NO];
        }
    }
}


#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Common_Distance_ScreenWidth - 40, 250) style:UITableViewStylePlain];
        _tableView.center = [UIApplication sharedApplication].delegate.window.center;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellID"];
    }
    return _tableView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].delegate.window.bounds];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.layer.opacity = 0.5f;
        [_backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)]];
    }
    return _backView;
}

- (UIButton *)confirm {
    if (!_confirm) {
        _confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirm.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _confirm.titleLabel.font = [UIFont systemFontOfSize:15];
        _confirm.frame = CGRectMake(CGRectGetMinX(_tableView.frame), CGRectGetMinY(_tableView.frame) - 40, Common_Distance_ScreenWidth - 40, 40);
        [_confirm setTitle:@"确定" forState:UIControlStateNormal];
        [_confirm addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        [_confirm setTitleColor:RGB(0, 122, 255) forState:UIControlStateNormal];
    }
    return _confirm;
}

@end
