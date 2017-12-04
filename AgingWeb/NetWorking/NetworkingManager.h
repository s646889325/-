//
//  NetworkingManager.h
//  AgingWeb
//
//  Created by qyhc on 17/8/28.
//  Copyright © 2017年 com.qykj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void(^SuccessfulBlock)(NSDictionary *responseDict);

typedef void(^FailedfulBlock)(NSDictionary *responseDict);

typedef void(^FailedBlock)(NSError *error);

@interface NetworkingManager : NSObject


+ (instancetype)shareManager;


#pragma mark - Common
/**
 *  地址
 *
 *  @param parameter 参数: parentid
 *  @param success   success
 *  @param fail      fail
 */
- (void)Agent_AddressWithParameter:(NSDictionary *)parameter success:(SuccessfulBlock)success fail:(FailedBlock)fail;




@end
