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
#import "SHTool.h"
#import "UIButton+SHExtension.h"

@interface ViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"表情===%i",@"哈哈😄".isEmoji);
    [[UIImage imageNamed:@"1.jpeg"] imageCompressionWithByte:10*1024];
    [[UIImage imageNamed:@"2"] imageColorWithBlock:^(NSString *colorString) {
        if (colorString) {
            self.view.backgroundColor = [UIColor colorWithHexString:colorString];
        }
    }];
    [self.btn imageDirection:SHButtonImageDirection_top space:10];

    NSString *str = [SHTool getInstantTimeWithMs:@"1610672356291"];
    NSLog(@"===%@",str);
    
    str = [SHTool handleVideoTime:@"1234"];
    NSLog(@"===%@",str);
    
    UIView *view = [[UIView alloc]init];
    view.size = CGSizeMake(100, 100);
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    view.dragEdge = UIEdgeInsetsMake(10, 10, 10, 10);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    //处理数据
    [SHTool handleTextField:textField shouldChangeCharactersInRange:range replacementString:string rule:@[@3,@4,@4]];
    //设置光标位置
    return NO;
}

@end
