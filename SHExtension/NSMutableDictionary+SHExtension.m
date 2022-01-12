//
//  NSDictionary+SHExtension.m
//  JfjbPla-IOS
//
//  Created by 陈胜辉 on 2022/1/11.
//  Copyright © 2022 zuowuping. All rights reserved.
//

#import "NSMutableDictionary+SHExtension.h"

@implementation NSMutableDictionary (SHExtension)

- (void)safe_setValue:(id)value forKey:(NSString *)key{
    @try {
        [super setValue:value forKey:key];
    } @catch (NSException *exception) {
        NSLog(@"可变字典报错：%@",exception.description);
    } @finally {
        
    }
}

@end
