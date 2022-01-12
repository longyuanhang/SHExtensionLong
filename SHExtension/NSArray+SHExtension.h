//
//  NSArray+SHExtension.h
//  JfjbPla-IOS
//
//  Created by 陈胜辉 on 2022/1/12.
//  Copyright © 2022 zuowuping. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (SHExtension)

- (id)safe_objectAtIndex:(NSUInteger)index;

@end

@interface NSMutableArray (SHExtension)

- (void)safe_addObject:(id)anObject;

- (void)safe_addObjectsFromArray:(NSArray *)otherArray;

- (void)safe_removeObject:(id)anObject;

@end

NS_ASSUME_NONNULL_END
