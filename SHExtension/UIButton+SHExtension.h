//
//  UIButton+SHExtension.h
//  SHExtensionExample
//
//  Created by CCSH on 2020/11/17.
//  Copyright © 2020 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger {
    SHButtonImageDirection_top,
    SHButtonImageDirection_left,
    SHButtonImageDirection_right,
    SHButtonImageDirection_bottom,
} SHButtonImageDirection;

typedef void(^BtnBlock)(UIButton *btn);

@interface UIButton (SHExtension)

//点击时间间隔
@property (nonatomic, assign) NSTimeInterval timeInterval;

#pragma mark - 图片位置
- (void)imageDirection:(SHButtonImageDirection)direction space:(CGFloat)space;

#pragma mark - 添加点击
- (void)addClickBlock:(BtnBlock)block;

#pragma mark - 添加事件
- (void)addAction:(UIControlEvents)events block:(BtnBlock)block;

@end

NS_ASSUME_NONNULL_END
