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
#import "SHButton.h"

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
    
    [self.btn setTitle:@"123456789087654321345678654321" forState:UIControlStateNormal];
    [self.btn setImage:[[UIImage imageNamed:@"2.png"] imageWithSize:CGSizeMake(40, 30)] forState:UIControlStateNormal];
//    [self.btn imageDirection:SHButtonImageDirection_right space:10];

    NSString *str = [SHTool getInstantTimeWithMs:@"1610672356291"];
    NSLog(@"===%@",str);
    
    str = [SHTool handleVideoTime:@"1234"];
    NSLog(@"===%@",str);
    
    UIView *view = [[UIView alloc]init];
    view.size = CGSizeMake(100, 100);
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    view.dragEdge = UIEdgeInsetsMake(10, 10, 10, kSHWidth - view.width - 10);
    view.dragBlock = ^(UIView * _Nonnull dragView) {
        [UIView animateWithDuration:0.1 animations:^{
            dragView.x = kSHWidth - view.width - 10;
            CGFloat view_y = 10;
            if (dragView.y < view_y) {
                dragView.y = view_y;
            }
            view_y = self.view.height - dragView.height - 10;
            if (view.y > view_y) {
                dragView.y = view_y;
            }
        }];
    };
    
    UIView *view1 = [[UIView alloc]init];
    view1.frame = CGRectMake(150, 100, 100, 100);
    view1.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view1];
    [view1 makeMaskViewWithImage:[UIImage imageNamed:@"2.png"]];
    
    UIView *view2 = [[UIView alloc]init];
    view2.frame = CGRectMake(150, 250, 100, 50);
    view2.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:view2];
    
    view2.shadowColor = [UIColor redColor];
    view2.shadowOpacity = 1;
    view2.shadowRadius = 10;
    view2.shadowOffset = CGSizeMake(0, 0);
    view2.shadowType = SHViewShadowType_bottom;
    
    SHButton *btn = [[SHButton alloc]init];
    btn.timeInterval = 2;
    btn.y = 100;
    btn.x = 100;
    btn.size = CGSizeMake(40, 40);
    btn.backgroundColor = [UIColor orangeColor];
    [btn addClickBlock:^(UIButton * _Nonnull btn) {
        NSLog(@"点击了！！！！");
    }];
    [self.view addSubview:btn];

}

- (void)btnAction{
    NSLog(@"点击了！！！！");
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    //处理数据
    [SHTool handleTextField:textField shouldChangeCharactersInRange:range replacementString:string rule:@[@3,@4,@4]];
    //设置光标位置
    return NO;
}

@end
