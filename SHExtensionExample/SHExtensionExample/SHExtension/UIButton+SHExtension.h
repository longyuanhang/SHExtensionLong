//
//  UIButton+SHExtension.h
//  SHExtensionExample
//
//  Created by CCSH on 2020/11/17.
//  Copyright © 2020 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SHButtonImageDirection) {
    SHButtonImageDirectionTop,
    SHButtonImageDirectionLeft,
    SHButtonImageDirectionRight,
    SHButtonImageDirectionBottom,
};

@interface UIButton (SHExtension)

- (void)imageDirection:(SHButtonImageDirection)direction space:(CGFloat)space;

@end

NS_ASSUME_NONNULL_END
