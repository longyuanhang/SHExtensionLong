//
//  NSArray+SHExtension.m
//  JfjbPla-IOS
//
//  Created by 陈胜辉 on 2022/1/12.
//  Copyright © 2022 zuowuping. All rights reserved.
//

#import "NSArray+SHExtension.h"

@implementation NSArray (SHExtension)

- (id)safe_objectAtIndex:(NSUInteger)index{
    id obj;
    @try {
        obj = [self objectAtIndex:index];
    } @catch (NSException *exception) {
        NSLog(@"数组报错：%@",exception.description);
    } @finally {
        return obj ? : @"";
    }
}

@end
