//
//  NSString+Secret.m
//  law
//
//  Created by 小鹏 on 16/12/16.
//  Copyright © 2016年 小鹏. All rights reserved.
//

#import "NSString+Secret.h"

@implementation NSString (Secret)

- (NSString *)aes256_encrypt:(NSString *)key {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    //对数据进行加密
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess)
    {
        NSData *result = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        //base64
        return [result base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }else
    {
        return nil;
    }
    
}

- (NSString *)aes256_decrypt:(NSString *)key {
    NSData *data = [[NSData alloc] initWithBase64EncodedData:[self dataUsingEncoding:NSASCIIStringEncoding] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    //对数据进行解密
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess)
    {
        NSData* result = [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        
    }else
    {
        return nil;
    }
    
}

- (NSString *)md5 {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cstr, (unsigned int)strlen(cstr), result);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", result[i]];
    
    return output;
    
}

- (NSString *)encode_Base64 {
    
    NSData *encodeData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *encodeStr = [encodeData base64EncodedStringWithOptions:0];
    
    
    return encodeStr;
}

- (NSString *)decode_Base64 {
    
    NSData* decodeData = [[NSData alloc] initWithBase64EncodedString:self options:0];
    
    NSString* decodeStr = [[NSString alloc] initWithData:decodeData encoding:NSASCIIStringEncoding];
    
    return decodeStr;
}

@end
