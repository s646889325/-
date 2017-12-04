//
//  NSString+Secret.h
//  law
//
//  Created by 小鹏 on 16/12/16.
//  Copyright © 2016年 小鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CommonCrypto/CommonCrypto.h>

@interface NSString (Secret)

- (NSString *)aes256_encrypt:(NSString *)key;

- (NSString *)aes256_decrypt:(NSString *)key;

- (NSString *)md5;

- (NSString *)encode_Base64;

- (NSString *)decode_Base64;


@end

