//
//  NSString+SHExtension.m
//  SHExtension
//
//  Created by CSH on 2018/9/19.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "GTMBase64.h"
#import "NSString+SHExtension.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>

@implementation NSString (SHExtension)

#pragma mark 获取拼音
- (NSString *)pinyin {
    if (self.length) {
        //系统
        NSMutableString *pinyin = [NSMutableString stringWithString:self];
        CFStringTransform((CFMutableStringRef)pinyin, NULL, kCFStringTransformToLatin, false);
        return [[[pinyin stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]] lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    } else {
        return self;
    }
}

#pragma mark 获取文件名字
- (NSString *)fileName {
    if (!self.length) {
        return self;
    }
    return [[self.lastPathComponent componentsSeparatedByString:@"."] firstObject];
}

#pragma mark 获取字符串长度(中文：2 其他：1）
- (NSInteger)textLength {
    //判断长度
    NSInteger textLength = 0;
    
    for (NSUInteger i = 0; i < self.length; i++) {
        unichar uc = [self characterAtIndex:i];
        textLength += isascii(uc) ? 1 : 2;
    }
    return textLength;
}

#pragma mark 获取MD5加密
- (NSString *)md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (uint32_t)strlen(cStr), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    
    return ret;
}

#pragma mark base64编码
- (NSString *)base64 {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

#pragma mark base64解码
- (NSString *)decoded64 {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

#pragma mark 是否为邮箱
- (BOOL)isEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}

//unicode编码
- (NSString *)unicode{
    NSUInteger length = [self length];
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++){
        NSMutableString *s = [NSMutableString stringWithCapacity:0];
        unichar _char = [self characterAtIndex:i];
        // 判断是否为英文和数字
        if (_char <= '9' && _char >='0'){
            [s appendFormat:@"%@",[self substringWithRange:NSMakeRange(i,1)]];
        }else if(_char >='a' && _char <= 'z'){
            [s appendFormat:@"%@",[self substringWithRange:NSMakeRange(i,1)]];
        }else if(_char >='A' && _char <= 'Z')
        {
            [s appendFormat:@"%@",[self substringWithRange:NSMakeRange(i,1)]];
        }else{
            // 中文和字符
            [s appendFormat:@"\\u%x",[self characterAtIndex:i]];
            // 不足位数补0 否则解码不成功
            if(s.length == 4) {
                [s insertString:@"00" atIndex:2];
            } else if (s.length == 5) {
                [s insertString:@"0" atIndex:2];
            }
        }
        [str appendFormat:@"%@", s];
    }
    return str;
}

//unicode解码
- (NSString *)unicodeStr{
    NSString *tempStr1=[self stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2=[tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3=[[@"\"" stringByAppendingString:tempStr2]stringByAppendingString:@"\""];
    NSData *tempData=[tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr =[NSPropertyListSerialization propertyListFromData:tempData
                                                          mutabilityOption:NSPropertyListImmutable
                                                                    format:NULL
                                                          errorDescription:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

#pragma mark 是否首字母开头
- (BOOL)isFirstLetter {
    //判断是否以字母开头
    NSString *ZIMU = @"^[A-Za-z]+$";
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    
    return [regextestA evaluateWithObject:[self substringToIndex:1]];
}

#pragma mark 是否包含系统表情
- (BOOL)isEmoji {
    // 过滤所有表情。returnValue为NO表示不含有表情，YES表示含有表情
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    return returnValue;
}

#pragma mark 获取html中的内容
- (NSString *)htmlContent {
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType};
    NSData *data = [self dataUsingEncoding:NSUnicodeStringEncoding];
    NSAttributedString *att = [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
    return att.string;
}

#pragma mark - AES-CBC
#pragma mark AES128-CBC-NoPadding 加密
- (NSString *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *AESData = [self AES128Operation:kCCEncrypt
                                       data:data
                                        key:key
                                         iv:iv];
    AESData = [GTMBase64 encodeData:AESData];
    
    return [[NSString alloc] initWithData:AESData encoding:NSUTF8StringEncoding];
}

#pragma mark AES128-CBC-NoPadding 解密
- (NSString *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    
    NSData *AESData = [self AES128Operation:kCCDecrypt
                                       data:data
                                        key:key
                                         iv:iv];
    NSString *str = [[NSString alloc] initWithData:AESData encoding:NSUTF8StringEncoding];
    // 去除填充
    return [str stringByReplacingOccurrencesOfString:@"\0" withString:@""];
}

- (NSData *)AES128Operation:(CCOperation)operation data:(NSData *)data key:(NSString *)key iv:(NSString *)iv {
    // KEY
    char keyPtr[kCCKeySizeAES256 + 1]; // kCCKeySizeAES128、kCCKeySizeAES256
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    // 加密 NoPadding
    NSUInteger dataLength = [data length];
    int diff = kCCKeySizeAES128 - (dataLength % kCCKeySizeAES128);
    int newSize = 0;
    if (diff > 0) {
        newSize = dataLength + diff;
    }
    char dataPtr[newSize];
    memcpy(dataPtr, [data bytes], [data length]);
    for (int i = 0; i < diff; i++) {
        dataPtr[i + dataLength] = 0x0000;
    }
    
    // 处理
    BOOL isEncrypt = operation == kCCEncrypt;
    const void *bytes = isEncrypt ? dataPtr : [data bytes];
    size_t size = isEncrypt ? sizeof(dataPtr) : [data length];
    
    // IV
    char ivPtr[kCCBlockSizeAES128 + 1];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    // DATA
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    // 配置
    CCCryptorStatus cryptorStatus = CCCrypt(operation,
                                            kCCAlgorithmAES128,
                                            0x0000, // NoPadding 填充
                                            keyPtr,
                                            kCCKeySizeAES128,
                                            ivPtr,
                                            bytes,
                                            size,
                                            buffer,
                                            bufferSize,
                                            &numBytesEncrypted);
    
    // 成功
    if (cryptorStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

#pragma mark - AES-ECB
#pragma mark AES128-ECB-NoPadding 加密
- (NSString *)AES128EncryptWithKey:(NSString *)key {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *AESData = [self AES128Operation:kCCEncrypt
                                       data:data
                                        key:key
                                         iv:NULL];
    AESData = [GTMBase64 encodeData:AESData];
    
    return [[NSString alloc] initWithData:AESData encoding:NSUTF8StringEncoding];
}

#pragma mark AES128-ECB-NoPadding 解密
- (NSString *)AES128DecryptWithKey:(NSString *)key {
    NSData *data = [GTMBase64 decodeData:[self dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *AESData = [self AES128Operation:kCCDecrypt
                                       data:data
                                        key:key
                                         iv:NULL];
    
    NSString *str = [[NSString alloc] initWithData:AESData encoding:NSUTF8StringEncoding];
    // 去除填充
    return [str stringByReplacingOccurrencesOfString:@"\0" withString:@""];
}

@end
