//
//  ViewController.m
//  SHExtensionExample
//
//  Created by CSH on 2018/9/20.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "ViewController.h"
#import "NSString+SHExtension.h"
#import "UIColor+SHExtension.h"
#import "UIView+SHExtension.h"
#import "UIImage+SHExtension.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage getImageWithSize:CGSizeMake(300, 50) colorArr:@[(__bridge id)[UIColor orangeColor].CGColor,(__bridge id)[UIColor redColor].CGColor]]];
    imgView.origin = CGPointMake(50, 100);
    [self.view addSubview:imgView];
}

@end
