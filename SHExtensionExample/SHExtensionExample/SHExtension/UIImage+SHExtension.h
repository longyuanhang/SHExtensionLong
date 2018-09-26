//
//  UIImage+SHExtension.h
//  SHExtension
//
//  Created by CSH on 2018/9/19.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SHExtension)

//获取指定大小的图片(图片等比例居中)
- (UIImage *)imageWithSize:(CGSize)size;
//获取自由拉伸的图片(会以中间的点进行上下左右拉伸)
- (UIImage *)resizedImage;
//设置图片颜色(整体)
- (UIImage *)imageWithColor:(UIColor *)color;
//图片置灰
- (UIImage *)imageGray;

//保存图片到手机
+ (void)saveImageWithImage:(UIImage *)image block:(void(^) (NSURL *url))block;
//保存视图到手机
+ (void)saveImageWithView:(UIView *)view block:(void(^) (NSURL *url))block;

//通过layer获取一张图片
+ (UIImage *)getImageWithLayer:(CALayer *)layer;
//通过视图获取一张图片
+ (UIImage *)getImageWithView:(UIView *)view;
//通过颜色获取一张图片
+ (UIImage *)getImageWithColor:(UIColor *)color;
//通过颜色数组获取一个渐变的图片
+ (UIImage *)getImageWithSize:(CGSize)size colorArr:(NSArray *)colorArr;

@end

NS_ASSUME_NONNULL_END
