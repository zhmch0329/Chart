//
//  ZMCLineChartView.m
//  Chart
//
//  Created by zhmch0329 on 13-11-24.
//  Copyright (c) 2013年 zhmch0329. All rights reserved.
//

#import "ZMCLineChartView.h"

#define kZMCCoordinateXHeight 260
#define kZMCCoordinateYHeight 200
#define kZMCCoordinateSignWidth 4
#define kZMCCoordinateOrigin CGPointMake(40, 240)

@implementation ZMCLineChartView

@synthesize lineColors;
@synthesize columnNames;
@synthesize data;
@synthesize dataType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40)];
        dataLabel.backgroundColor = [UIColor clearColor];
        dataLabel.textColor = [UIColor blackColor];
        dataLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:dataLabel];
        
        // 添加单机到手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // 数据中最大的数
    NSInteger maxYValue = [self maximumYValue:self.data];
    
    // 画出坐标系
    [self drawBarCoordinate:kZMCCoordinateOrigin];
    
    CGFloat distanceY = kZMCCoordinateYHeight/6;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    // 画y轴显示的数据
    for (int i = 0; i < 6; i ++) {
        CGRect yRect = CGRectMake(kZMCCoordinateOrigin.x - 28, kZMCCoordinateOrigin.y - i * distanceY - 8, 26, 10);
        NSString *y = [NSString stringWithFormat:@"%d", i * maxYValue/5];
        [y drawInRect:yRect withFont:[UIFont systemFontOfSize:10] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
    }
    // 画出x轴显示的数据
    CGFloat distanceX = kZMCCoordinateXHeight/self.columnNames.count;
    for (int i = 0; i < self.columnNames.count; i ++) {
        CGRect xRect = CGRectMake(kZMCCoordinateOrigin.x + distanceX * i, kZMCCoordinateOrigin.y + 4, distanceX, 10);
        NSString *x = [self.columnNames objectAtIndex:i];
        [x drawInRect:xRect withFont:[UIFont systemFontOfSize:10] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
    }
}

- (void)drawBarCoordinate:(CGPoint)point
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 画x和y轴
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextMoveToPoint(context, point.x, point.y);
    CGContextAddLineToPoint(context, point.x, point.y - kZMCCoordinateYHeight);
    CGContextMoveToPoint(context, point.x, point.y);
    CGContextAddLineToPoint(context, point.x + kZMCCoordinateXHeight, point.y);
    CGContextStrokePath(context);
    
    // 画y轴的箭头
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextMoveToPoint(context, point.x, point.y - kZMCCoordinateYHeight);
    CGContextAddLineToPoint(context, point.x - 4, point.y - kZMCCoordinateYHeight + 6);
    CGContextAddLineToPoint(context, point.x, point.y - kZMCCoordinateYHeight - 8);
    CGContextAddLineToPoint(context, point.x + 4, point.y - kZMCCoordinateYHeight + 6);
    CGContextAddLineToPoint(context, point.x, point.y - kZMCCoordinateYHeight);
    CGContextFillPath(context);
    
    // 画y轴显示的标记
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 0.4);
    CGFloat distance = kZMCCoordinateYHeight/6;
    for (int i = 1; i < 6; i ++) {
        CGContextMoveToPoint(context, point.x, point.y - distance * i);
        CGContextAddLineToPoint(context, point.x + kZMCCoordinateSignWidth, point.y - distance * i);
    }
    CGContextStrokePath(context);
    
    // 画x轴的箭头
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextMoveToPoint(context, point.x + kZMCCoordinateXHeight, point.y);
    CGContextAddLineToPoint(context, point.x + kZMCCoordinateXHeight - 6, point.y - 4);
    CGContextAddLineToPoint(context, point.x + kZMCCoordinateXHeight + 8, point.y);
    CGContextAddLineToPoint(context, point.x + kZMCCoordinateXHeight - 6, point.y + 4);
    CGContextAddLineToPoint(context, point.x + kZMCCoordinateXHeight, point.y);
    CGContextFillPath(context);
}

