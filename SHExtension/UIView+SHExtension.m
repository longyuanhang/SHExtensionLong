//
//  UIView+SHExtension.m
//  SHExtension
//
//  Created by CSH on 2018/9/19.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "UIView+SHExtension.h"
#import "objc/runtime.h"

@implementation UIView (SHExtension)

static UIEdgeInsets _dragEdge;
static DragBlock _dragBlock;
static DragBlock _dragingBlock;
static UIPanGestureRecognizer *_panGesture;
static ClickBlock _clickBlock;

#pragma mark - frame
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (CGFloat)maxX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)maxY {
    return CGRectGetMaxY(self.frame);
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin.x = origin.x;
    frame.origin.y = origin.y;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

#pragma mark 获取控制器
- (UIViewController *)sh_vc {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark 通过视图获取一张图片
- (UIImage *)sh_img {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);

    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

#pragma mark 复制视图
- (UIView *)sh_copy {
    return [self copy_obj:self];
}

- (void)setDragEdge:(UIEdgeInsets)dragEdge {
    _dragEdge = dragEdge;
    [self configPan];
}

- (void)setDragBlock:(DragBlock)dragBlock {
    _dragBlock = dragBlock;
    [self configPan];
}

- (void)setDragingBlock:(DragBlock)dragingBlock {
    _dragingBlock = dragingBlock;
    [self configPan];
}

- (UIPanGestureRecognizer *)callBack {
    return objc_getAssociatedObject(self, &_panGesture);
}

- (void)configPan {
    if (!_panGesture) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [self addGestureRecognizer:pan];
        objc_setAssociatedObject(self, &_panGesture, pan, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

#pragma mark - 私有方法
#pragma mark 拖拽
- (void)panAction:(UIPanGestureRecognizer *)pan {
    switch (pan.state) {
        case UIGestureRecognizerStateChanged: {
            CGPoint point = [pan locationInView:self.superview];
            pan.view.center = point;
            if (_dragingBlock) {
                _dragingBlock(self);
            }
        } break;
        case UIGestureRecognizerStateEnded: {
            if (_dragBlock) {
                _dragBlock(pan.view);
                _dragBlock(self);
            } else {
                CGFloat x = self.x;
                CGFloat y = self.y;
                // X轴
                if (self.x < _dragEdge.left) {
                    x = _dragEdge.left;
                }
                if (self.maxX > self.superview.maxX - _dragEdge.right) {
                    x = self.superview.maxX - _dragEdge.right - self.width;
                }

                // Y轴
                if (self.y < _dragEdge.top) {
                    y = _dragEdge.top;
                }
                if (self.maxY > self.superview.maxY - _dragEdge.bottom) {
                    y = self.superview.maxY - _dragEdge.bottom - self.height;
                }

                [UIView animateWithDuration:0.1
                                 animations:^{
                                   self.origin = CGPointMake(x, y);
                                 }];
            }
        } break;
        default:
            break;
    }
}

#pragma mark 按照图片剪裁视图
- (void)setClippingImage:(UIImage *)clippingImage {
    dispatch_async(dispatch_get_main_queue(), ^{
      CALayer *maskLayer = [CALayer layer];
      maskLayer.frame = self.bounds;

      [maskLayer setContents:(id)clippingImage.CGImage];
      [maskLayer setContentsScale:clippingImage.scale];

      self.layer.mask = maskLayer;
    });
}

#pragma mark 添加点击
- (void)setClickBlock:(ClickBlock)clickBlock{
    _clickBlock = clickBlock;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    if (_clickBlock) {
        _clickBlock(tap);
    }
}

#pragma mark - 公开方法
#pragma mark 关闭拖拽
- (void)closeDrag {
    [self removeGestureRecognizer:_panGesture];
}

#pragma mark 描边
- (void)borderRadius:(CGFloat)radius {
    [self borderRadius:radius width:0 color:[UIColor clearColor]];
}

- (void)borderRadius:(CGFloat)radius width:(CGFloat)width color:(UIColor *)color {
    [self.layer setBorderWidth:(width)];
    [self.layer setCornerRadius:(radius)];
    [self.layer setBorderColor:[color CGColor]];
    [self.layer setMasksToBounds:YES];
}

- (void)borderRadius:(CGFloat)radius corners:(UIRectCorner)corners {
    [self layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

#pragma mark 虚线边框
- (void)drawDashedBorder:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth cornerRadius:(CGFloat)cornerRadius lineDashPattern:(NSArray<NSNumber *> *)lineDashPattern{
    [self layoutIfNeeded];
    NSString *name = @"SHDashedBorder";
    for (CAShapeLayer *obj in self.layer.sublayers) {
        if ([obj isKindOfClass:[CAShapeLayer class]]) {
            if ([obj.name isEqualToString:name]) {
                [obj removeFromSuperlayer];
            }
        }
    }
    
    CAShapeLayer *border = [CAShapeLayer layer];
    border.name = name;
    border.strokeColor = lineColor.CGColor;
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)].CGPath;
    border.frame = self.bounds;
    border.lineWidth = lineWidth;
    border.lineCap = @"square";
    border.lineDashPattern = lineDashPattern;
    [self.layer addSublayer:border];
}

#pragma mark 绘制虚线
- (void)drawDashed:(UIColor *)lineColor lineWidth:(CGFloat)lineWidth lineDashPattern:(NSArray<NSNumber *> *)lineDashPattern isHorizonal:(BOOL)isHorizonal{
    [self layoutIfNeeded];
    NSString *name = @"SHDashed";
    for (CAShapeLayer *obj in self.layer.sublayers) {
        if ([obj isKindOfClass:[CAShapeLayer class]]) {
            if ([obj.name isEqualToString:name]) {
                [obj removeFromSuperlayer];
            }
        }
    }
    
    CAShapeLayer *border = [CAShapeLayer layer];
    border.name = name;
    border.bounds = self.bounds;

    border.fillColor = nil;
    border.strokeColor = lineColor.CGColor;
    
    border.lineWidth = lineWidth;
    border.lineJoin = kCALineJoinRound;
    border.lineDashPattern = lineDashPattern;

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    if (isHorizonal) {
        border.position = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame));
        CGPathAddLineToPoint(path, NULL, CGRectGetWidth(self.frame), 0);
    } else {
        border.position = CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) / 2);
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(self.frame));
    }
    border.path = path;

    CGPathRelease(path);
    [self.layer addSublayer:border];
}

