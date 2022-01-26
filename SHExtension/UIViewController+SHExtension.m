//
//  UIViewController+SHExtension.m
//  SHExtensionExample
//
//  Created by CCSH on 2022/1/26.
//  Copyright © 2022 CSH. All rights reserved.
//

#import "UIViewController+SHExtension.h"

@implementation UIViewController (SHExtension)

#pragma mark 关闭自动布局
- (void)closeAutomatically {
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark 返回
- (void)backAction {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark 获取堆栈中的某个控制器
- (UIViewController *)getStackVCWithClassName:(NSString *)className {
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    __block UIViewController *vc = nil;
    [vcs enumerateObjectsUsingBlock:^(UIViewController *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([NSStringFromClass([obj class]) isEqualToString:className]) {
            vc = obj;
            *stop = YES;
        }
    }];
    
    return vc;
}

#pragma mark 获取堆栈中的指定位置的控制器
- (UIViewController *)getStackVCWithAt:(int)at {
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    if (vcs.count) {
        NSUInteger index = at;
        
        if (at < 0) {
            index = vcs.count + at;
        }
        return vcs[index];
    }
    
    return nil;
}

#pragma mark 删除某个控制器
- (BOOL)removeVCToStackWithClassName:(NSString *_Nonnull)className {
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    __block NSInteger index = -1;
    [vcs enumerateObjectsUsingBlock:^(UIViewController *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([NSStringFromClass([obj class]) isEqualToString:className]) {
            index = idx;
            *stop = YES;
        }
    }];
    if (index >= 0) {
        [vcs removeObjectAtIndex:index];
        [self.navigationController setViewControllers:vcs animated:false];
        return YES;
    }
    return NO;
    ;
}

#pragma mark 删除某个位置的控制器
- (void)removeVCToStackWithAt:(int)at {
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    NSUInteger index = at;
    
    if (at < 0) {
        index = vcs.count + at;
    }
    [vcs removeObjectAtIndex:index];
    [self.navigationController setViewControllers:vcs animated:false];
}

#pragma mark 替换某个控制器到堆栈中
- (BOOL)replaceVCToStackVC:(UIViewController *)vc at:(int)at {
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    if (vcs.count > abs(at)) {
        NSUInteger index = at;
        if (at < 0) {
            index = vcs.count + at;
        }
        if (vc) {
            vcs[index] = vc;
        } else {
            [vcs removeObjectAtIndex:index];
        }
        
        [self.navigationController setViewControllers:vcs animated:false];
        
        return true;
    }
    
    return false;
}

@end
