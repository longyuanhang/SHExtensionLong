//
//  UIButton+SHExtension.m
//  SHExtensionExample
//
//  Created by CCSH on 2020/11/17.
//  Copyright © 2020 CSH. All rights reserved.
//

#import "UIButton+SHExtension.h"

@implementation UIButton (SHExtension)

static BtnBlock _callBack;

- (void)imageDirection:(SHButtonImageDirection)direction space:(CGFloat)space {
    CGFloat imageWidth, imageHeight, textWidth, textHeight, x, y;
    imageWidth = self.currentImage.size.width;
    imageHeight = self.currentImage.size.height;
    [self.titleLabel sizeToFit];
    textWidth = self.titleLabel.frame.size.width;
    textHeight = self.titleLabel.frame.size.height;
    space = space / 2;
    switch (direction) {
        case SHButtonImageDirection_top: {
            x = textHeight / 2 + space;
            y = textWidth / 2;
            self.imageEdgeInsets = [self setUIEdgeInsets:CGPointMake(-x, y)];
            x = imageHeight / 2 + space;
            y = imageWidth / 2;
            self.titleEdgeInsets = [self setUIEdgeInsets:CGPointMake(x, -y)];
            ;
        } break;
        case SHButtonImageDirection_bottom: {
            x = textHeight / 2 + space;
            y = textWidth / 2;
            self.imageEdgeInsets = [self setUIEdgeInsets:CGPointMake(x, y)];
            x = imageHeight / 2 + space;
            y = imageWidth / 2;
            self.titleEdgeInsets = [self setUIEdgeInsets:CGPointMake(-x, -y)];
        } break;
        case SHButtonImageDirection_left: {
            self.imageEdgeInsets = [self setUIEdgeInsets:CGPointMake(0, -space)];
            self.titleEdgeInsets = [self setUIEdgeInsets:CGPointMake(0, space)];
        } break;
        case SHButtonImageDirection_right: {
            self.imageEdgeInsets = [self setUIEdgeInsets:CGPointMake(0, space + textWidth)];
            self.titleEdgeInsets = [self setUIEdgeInsets:CGPointMake(0, -(space + imageWidth))];
        } break;
        default:
            break;
    }
}

- (UIEdgeInsets)setUIEdgeInsets:(CGPoint)point {
    return UIEdgeInsetsMake(point.x, point.y, -point.x, -point.y);
}

#pragma mark - 添加点击
- (void)addClickBlock:(BtnBlock)block{
    [self addAction:UIControlEventTouchUpInside block:block];
}

#pragma mark - 添加事件
- (void)addAction:(UIControlEvents)events block:(BtnBlock)block{
    _callBack = block;
    [self addTarget:self action:@selector(btnAction:) forControlEvents:events];
}

- (void)btnAction:(UIButton *)btn{
    if (_callBack) {
        _callBack(btn);
    }
}

@end
