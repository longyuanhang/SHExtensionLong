//
//  Palette.m
//
//  Created by dylan.tang on 17/4/11.
//  Copyright © 2017年 dylan.tang All rights reserved.
//

#import "Palette.h"
#import "PaletteSwatch.h"
#import "PriorityBoxArray.h"

const CGFloat resizeArea = 160 * 160;

int hist[32768];

@interface VBox()

@property (nonatomic,assign) NSInteger lowerIndex;

@property (nonatomic,assign) NSInteger upperIndex;

@property (nonatomic,strong) NSMutableArray *distinctColors;

@property (nonatomic,assign) NSInteger population;

@property (nonatomic,assign) NSInteger minRed;

@property (nonatomic,assign) NSInteger maxRed;

@property (nonatomic,assign) NSInteger minGreen;

@property (nonatomic,assign) NSInteger maxGreen;

@property (nonatomic,assign) NSInteger minBlue;

@property (nonatomic,assign) NSInteger maxBlue;

@end

@implementation VBox

- (instancetype)initWithLowerIndex:(NSInteger)lowerIndex upperIndex:(NSInteger)upperIndex colorArray:(NSMutableArray*)colorArray{
    self = [super init];
    if (self){
        
        _lowerIndex = lowerIndex;
        _upperIndex = upperIndex;
        _distinctColors = colorArray;
    
        [self fitBox];
        
    }
    return self;
}

- (NSInteger)getVolume{
    NSInteger volume = (_maxRed - _minRed + 1) * (_maxGreen - _minGreen + 1) *
    (_maxBlue - _minBlue + 1);
    return volume;
}

- (VBox*)splitBox{
    if (![self canSplit]) {
        return nil;
    }
    
    // find median along the longest dimension
    NSInteger splitPoint = [self findSplitPoint];
    
    VBox *newBox = [[VBox alloc]initWithLowerIndex:splitPoint+1 upperIndex:_upperIndex colorArray:_distinctColors];
    
    // Now change this box's upperIndex and recompute the color boundaries
    _upperIndex = splitPoint;
    [self fitBox];
    
    return newBox;
}

- (NSInteger)findSplitPoint{
    NSInteger longestDimension = [self getLongestColorDimension];
    
    // We need to sort the colors in this box based on the longest color dimension.
    // As we can't use a Comparator to define the sort logic, we modify each color so that
    // it's most significant is the desired dimension
    [self modifySignificantOctetWithDismension:longestDimension lowerIndex:_lowerIndex upperIndex:_upperIndex];
    
    [self sortColorArray];
    
    // Now revert all of the colors so that they are packed as RGB again
    [self modifySignificantOctetWithDismension:longestDimension lowerIndex:_lowerIndex upperIndex:_upperIndex];
    
    NSInteger midPoint = _population / 2;
    for (NSInteger i = _lowerIndex, count = 0; i <= _upperIndex; i++)  {
        NSInteger population = hist[[_distinctColors[i] intValue]];
        count += population;
        if (count >= midPoint) {
            return i;
        }
    }
    
    return _lowerIndex;
}

- (void)sortColorArray{
    
    // Now sort... Arrays.sort uses a exclusive toIndex so we need to add 1
    
    NSInteger sortCount = (_upperIndex - _lowerIndex) + 1;
    NSInteger sortArray[sortCount];
    NSInteger sortIndex = 0;
    
    for (NSInteger index = _lowerIndex;index<= _upperIndex ;index++){
        sortArray[sortIndex] = [_distinctColors[index] integerValue];
        sortIndex++;
    }
    
    NSInteger arrayLength = sortIndex;
    
    //bubble sort
    for(NSInteger i = 0; i < arrayLength-1; i++)
    {
        BOOL isSorted = YES;
        for(NSInteger j=0; j<arrayLength-1-i; j++)
        {
            if(sortArray[j] > sortArray[j+1])
            {
                isSorted = NO;
                NSInteger temp = sortArray[j];
                sortArray[j] = sortArray[j+1];
                sortArray[j+1]=temp;
            }
        }
        if(isSorted)
            break;
    }
    
    sortIndex = 0;
    for (NSInteger index = _lowerIndex;index<= _upperIndex ;index++){
        _distinctColors[index] = [NSNumber numberWithInteger:sortArray[sortIndex]];
        sortIndex++;
    }
}

/**
 * @return the dimension which this box is largest in
 */
- (NSInteger) getLongestColorDimension{
    NSInteger redLength = _maxRed - _minRed;
    NSInteger greenLength = _maxGreen - _minGreen;
    NSInteger blueLength = _maxBlue - _minBlue;
    
    if (redLength >= greenLength && redLength >= blueLength) {
        return 0;
    } else if (greenLength >= redLength && greenLength >= blueLength) {
        return 1;
    } else {
        return 2;
    }
}

