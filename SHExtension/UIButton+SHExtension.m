//
//  UIButton+SHExtension.m
//  SHExtensionExample
//
//  Created by CCSH on 2020/11/17.
//  Copyright © 2020 CSH. All rights reserved.
//

#import "UIButton+SHExtension.h"
#import <objc/runtime.h>

@interface UIButton ()

//是否忽略响应事件
@property (nonatomic, assign) BOOL isIgnoreEvent;

@end

static BtnBlock _callBack;

@implementation UIButton (SHExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      SEL selA = @selector(sendAction:to:forEvent:);
      SEL selB = @selector(mySendAction:to:forEvent:);
      Method methodA = class_getInstanceMethod(self, selA);
      Method methodB = class_getInstanceMethod(self, selB);
      BOOL isAdd = class_addMethod(self, selA, method_getImplementation(methodB), method_getTypeEncoding(methodB));
      if (isAdd) {
          class_replaceMethod(self, selB, method_getImplementation(methodA), method_getTypeEncoding(methodA));
      } else {
          method_exchangeImplementations(methodA, methodB);
      }
    });
}

- (void)imageDirection:(SHButtonImageDirection)direction space:(CGFloat)space {
    CGFloat imageWidth, imageHeight, textWidth, textHeight, x, y, offset_h;
    imageWidth = self.currentImage.size.width;
    imageHeight = self.currentImage.size.height;

    [self.titleLabel sizeToFit];

    textWidth = self.titleLabel.frame.size.width;
    textHeight = self.titleLabel.frame.size.height;

    space = space / 2;
    offset_h = MIN(textHeight, imageHeight) / 2 + space;
    switch (direction) {
        case SHButtonImageDirection_top: {
            x = textHeight / 2 + space;
            y = textWidth / 2;
            self.imageEdgeInsets = [self setUIEdgeInsets:CGPointMake(-x, y)];
            x = imageHeight / 2 + space;
            y = imageWidth / 2;
            self.titleEdgeInsets = [self setUIEdgeInsets:CGPointMake(x, -y)];
            self.contentEdgeInsets = UIEdgeInsetsMake(offset_h, 0, offset_h, 0);
        } break;
        case SHButtonImageDirection_bottom: {
            x = textHeight / 2 + space;
            y = textWidth / 2;
            self.imageEdgeInsets = [self setUIEdgeInsets:CGPointMake(x, y)];
            x = imageHeight / 2 + space;
            y = imageWidth / 2;
            self.titleEdgeInsets = [self setUIEdgeInsets:CGPointMake(-x, -y)];
            self.contentEdgeInsets = UIEdgeInsetsMake(offset_h, 0, offset_h, 0);
        } break;
        case SHButtonImageDirection_left: {
            self.imageEdgeInsets = [self setUIEdgeInsets:CGPointMake(0, -space)];
            self.titleEdgeInsets = [self setUIEdgeInsets:CGPointMake(0, space)];
            self.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, space * 2);
        } break;
        case SHButtonImageDirection_right: {
            self.imageEdgeInsets = [self setUIEdgeInsets:CGPointMake(0, space + textWidth)];
            self.titleEdgeInsets = [self setUIEdgeInsets:CGPointMake(0, -(space + imageWidth))];
            self.contentEdgeInsets = UIEdgeInsetsMake(0, space, 0, space);
        } break;
        default:
            break;
    }
}

- (UIEdgeInsets)setUIEdgeInsets:(CGPoint)point {
    return UIEdgeInsetsMake(point.x, point.y, -point.x, -point.y);
}

- (void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if ([NSStringFromClass(self.class) isEqualToString:@"UIButton"]) {
        if (self.isIgnoreEvent) {
            return;
        }

        if (self.timeInterval > 0) {
            self.isIgnoreEvent = YES;
            [self performSelector:@selector(setIsIgnoreEvent:) withObject:@(NO) afterDelay:self.timeInterval];
        }
    }
    [self mySendAction:action to:target forEvent:event];
}

// MARK: - 运行时设置分类属性
- (NSTimeInterval)timeInterval {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    objc_setAssociatedObject(self, @selector(timeInterval), @(timeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isIgnoreEvent {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsIgnoreEvent:(BOOL)isIgnoreEvent {
    objc_setAssociatedObject(self, @selector(isIgnoreEvent), @(isIgnoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 添加点击
- (void)addClickBlock:(BtnBlock)block{
    [self addAction:UIControlEventTouchUpInside block:block];
}

#pragma mark - 添加事件
- (void)addAction:(UIControlEvents)events block:(BtnBlock)block{
    [self setCallBack:block];
    [self addTarget:self action:@selector(btnAction:) forControlEvents:events];
}

- (void)setCallBack:(BtnBlock)callBack {
    objc_setAssociatedObject(self, &_callBack, callBack, OBJC_ASSOCIATION_COPY);
}

- (BtnBlock)callBack {
    return objc_getAssociatedObject(self, &_callBack);
}

- (void)btnAction:(UIButton *)btn{
    
    if (self.isIgnoreEvent) {
        return;
    }

    if (self.timeInterval > 0) {
        self.isIgnoreEvent = YES;
        [self performSelector:@selector(setIsIgnoreEvent:) withObject:@(NO) afterDelay:self.timeInterval];
    }
    
    if (self.callBack) {
        self.callBack(btn);
    }
}

@end