- (float)maximumYValue:(NSArray *)array
{
    float max = 0;
    for (NSArray *a in array) {
        for (NSString *str in a) {
            float a = [str floatValue];
            if (a > max) {
                max = a;
            }
        }
    }
    if (max <= 10) {
        max = 10;
    }
    else if (max <= 100) {
        max = 100;
    }
    else {
        max = ((int)max)/100 * 100 + 100;
    }
    return max;
}

// 开始加载数据
- (void)startLoadingData
{
    CGFloat distanceX = kZMCCoordinateXHeight/self.columnNames.count;
    // 数据中最大的数
    NSInteger maxYValue = [self maximumYValue:self.data];
    CGFloat YValue = maxYValue/(5.0 * kZMCCoordinateYHeight / 6.0);
    
    points = [[NSMutableArray alloc] initWithCapacity:self.dataType];
    
    for (int j = 0; j < self.dataType; j ++) {
        float firstValue = [[[self.data objectAtIndex:j] objectAtIndex:0] floatValue];
        CGPoint firstPoint = CGPointMake(kZMCCoordinateOrigin.x + distanceX / 2, kZMCCoordinateOrigin.y - firstValue / YValue + 1);
        NSMutableArray *pointArray = [[NSMutableArray alloc] init];
        [pointArray addObject:[NSValue valueWithCGPoint:firstPoint]];
        
        NSArray *array = [self.data objectAtIndex:j];
        
        // 创建贝塞尔曲线，创建数据的折线路径
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:firstPoint];
        // 设置线宽
        bezierPath.lineWidth = 3.0f;
        for (int i = 1; i < self.columnNames.count; i ++) {
            float dataValue = [[array objectAtIndex:i] floatValue];
            CGPoint nextPoint = CGPointMake(kZMCCoordinateOrigin.x + distanceX / 2 + distanceX * i, kZMCCoordinateOrigin.y - dataValue/YValue + 1);
            [pointArray addObject:[NSValue valueWithCGPoint:nextPoint]];
            [bezierPath addLineToPoint:nextPoint];
        }
        [points addObject:pointArray];
        
        CAShapeLayer *shaperLayer = [[CAShapeLayer alloc] init];
        shaperLayer.path = bezierPath.CGPath;
        shaperLayer.fillColor = [UIColor clearColor].CGColor;
        shaperLayer.strokeColor = ((UIColor *)[lineColors objectAtIndex:j]).CGColor;
        shaperLayer.lineWidth = bezierPath.lineWidth;
        shaperLayer.lineCap = kCALineCapRound;
        shaperLayer.strokeEnd = 0.0f;
        [self.layer addSublayer:shaperLayer];
        
        // 执行加载动画
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        basicAnimation.duration = 1.5f;
        basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        basicAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        basicAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        [shaperLayer addAnimation:basicAnimation forKey:@"strokeEndAnimation"];
        shaperLayer.strokeEnd = 1.0f;
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)gesture
{
    CGPoint touchPoint = [gesture locationInView:self];
    for (NSInteger i = 0; i < self.dataType; i ++) {
        NSArray * array = [points objectAtIndex:i];
        for (NSValue *value in array) {
            CGPoint point = [value CGPointValue];
            CGFloat distance = sqrtf((touchPoint.x - point.x) * (touchPoint.x - point.x) + (touchPoint.y - point.y) * (touchPoint.y - point.y));
            if (distance <= 10) {
                NSInteger j = [array indexOfObject:value];
                dataLabel.textColor = [lineColors objectAtIndex:i];
                dataLabel.text = [NSString stringWithFormat:@"%@：%.2f", [self.columnNames objectAtIndex:j], [(NSString *)[[self.data objectAtIndex:i] objectAtIndex:j] floatValue]];
            }
        }
    }
}

@end
