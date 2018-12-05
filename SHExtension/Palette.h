//
//  TRIPPalette.h
//  Atom
//
//  Created by dylan.tang on 17/4/11.
//  Copyright © 2017年 dylan.tang All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static const NSInteger kMaxColorNum = 16;

typedef void(^ColorBlock)(NSString *colorString);

@interface Palette : NSObject

@property (nonatomic, strong) UIImage *image;

- (void)startWithBlock:(ColorBlock)block;

@end

@interface VBox : NSObject

- (NSInteger)getVolume;

@end