#pragma mark 获取一个渐变色的视图
+ (UIView *)getGradientViewWithSize:(CGSize)size startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint colorArr:(NSArray *)colorArr {
    UIView *view = [[UIView alloc] init];
    view.size = size;
    //  CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = colorArr;

    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;

    // 设置渐变位置
    CGFloat loc = 1.0 / (colorArr.count - 1);
    NSMutableArray *location = [[NSMutableArray alloc] init];
    [location addObject:@0];
    NSInteger index = 1;

    while (index != colorArr.count) {
        [location addObject:[NSNumber numberWithFloat:index * loc]];
        index++;
    }

    //设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = location;

    [view.layer addSublayer:gradientLayer];

    return view;
}

#pragma mark 按照图片裁剪视图
- (void)makeMaskViewWithImage:(UIImage *)image {
    dispatch_async(dispatch_get_main_queue(), ^{
      CALayer *maskLayer = [CALayer layer];
      maskLayer.frame = self.bounds;
      //把视图设置成图片的样子
      [maskLayer setContents:(id)image.CGImage];
      [maskLayer setContentsScale:image.scale];
      [maskLayer setContentsCenter:CGRectMake(((image.size.width / 2) - 1) / image.size.width,
                                              ((image.size.height / 1.5) - 1) / image.size.height,
                                              1 / image.size.width,
                                              1 / image.size.height)];

      self.layer.mask = maskLayer;
    });
}

#pragma mark 复制
- (id)copy_obj:(id)obj {
    NSData *temp = [NSKeyedArchiver archivedDataWithRootObject:obj];
    return [NSKeyedUnarchiver unarchiveObjectWithData:temp];
}

#pragma mark - xib 属性
#pragma mark 加载xib
+ (instancetype)loadXib {
    NSString *className = NSStringFromClass(self);
    return [[[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil] firstObject];
}

#pragma mark 设置边框宽度
- (void)setBorderWidth:(CGFloat)borderWidth {
    if (borderWidth < 0)
        return;
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

#pragma mark 设置边框颜色
- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

#pragma mark 设置圆角
- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

#pragma mark 剪切
- (void)setMasksToBounds:(BOOL)masksToBounds {
    self.layer.masksToBounds = masksToBounds;
}

- (BOOL)masksToBounds {
    return self.layer.masksToBounds;
}

#pragma mark 阴影颜色
- (void)setShadowColor:(UIColor *)shadowColor {
    self.layer.shadowColor = shadowColor.CGColor;
}

- (UIColor *)shadowColor {
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}

#pragma mark 阴影偏移
- (void)setShadowOffset:(CGSize)shadowOffset {
    self.layer.shadowOffset = shadowOffset;
}

- (CGSize)shadowOffset {
    return self.layer.shadowOffset;
}

#pragma mark 阴影透明度
- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    self.layer.shadowOpacity = shadowOpacity;
}

- (CGFloat)shadowOpacity {
    return self.layer.shadowOpacity;
}

#pragma mark 阴影半径
- (void)setShadowRadius:(CGFloat)shadowRadius {
    self.layer.shadowRadius = shadowRadius;
}

- (CGFloat)shadowRadius {
    return self.layer.shadowRadius;
}

#pragma mark 阴影路径
- (void)setShadowPath:(CGPathRef)shadowPath {
    self.layer.shadowPath = shadowPath;
}

- (CGPathRef)shadowPath {
    return self.layer.shadowPath;
}

#pragma mark 阴影位置
- (void)setShadowType:(SHViewShadowType)shadowType {
    CGRect frame = self.bounds;

    CGFloat space = self.shadowRadius / 4;

    switch (shadowType) {
        case SHViewShadowType_top: {
            frame = CGRectMake(space, -self.shadowRadius / 2, self.width - 2 * space, self.shadowRadius);
        } break;
        case SHViewShadowType_bottom: {
            frame = CGRectMake(space, self.height - self.shadowRadius / 2, self.width - 2 * space, self.shadowRadius);
        } break;
        case SHViewShadowType_left: {
            frame = CGRectMake(-self.shadowRadius / 2, space, self.shadowRadius, self.height - 2 * space);
        } break;
        case SHViewShadowType_right: {
            frame = CGRectMake(self.width - self.shadowRadius / 2, space, self.shadowRadius, self.height - 2 * space);
        } break;
        default:
            break;
    }

    self.shadowPath = [UIBezierPath bezierPathWithRect:frame].CGPath;
}

- (SHViewShadowType)shadowType {
    return SHViewShadowType_center;
}

@end
