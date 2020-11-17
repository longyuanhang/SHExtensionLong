//
//  UIImage+SHExtension.h
//  SHExtension
//
//  Created by CSH on 2018/9/19.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ColorBlock)(NSString *colorString);

@interface UIImage (SHExtension)

//获取自由拉伸的图片(默认会以中间的点进行上下左右拉伸)
@property (nonatomic, strong, readonly) UIImage *resizedImage;
//图片置灰
@property (nonatomic, assign, readonly) UIImage *imageGray;


//获取指定大小的图片(图片等比例居中)
- (UIImage *)imageWithSize:(CGSize)size;
//设置图片颜色(整体)
- (UIImage *)imageWithColor:(UIColor *)color;
//获取图片颜色
- (void)imageColorWithBlock:(ColorBlock)block;
//保存图片到手机
- (void)imageSaveBlock:(void(^) (NSURL *url))block;
//压缩图片
- (UIImage *)imageCompressionWithByte:(NSInteger)length;

//通过颜色获取一张图片
+ (UIImage *)getImageWithColor:(UIColor *)color;
//通过layer获取一张图片
+ (UIImage *)getImageWithLayer:(CALayer *)layer;
//通过颜色数组获取一个渐变的图片
+ (UIImage *)getImageWithSize:(CGSize)size colorArr:(NSArray *)colorArr;

@end





#pragma mark - 获取图片颜色类

static const NSInteger kMaxColorNum = 16;

@interface Palette : NSObject

@property (nonatomic, strong) UIImage *image;

- (void)startWithBlock:(ColorBlock)block;

@end

@interface VBox : NSObject

- (NSInteger)getVolume;

@end


@interface PaletteSwatch : NSObject

- (instancetype)initWithColorInt:(NSInteger)colorInt population:(NSInteger)population;

- (UIColor*)getColor;

//eg:"#FF3000"
- (NSString*)getColorString;

- (NSArray*)getHsl;

- (NSInteger)getPopulation;


@end

@class VBox;

//A queue like PriorityQueue in Java

@interface PriorityBoxArray : NSObject

- (void)addVBox:(VBox*)box;

- (VBox*)objectAtIndex:(NSInteger)i;

//Get the header element and delete it
- (VBox*)poll;

- (NSUInteger)count;

- (NSMutableArray*)getVBoxArray;

@end


NS_ASSUME_NONNULL_END
