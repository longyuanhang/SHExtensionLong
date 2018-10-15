//
//  UIImage+SHExtension.m
//  SHExtension
//
//  Created by CSH on 2018/9/19.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "UIImage+SHExtension.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation UIImage (SHExtension)

#pragma mark 获取指定大小的图片
- (UIImage *)imageWithSize:(CGSize)size{
    
    if (CGSizeEqualToSize(self.size, size)) {//如果相同就不处理了
        return self;
    }
    
    CGPoint thumbnailPoint = CGPointZero;
    
    CGFloat widthFactor = size.width / self.size.width;
    CGFloat heightFactor = size.height / self.size.height;
    
    //取最小的比例
    CGFloat scaleFactor = MIN(widthFactor, heightFactor);
    
    //设置宽高
    CGFloat scaledWidth = self.size.width*scaleFactor;
    CGFloat scaledHeight = self.size.height*scaleFactor;
    
    //设置中心点
    if (widthFactor < heightFactor) {
        
        thumbnailPoint.y = (size.height - scaledHeight) * 0.5;
        
    } else if (widthFactor > heightFactor) {
        
        thumbnailPoint.x = (size.width - scaledWidth) * 0.5;
    }
    
    CGRect frame = CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledWidth, scaledHeight);
    //绘制图片
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    [self drawInRect:frame];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //结束
    UIGraphicsEndImageContext();
    
    if(!newImage) {
        return self;
    }
    
    return newImage;
}

#pragma mark 返回一个可以自由拉伸的图片
- (UIImage *)resizedImage {
    return [self stretchableImageWithLeftCapWidth:self.size.width * 0.5 topCapHeight:self.size.height * 0.5];
}

#pragma mark 设置图片颜色(整体)
- (UIImage *)imageWithColor:(UIColor *)color{
    
    //也可以使用
    //    [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //    imageview.tintColor = color;
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark 图片置灰
- (UIImage *)imageGray{
    
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, self.size.width*self.scale, self.size.height*self.scale);
    
    int width = imageRect.size.width;
    int height = imageRect.size.height;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t*) malloc(width * height *sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels,0, width * height *sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height,8, width *sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context,CGRectMake(0,0, width, height), [self CGImage]);
    
    for(int y = 0; y < height; y++) {
        
        for(int x = 0; x < width; x++) {
            
            uint8_t *rgbaPixel = (uint8_t*) &pixels[y * width + x];
            // convert to grayscale using recommended
            uint32_t gray = 0.3*rgbaPixel[1] + 0.59*rgbaPixel[2] + 0.11*rgbaPixel[3];
            // set the pixels to gray
            rgbaPixel[1] = gray;
            rgbaPixel[2] = gray;
            rgbaPixel[3] = gray;
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    UIImage *resultUIImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:UIImageOrientationUp];
    
    // we're done with image now too
    CGImageRelease(imageRef);
    
    return resultUIImage;
}

#pragma mark 获取图片颜色
- (void)getImageColorWithBlock:(ColorBlock)block{
    
    Palette *palette = [[Palette alloc]init];
    palette.image = self;
    [palette startWithBlock:block];
}

#pragma mark 保存图片到手机
+ (void)saveImageWithImage:(UIImage *)image block:(nonnull void (^)(NSURL *))block{
    
    [[ALAssetsLibrary new] writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
        NSLog(@"%@",[NSThread currentThread]);
        //回调
        if (block) {
            if (error) {
                block(nil);
            }else{
                block(assetURL);
            }
        }
    }];
}

#pragma mark 保存视图到手机
+ (void)saveImageWithView:(UIView *)view block:(nonnull void (^)(NSURL *))block{
    
    UIImage *image = [UIImage getImageWithView:view];
    [UIImage saveImageWithImage:image block:block];
}

#pragma mark 通过视图获取一张图片
+ (UIImage *)getImageWithView:(UIView *)view{
    
    return [UIImage getImageWithLayer:view.layer];
}

#pragma mark 通过layer获取一张图片
+ (UIImage *)getImageWithLayer:(CALayer *)layer{
    
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, 0);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark 通过颜色获取一张图片
+ (UIImage *)getImageWithColor:(UIColor *)color{
    
    //宽高 1.0只要有值就够了
    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    //绘制图片
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //结束
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark 通过颜色数组获取一个渐变的图片
+ (UIImage *)getImageWithSize:(CGSize)size colorArr:(NSArray *)colorArr{
    
    //  CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = colorArr;
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0.1);
    gradientLayer.endPoint = CGPointMake(1, 0.9);
    
    // 设置渐变位置
    CGFloat loc = 1.0/(colorArr.count - 1);
    NSMutableArray *location = [[NSMutableArray alloc]init];
    [location addObject:@0];
    NSInteger index = 1;
    
    while (index != colorArr.count) {
        [location addObject:[NSNumber numberWithFloat:index*loc]];
        index++;
    }
    
    //设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = location;
    
    return [UIImage getImageWithLayer:gradientLayer];
}

@end
