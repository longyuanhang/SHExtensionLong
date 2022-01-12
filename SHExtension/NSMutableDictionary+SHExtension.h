//
//  NSMutableDictionary+SHExtension.h
//  JfjbPla-IOS
//
//  Created by 陈胜辉 on 2022/1/11.
//  Copyright © 2022 zuowuping. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (SHExtension)

- (void)safe_setValue:(id)value forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
