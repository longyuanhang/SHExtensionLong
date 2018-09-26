//
//  UIView+SHExtension.h
//  SHExtension
//
//  Created by CSH on 2018/9/19.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kSHWidth ([UIScreen mainScreen].bounds.size.width)
#define kSHHeight ([UIScreen mainScreen].bounds.size.height)

IBInspectable

@interface UIView (SHExtension)

#pragma mark - frame
//X轴
@property (nonatomic, assign) CGFloat x;
//Y轴
@property (nonatomic, assign) CGFloat y;
//右边X轴(只有GET)
@property (nonatomic, assign) CGFloat maxX;
//右边Y轴(只有GET)
@property (nonatomic, assign) CGFloat maxY;
//中心点X轴
@property (nonatomic, assign) CGFloat centerX;
//中心点Y轴
@property (nonatomic, assign) CGFloat centerY;
//宽度
@property (nonatomic, assign) CGFloat width;
//高度
@property (nonatomic, assign) CGFloat height;
//位置(X、Y)
@property (nonatomic, assign) CGPoint origin;
//尺寸（width、height）
@property (nonatomic, assign) CGSize size;

#pragma mark - 描边
- (void)borderRadius:(CGFloat)radius width:(CGFloat)width color:(UIColor *)color;

#pragma mark - 获取一个渐变色的视图
+ (UIView *)getGradientViewWithSize:(CGSize)size colorArr:(NSArray *)colorArr;

#pragma mark - xib 属性
// 注意: 加上IBInspectable就可以可视化显示相关的属性
/** 可视化设置圆角 */
@property (nonatomic, assign)IBInspectable CGFloat cornerRadius;
/** 可视化设置边框宽度 */
@property (nonatomic, assign)IBInspectable CGFloat borderWidth;
/** 可视化设置边框颜色 */
@property (nonatomic, strong)IBInspectable UIColor *borderColor;

@end

NS_ASSUME_NONNULL_END
