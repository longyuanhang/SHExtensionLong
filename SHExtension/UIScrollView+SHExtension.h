//
//  UIScrollView+SHExtension.h
//  SHExtensionExample
//
//  Created by CCSH on 2022/1/27.
//  Copyright © 2022 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^RefreshCallback)(void);

@interface UIScrollView (SHExtension)

//添加刷新UI
- (void)refreshHeaderBlock:(RefreshCallback)block;
//添加加载UI
- (void)refreshFooterBlock:(RefreshCallback)block;
//停止所有加载的状态
- (void)stopAllrefresh;

//注册cell
- (void)registerClass:(NSString *)name;
- (void)registerClass:(NSString *)name kind:(NSString *_Nullable)kind;
- (void)registerNib:(NSString *)name;
- (void)registerNib:(NSString *)name kind:(NSString *_Nullable)kind;

//获取cell
- (UITableViewCell *)dequeueCellWithIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
