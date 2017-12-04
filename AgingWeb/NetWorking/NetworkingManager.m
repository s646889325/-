//
//  NetworkingManager.m
//  AgingWeb
//
//  Created by qyhc on 17/8/28.
//  Copyright © 2017年 com.qykj. All rights reserved.
//

#import "NetworkingManager.h"

static id _instance;

@implementation NetworkingManager

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    }
    return _instance;
}


+ (instancetype)shareManager {
    
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc]init];
        }
    }
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    
    return _instance;
}


#pragma mark - Common

- (void)Agent_AddressWithParameter:(NSDictionary *)parameter success:(SuccessfulBlock)success fail:(FailedBlock)fail{
    
    [[AFHTTPSessionManager manager] POST:Agent_Address parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
        }
    }];
}



@end
