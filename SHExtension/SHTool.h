//
//  SHTool.h
//  SHExtensionExample
//
//  Created by CSH on 2019/8/6.
//  Copyright © 2019 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kSHMinutes (60)
#define kSHHours (60*kSHMinutes)
#define kSHDay (24*kSHHours)

static NSString *sh_fomat_1 = @"YYYY-MM-dd HH:mm:ss";
static NSString *sh_fomat_2 = @"YYYY.MM.dd";
static NSString *sh_fomat_3 = @"YYYY.MM.dd HH:mm";
static NSString *sh_fomat_4 = @"YYYY/MM/dd";
static NSString *sh_fomat_5 = @"YYYY-MM-dd HH:mm";
static NSString *sh_fomat_6 = @"YYYY-MM-dd";
static NSString *sh_fomat_7 = @"YYYY-MM-dd HH:mm:ss:SSS";
static NSString *sh_fomat_8 = @"YYYY-MM-dd-HH-mm-ss-SSS";
static NSString *sh_fomat_9 = @"MM-dd";
static NSString *sh_fomat_10 = @"HH:mm";

@interface SHTool : NSObject

#pragma mark - 时间戳
#pragma mark 获取当前时间戳
+ (NSString *)getTimeMs;
#pragma mark 时间戳转换
+ (NSString *)getMsWithTime:(NSString *)time format:(NSString *)format;
+ (NSString *)getMsWithTime:(NSString *)time format:(NSString *)format GMT:(NSInteger)GMT;
+ (NSString *)getMsWithDate:(NSDate *)date;

#pragma mark - 格式time
#pragma mark 获取当前格式time
+ (NSString *)getTimeWithformat:(NSString *)format;
+ (NSString *)getTimeWithformat:(NSString *)format GMT:(NSInteger)GMT;
#pragma mark 转换time
+ (NSString *)getTimeWithMs:(NSString *)ms format:(NSString *)format;
+ (NSString *)getTimeWithMs:(NSString *)ms format:(NSString *)format GMT:(NSInteger)GMT;
+ (NSString *)getTimeWithDate:(NSDate *)date format:(NSString *)format;
+ (NSString *)getTimeWithDate:(NSDate *)date format:(NSString *)format GMT:(NSInteger)GMT;
#pragma mark 获取指定格式time
+ (NSString *)getTimeWithTime:(NSString *)time currentFormat:(NSString *)currentFormat format:(NSString *)format;

#pragma mark - date
#pragma mark 转换date
+ (NSDate *)getDateWithMs:(NSString *)ms;
+ (NSDate *)getDateWithTime:(NSString *)time format:(NSString *)format;
+ (NSDate *)getDateWithTime:(NSString *)time format:(NSString *)format GMT:(NSInteger)GMT;

#pragma mark - 获取即时时间
+ (NSString *)getInstantTimeWithMs:(NSString *)ms;
+ (NSString *)getInstantTimeWithDate:(NSDate *)date;
+ (NSString *)getInstantTimeWithTime:(NSString *)time format:(NSString *)format;
+ (NSString *)getInstantTimeWithTime:(NSString *)time format:(NSString *)format GMT:(NSInteger)GMT;

#pragma mark - 时间其他方法
#pragma mark 当前时区
+ (NSInteger)getCurrentGMT;

#pragma mark 处理时间戳(13位毫秒)
+ (NSString *)handleMs:(NSString *)str;

#pragma mark - 计算方法
#pragma mark 计算富文本的size
+ (CGSize)getSizeWithAtt:(NSAttributedString *)att
                 maxSize:(CGSize)maxSize;

#pragma mark 计算字符串的size
+ (CGSize)getSizeWithStr:(NSString *)str
                    font:(UIFont *)font
                 maxSize:(CGSize)maxSize;

#pragma mark 是否超过是否超过规定高度
+ (BOOL)isLineWithAtt:(NSAttributedString *)att lineH:(CGFloat)lineH maxW:(CGFloat)maxW;

#pragma mark 获取真实行间距
+ (CGFloat)lineSpaceWithLine:(CGFloat)line font:(UIFont *)font;

#pragma mark 获取属性字符串真实行间距
+ (CGFloat)lineSpaceWithLineWithAtt:(NSAttributedString *)att line:(CGFloat)line font:(UIFont *)font maxW:(CGFloat)maxW;

#pragma mark - 其他方法
#pragma mark 处理个数
+ (NSString *)handleCount:(NSString *)count;

#pragma mark 处理金额(千分符 小数点后两位)
+ (NSString *)handleMoneyWithStr:(NSString *)str;

#pragma mark 处理价格(小数点后两位)
+ (NSString *)handlePriceWithStr:(NSString *)str;

#pragma mark 处理时间
+ (NSString *)handleTime:(NSString *)str format:(NSCalendarUnit)format;
#pragma mark 处理视频时间(默认：分秒)
+ (NSString *)handleTime:(NSString *)str;

#pragma mark 获取一个渐变色的视图
+ (UIView *)getGradientViewWithSize:(CGSize)size colorArr:(NSArray *)colorArr;
+ (UIView *)getGradientViewWithSize:(CGSize)size startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint colorArr:(NSArray *)colorArr;

#pragma mark 格式化TextField字符串
+ (void)handleTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string rule:(NSArray *)rule;

#pragma mark 格式化字符串
/// 格式化字符串
/// @param text 内容
/// @param rule 格式([@"3",@"4",@"4"])
+ (NSString *)handleStrWithText:(NSString *)text rule:(NSArray *)rule;

#pragma mark 获取某个字符在字符串中出现的次数
+ (NSInteger)appearCountWithStr:(NSString *)str target:(NSString *)target;

#pragma mark 获取最上方控制器
+ (UIViewController *)getCurrentVC;

#pragma mark 获取window
+ (UIWindow *)getWindow;

#pragma mark 获取url的参数
+ (NSDictionary *)getUrlParam:(NSString *)str;

#pragma mark 获取推送Token
+ (NSString *)getDeviceToken:(NSData *)deviceToken;

#pragma mark 底部安全H
+ (CGFloat)getSafeBottomH;

#pragma mark 顶部安全H
+ (CGFloat)getSafeTopH;

#pragma mark 状态栏H
+ (CGFloat)getStatusBarFrameH;

#pragma mark app名字
+ (NSString *)appName;

#pragma mark 拨打电话
+ (void)callPhone:(NSString *_Nonnull)phone;

#pragma mark 获取文件夹（没有的话创建）
+ (NSString *)getCreateFilePath:(NSString *)path;

#pragma mark 更换图标
+ (void)changeIcon:(NSString *)icon;

#pragma mark 坐标生成路径
+ (CGPathRef)pathFromPoints:(NSArray *)points;

#pragma mark - 权限获取
#pragma mark 麦克风权限
+ (void)requestMicrophoneaPemissionsWithResult:(void(^)( BOOL granted))completion;

#pragma mark 相机权限
+ (void)requestCameraPemissionsWithResult:(void(^)( BOOL granted))completion;

@end

NS_ASSUME_NONNULL_END