/**
 * Modify the significant octet in a packed color int. Allows sorting based on the value of a
 * single color component. This relies on all components being the same word size.
 *
 * @see Vbox#findSplitPoint()
 */
- (void) modifySignificantOctetWithDismension:(NSInteger)dimension lowerIndex:(NSInteger)lower upperIndex:(NSInteger)upper{
    switch (dimension) {
        case 0:
            // Already in RGB, no need to do anything
            break;
        case 1:
            // We need to do a RGB to GRB swap, or vice-versa
            for (NSInteger i = lower; i <= upper; i++) {
                NSInteger color = [_distinctColors[i] intValue];
                NSInteger newColor = ((color >> 5) & 31) << (10)
                | ((color >> 10) & 31)  << 5 | (color & 31);
                _distinctColors[i] = [NSNumber numberWithInteger:newColor];
            }
            break;
        case 2:
            // We need to do a RGB to BGR swap, or vice-versa
            for (NSInteger i = lower; i <= upper; i++) {
                NSInteger color = [_distinctColors[i] intValue];
                NSInteger newColor =  (color & 31) << (10)
                | ((color >> 5) & 31)  << 5
                | ((color >> 10) & 31);
                _distinctColors[i] = [NSNumber numberWithInteger:newColor];
            }
            break;
    }
}

/**
 * @return the average color of this box.
 */
- (PaletteSwatch*)getAverageColor{
    NSInteger redSum = 0;
    NSInteger greenSum = 0;
    NSInteger blueSum = 0;
    NSInteger totalPopulation = 0;
    
    for (NSInteger i = _lowerIndex; i <= _upperIndex; i++) {
        NSInteger color = [_distinctColors[i] intValue];
        NSInteger colorPopulation = hist[color];
        
        totalPopulation += colorPopulation;
        
        redSum += colorPopulation * ((color >> 10) & 31);
        greenSum += colorPopulation * ((color >> 5) & 31);
        blueSum += colorPopulation * (color & 31);
    }
    
    //in case of totalPopulation equals to 0
    if (totalPopulation <= 0){
        return nil;
    }
    
    NSInteger redMean = redSum / totalPopulation;
    NSInteger greenMean = greenSum / totalPopulation;
    NSInteger blueMean = blueSum / totalPopulation;
    
    redMean = [VBox modifyWordWidthWithValue:redMean currentWidth:5 targetWidth:8];
    greenMean = [VBox modifyWordWidthWithValue:greenMean currentWidth:5 targetWidth:8];
    blueMean = [VBox modifyWordWidthWithValue:blueMean currentWidth:5 targetWidth:8];

    NSInteger rgb888Color = redMean << 2 * 8 | greenMean << 8 | blueMean;
    
    PaletteSwatch *swatch = [[PaletteSwatch alloc]initWithColorInt:rgb888Color population:totalPopulation];
    
    return swatch;
}

+ (NSInteger)modifyWordWidthWithValue:(NSInteger)value currentWidth:(NSInteger)currentWidth targetWidth:(NSInteger)targetWidth{
    NSInteger newValue;
    if (targetWidth > currentWidth) {
        // If we're approximating up in word width, we'll use scaling to approximate the
        // new value
        newValue = value * ((1 << targetWidth) - 1) / ((1 << currentWidth) - 1);
    } else {
        // Else, we will just shift and keep the MSB
        newValue = value >> (currentWidth - targetWidth);
    }
    return newValue & ((1 << targetWidth) - 1);
}

- (BOOL)canSplit{
    if ((_upperIndex - _lowerIndex) <= 0){
        return NO;
    }
    return YES;
}

- (void)fitBox{
    
    // Reset the min and max to opposite values
    NSInteger minRed, minGreen, minBlue;
    minRed = minGreen = minBlue = 32768;
    NSInteger maxRed, maxGreen, maxBlue;
    maxRed = maxGreen = maxBlue = 0;
    NSInteger count = 0;
    
    for (NSInteger i = _lowerIndex; i <= _upperIndex; i++) {
        NSInteger color = [_distinctColors[i] intValue];
        count += hist[color];
        
        NSInteger r = ((color >> 10) & 31);
        NSInteger g =  (color >> 5) & 31;
        NSInteger b =  color & 31;
        
        if (r > maxRed) {
            maxRed = r;
        }
        if (r < minRed) {
            minRed = r;
        }
        if (g > maxGreen) {
            maxGreen = g;
        }
        if (g < minGreen) {
            minGreen = g;
        }
        if (b > maxBlue) {
            maxBlue = b;
        }
        if (b < minBlue) {
            minBlue = b;
        }
    }
    
    _minRed = minRed;
    _maxRed = maxRed;
    _minGreen = minGreen;
    _maxGreen = maxGreen;
    _minBlue = minBlue;
    _maxBlue = maxBlue;
    _population = count;
}

