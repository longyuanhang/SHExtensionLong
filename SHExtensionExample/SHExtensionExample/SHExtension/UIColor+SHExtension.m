//
//  UIColor+SHExtension.m
//  SHExtension
//
//  Created by CSH on 2018/9/20.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "UIColor+SHExtension.h"
#import "Palette.h"

@implementation UIColor (SHExtension)

#pragma mark 16进制颜色
+ (UIColor *)colorWithHexString:(NSString *)hexString{
    
    CGFloat alpha = 0.0, red = 0.0, blue = 0.0, green = 0.0;
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#"withString:@""] uppercaseString];
    
    switch ([colorString length]) {
        case 3: // #RGB
        {
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
        }
            break;
        case 4: // #ARGB
        {
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
        }
            break;
        case 6: // #RRGGBB
        {
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
        }
            break;
        case 8: // #AARRGGBB
        {
            alpha = [self colorComponentFrom:colorString start:0 length:2];
            red   = [self colorComponentFrom:colorString start:2 length:2];
            green = [self colorComponentFrom:colorString start:4 length:2];
            blue  = [self colorComponentFrom:colorString start:6 length:2];
        }
            break;
        default:
            break;
    }
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CGFloat)colorComponentFrom:(NSString *)string
                        start:(NSUInteger)start
                       length:(NSUInteger)length{
    
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

#pragma mark 获取颜色RGB
+ (NSArray *)getRGBWithColor:(UIColor *)color{
    
    //获得RGB值描述
    NSString *RGBValue = [NSString stringWithFormat:@"%@",color];
    //将RGB值描述分隔成字符串
    NSArray *RGBArr = [RGBValue componentsSeparatedByString:@" "];
    
    if (RGBArr.count == 3) {
        RGBArr = @[RGBArr[1],RGBArr[1],RGBArr[1],RGBArr[2]];
    }else{
        RGBArr = @[RGBArr[1],RGBArr[2],RGBArr[3],RGBArr[4]];
    }
    
    NSString *RGBStr;
    //获取 R
    float red = [RGBArr[0] floatValue];
    RGBStr = [NSString stringWithFormat:@"%f",red];
    //获取 G
    float green = [RGBArr[1] floatValue];
    RGBStr = [NSString stringWithFormat:@"%f",green];
    //获取 B
    float blue = [RGBArr[2] floatValue];
    RGBStr = [NSString stringWithFormat:@"%f",blue];
    //获取 alpha
    CGFloat alpha = [RGBArr[3] floatValue];
    
    //返回保存RGB值的数组
    return @[[NSString stringWithFormat:@"%f",red],[NSString stringWithFormat:@"%f",green],[NSString stringWithFormat:@"%f",blue],[NSString stringWithFormat:@"%f",alpha]];
}

#pragma mark 获取两种颜色的过渡色
+ (UIColor *)getTransitionColorWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor scale:(CGFloat)scale{
    
    //获取rgba颜色
    NSArray *startColorArr = [self getRGBWithColor:startColor];
    NSArray *endColorArr = [self getRGBWithColor:endColor];
    
    //(x + (y-x)*k)
    CGFloat red = [startColorArr[0] floatValue] + ([endColorArr[0] floatValue] - [startColorArr[0] floatValue])*scale;
    CGFloat green = [startColorArr[1] floatValue] + ([endColorArr[1] floatValue] - [startColorArr[1] floatValue])*scale;
    CGFloat blue = [startColorArr[2] floatValue] + ([endColorArr[2] floatValue] - [startColorArr[2] floatValue])*scale;
    CGFloat alpha = [startColorArr[3] floatValue] + ([endColorArr[3] floatValue] - [startColorArr[3] floatValue])*scale;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

//#pragma mark 获取图片颜色
//+ (UIColor *)getImageColor:(UIImage *)image{
//
//    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
//    CGSize thumbSize = CGSizeMake(image.size.width/2, image.size.height/2);
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//
//    CGContextRef context = CGBitmapContextCreate(NULL,
//                                                 thumbSize.width,
//                                                 thumbSize.height,
//                                                 8,
//                                                 thumbSize.width*4,
//                                                 colorSpace,
//                                                 kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast);
//    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
//    CGContextDrawImage(context, drawRect, image.CGImage);
//    CGColorSpaceRelease(colorSpace);
//
//    //第二步 取每个点的像素值
//    unsigned char* data = CGBitmapContextGetData (context);
//    if (data == NULL) return nil;
//    NSCountedSet *cls = [NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
//
//    for (int x=0; x<thumbSize.width; x++) {
//
//        for (int y=0; y<thumbSize.height; y++) {
//
//            int offset = 4*(x*y);
//            int red = data[offset];
//            int green = data[offset+1];
//            int blue = data[offset+2];
//            int alpha =  data[offset+3];
//
//            if (alpha) {
//                //去除透明
//                if (red == 255 && green == 255 && blue == 255) {//去除白色
//
//                }else{
//                    NSArray *clr=@[@(red),@(green),@(blue),@(alpha)];
//                    [cls addObject:clr];
//                }
//
//            }
//        }
//    }
//
//    CGContextRelease(context);
//
//    //第三步 找到出现次数最多的那个颜色
//    NSEnumerator *enumerator = [cls objectEnumerator];
//    NSArray *curColor = nil;
//    NSArray *MaxColor = nil;
//    NSUInteger MaxCount = 0;
//
//    while ((curColor = [enumerator nextObject])){
//
//        NSUInteger tmpCount = [cls countForObject:curColor];
//
//        if (tmpCount < MaxCount) continue;
//
//        MaxCount=tmpCount;
//        MaxColor=curColor;
//    }
//
//    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
//}

@end
