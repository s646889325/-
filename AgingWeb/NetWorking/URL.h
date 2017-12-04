//
//  URL.h
//  AgingWeb
//
//  Created by qyhc on 17/8/28.
//  Copyright © 2017年 com.qykj. All rights reserved.
//

#ifndef URL_h
#define URL_h


#endif /* URL_h */


#pragma mark - BaseURL
/**
 *  基础URL
 */

#if DEBUG

#define BASE_URL @"http://220.194.201.119:9789/" //测试库

#else

#define BASE_URL @"" //正式库

#endif



#pragma mark - CommonURL
//拼接地址
#define JoinStr(x) [NSString stringWithFormat:@"%@%@",BASE_URL,x]



#define Agent_Address JoinStr(@"LvFa_AppService/web/agentctrol/addresslist") //地址