@end

@interface Palette ()

@property (nonatomic,strong) PriorityBoxArray *priorityArray;

@property (nonatomic,strong) NSArray *swatchArray;

@property (nonatomic,assign) NSInteger maxPopulation;

@property (nonatomic,strong) NSMutableArray *distinctColors;

@property (nonatomic,assign) NSInteger pixelCount;

@property (nonatomic,copy) ColorBlock colorBlock;

@end

@implementation Palette

#pragma mark - 公共方法
- (void)startWithBlock:(ColorBlock)block{
    
    self.colorBlock = block;
    
    if (!_image){
        if (self.colorBlock ) {
            self.colorBlock(nil);
        }
        return;
    }
    
    [self startToAnalyzeImage];
}

- (void)startToAnalyzeImage{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [self clearHistArray];
        
        unsigned char *rawData = [self rawPixelDataFromImage:self.image];
        if (!rawData || !self.pixelCount){
            if (self.colorBlock) {
                self.colorBlock(nil);
            }
            return;
        }
        
        NSInteger red,green,blue;
        for (int pixelIndex = 0 ; pixelIndex < self.pixelCount; pixelIndex++){
            
            red   = (NSInteger)rawData[pixelIndex*4+0];
            green = (NSInteger)rawData[pixelIndex*4+1];
            blue  = (NSInteger)rawData[pixelIndex*4+2];
            
            //switch RGB888 to RGB555
            red = [VBox modifyWordWidthWithValue:red currentWidth:8 targetWidth:5];
            green = [VBox modifyWordWidthWithValue:green currentWidth:8 targetWidth:5];
            blue = [VBox modifyWordWidthWithValue:blue currentWidth:8 targetWidth:5];
            
            NSInteger quantizedColor = red << 2*5 | green << 5 | blue;
            hist [quantizedColor] ++;
        }
        
        free(rawData);
        
        NSInteger distinctColorCount = 0;
        NSInteger length = sizeof(hist)/sizeof(hist[0]);
        for (NSInteger color = 0 ; color < length ;color++){
            if (hist[color] > 0 && [self shouldIgnoreColor:color]){
                hist[color] = 0;
            }
            if (hist[color] > 0){
                distinctColorCount ++;
            }
        }
        
        NSInteger distinctColorIndex = 0;
        _distinctColors = [[NSMutableArray alloc]init];
        for (NSInteger color = 0; color < length ;color++){
            if (hist[color] > 0){
                [_distinctColors addObject: [NSNumber numberWithInteger:color]];
                distinctColorIndex++;
            }
        }
        
        // distinctColorIndex should be equal to (length - 1)
        distinctColorIndex--;
        
        if (distinctColorCount <= kMaxColorNum){
            NSMutableArray *swatchs = [[NSMutableArray alloc]init];
            for (NSInteger i = 0;i < distinctColorCount ; i++){
                NSInteger color = [_distinctColors[i] integerValue];
                NSInteger population = hist[color];
                
                NSInteger red = (color >> 10) & 31;
                NSInteger green = (color >> 5) & 31;
                NSInteger blue = (color) & 31;
                
                red = [VBox modifyWordWidthWithValue:red currentWidth:5 targetWidth:8];
                green = [VBox modifyWordWidthWithValue:green currentWidth:5 targetWidth:8];
                blue = [VBox modifyWordWidthWithValue:blue currentWidth:5 targetWidth:8];
                
                color = red << 2 * 8 | green << 8 | blue;
                
                PaletteSwatch *swatch = [[PaletteSwatch alloc]initWithColorInt:color population:population];
                [swatchs addObject:swatch];
            }
            
            _swatchArray = [swatchs copy];
        }else{
            _priorityArray = [[PriorityBoxArray alloc]init];
            VBox *colorVBox = [[VBox alloc]initWithLowerIndex:0 upperIndex:distinctColorIndex colorArray:_distinctColors];
            [_priorityArray addVBox:colorVBox];
            // split the VBox
            [self splitBoxes:_priorityArray];
            //Switch VBox to Swatch
            self.swatchArray = [self generateAverageColors:_priorityArray];
        }
        
        [self findMaxPopulation];
        
        [self getSwatchForTarget];
    });

}

- (void)splitBoxes:(PriorityBoxArray*)queue{
    //queue is a priority queue.
    while (queue.count < kMaxColorNum) {
        VBox *vbox = [queue poll];
        if (vbox != nil && [vbox canSplit]) {
            // First split the box, and offer the result
            [queue addVBox:[vbox splitBox]];
            // Then offer the box back
            [queue addVBox:vbox];
        }else{
            NSLog(@"All boxes split");
            return;
        }
    }
}

