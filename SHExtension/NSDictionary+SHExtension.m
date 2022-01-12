//
//  NSDictionary+SHExtension.m
//  JfjbPla-IOS
//
//  Created by 陈胜辉 on 2022/1/12.
//  Copyright © 2022 zuowuping. All rights reserved.
//

#import "NSDictionary+SHExtension.h"

@implementation NSDictionary (SHExtension)

- (id)safe_objectForKey:(NSString *)key{
    NSString *value;
    @try {
        value = [self objectForKey:key];
    } @catch (NSException *exception) {
        NSLog(@"字典报错：%@",exception.description);
    } @finally {
        return value ? : @"";
    }
}


@end
