//
//  UIViewController+SHExtension.h
//  SHExtensionExample
//
//  Created by CCSH on 2022/1/26.
//  Copyright © 2022 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (SHExtension)

#pragma mark 关闭自动布局
- (void)closeAutomatically;

#pragma mark 返回
- (void)backAction;

#pragma mark 获取堆栈中的某个控制器
- (UIViewController *_Nullable)getStackVCWithClassName:(NSString *_Nonnull)className;

#pragma mark 获取堆栈中的指定位置的控制器
- (UIViewController *_Nullable)getStackVCWithAt:(int)at;

#pragma mark 删除某个控制器
- (BOOL)removeVCToStackWithClassName:(NSString *_Nonnull)className;

#pragma mark 删除某个位置的控制器
- (void)removeVCToStackWithAt:(int)at;

#pragma mark 替换某个控制器到堆栈中
- (BOOL)replaceVCToStackVC:(UIViewController *_Nonnull)vc at:(int)at;

@end

NS_ASSUME_NONNULL_END
