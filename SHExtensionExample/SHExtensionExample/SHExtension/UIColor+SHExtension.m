//
//  UIColor+SHExtension.m
//  SHExtension
//
//  Created by CSH on 2018/9/20.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "UIColor+SHExtension.h"

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
    
    NSString *RGBStr;
    //获取 R
    CGFloat red = [RGBArr[1] floatValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%f",red];
    //获取 G
    CGFloat green = [RGBArr[2] floatValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%f",green];
    //获取 B
    CGFloat blue = [RGBArr[3] floatValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%f",blue];
    //获取 alpha
    CGFloat alpha = [RGBArr[4] floatValue];
    
    //返回保存RGB值的数组
    return @[[NSString stringWithFormat:@"%f",red],[NSString stringWithFormat:@"%f",green],[NSString stringWithFormat:@"%f",blue],[NSString stringWithFormat:@"%f",alpha]];
}

@end