- (NSArray*)generateAverageColors:(PriorityBoxArray*)array{
    NSMutableArray *swatchs = [[NSMutableArray alloc]init];
    NSMutableArray *vboxArray = [array getVBoxArray];
    for (VBox *vbox in vboxArray){
        PaletteSwatch *swatch = [vbox getAverageColor];
        if (swatch){
            [swatchs addObject:swatch];
        }
    }
    return [swatchs copy];
}

#pragma mark - image compress

- (unsigned char *)rawPixelDataFromImage:(UIImage *)image{
    // Get cg image and its size
    
    CGImageRef cgImage = [image CGImage];
    NSUInteger width = CGImageGetWidth(cgImage);
    NSUInteger height = CGImageGetHeight(cgImage);
    
    // Allocate storage for the pixel data
    unsigned char *rawData = (unsigned char *)malloc(height * width * 4);
    
    // If allocation failed, return NULL
    if (!rawData) return NULL;
    
    // Create the color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Set some metrics
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    
    // Create context using the storage
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    // Release the color space
    CGColorSpaceRelease(colorSpace);
    
    // Draw the image into the storage
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
    
    // We are done with the context
    CGContextRelease(context);
    
    // Write pixel count to passed pointer
    self.pixelCount = (NSInteger)width * (NSInteger)height;
    
    // Return pixel data (needs to be freed)
    return rawData;
}

- (UIImage*)scaleDownImage:(UIImage*)image{
    
    CGImageRef cgImage = [image CGImage];
    NSUInteger width = CGImageGetWidth(cgImage);
    NSUInteger height = CGImageGetHeight(cgImage);
    double scaleRatio;
    CGFloat imageSize = width * height;
    if (imageSize > resizeArea){
        scaleRatio = resizeArea / ((double)imageSize);
        CGSize scaleSize = CGSizeMake((CGFloat)(width * scaleRatio),(CGFloat)(height * scaleRatio));
        UIGraphicsBeginImageContext(scaleSize);
        [_image drawInRect:CGRectMake(0.0f, 0.0f, scaleSize.width, scaleSize.height)];
        // 从当前context中创建一个改变大小后的图片
        UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
        return scaledImage;
    }else{
        return image;
    }
    
}

#pragma mark - utils method

- (void)clearHistArray{
    for (NSInteger i = 0;i<32768;i++){
        hist[i] = 0;
    }
}

- (BOOL)shouldIgnoreColor:(NSInteger)color{
    return NO;
}

- (void)findMaxPopulation{
    NSInteger max = 0;
    
    for (NSInteger i = 0; i <_swatchArray.count ; i++){
        PaletteSwatch *swatch = [_swatchArray objectAtIndex:i];
        NSInteger swatchPopulation = [swatch getPopulation];
        max =  MAX(max, swatchPopulation);
    }
    _maxPopulation = max;
}

#pragma mark - generate score

- (void)getSwatchForTarget{
    
    NSString *color;

        PaletteSwatch *swatch = [self getMaxScoredSwatch];
        
        if (swatch){
            color = [swatch getColorString];
            
            if (color && self.colorBlock){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.colorBlock(color);
                });
            }
        }
}

- (PaletteSwatch*)getMaxScoredSwatch{
    CGFloat maxScore = 0;
    PaletteSwatch *maxScoreSwatch = nil;
    for (NSInteger i = 0 ; i < _swatchArray.count; i++){
        PaletteSwatch *swatch = [_swatchArray objectAtIndex:i];
        if ([self shouldBeScoredForTarget:swatch]){
            CGFloat score = [self generateScoreForSwatch:swatch];
            if (maxScore == 0 || score > maxScore){
                maxScoreSwatch = swatch;
                maxScore = score;
            }
        }
    }
    return maxScoreSwatch;
}

- (BOOL)shouldBeScoredForTarget:(PaletteSwatch*)swatch{
    NSArray *hsl = [swatch getHsl];
    return [hsl[1] floatValue] >= 0.35 && [hsl[1] floatValue]<= 1
    && [hsl[2] floatValue]>= 0.3 && [hsl[2] floatValue] <= 0.7;
    
}

- (CGFloat)generateScoreForSwatch:(PaletteSwatch*)swatch{
    NSArray *hsl = [swatch getHsl];
    
    float saturationScore = 0.24 * (1.0f - fabsf([hsl[1] floatValue] - 0.35));
      float  luminanceScore = 0.52
        * (1.0f - fabsf([hsl[2] floatValue] - 1));
       float populationScore = 0.24
        * ([swatch getPopulation] / (float) _maxPopulation);
    
    return saturationScore + luminanceScore + populationScore;
}

@end
