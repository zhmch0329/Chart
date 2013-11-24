//
//  ZMCPieChartView.m
//  Chart
//
//  Created by zhmch0329 on 13-11-24.
//  Copyright (c) 2013年 zhmch0329. All rights reserved.
//

#import "ZMCPieChartView.h"

#define kZMCSectorCenter CGPointMake(160, 150)
#define kZMCSectorBigRadius 100
#define kZMCSectorSmallRadius 40

@interface ZMCSectorLayer : CALayer
{
    CGFloat startAngle;
    CGFloat endAngle;
    CGColorRef fillColor;
    CGPoint center;
    BOOL isSelected;
    NSString *name;
    CGFloat percentage;
}

@property (nonatomic) CGFloat startAngle;
@property (nonatomic) CGFloat endAngle;
@property (nonatomic) CGColorRef fillColor;
@property (nonatomic) CGPoint center;
@property (nonatomic) BOOL isSelected;
@property (copy, atomic) NSString *name;
@property (nonatomic) CGFloat percentage;

@end

@implementation ZMCSectorLayer

@synthesize startAngle, endAngle, percentage;
@synthesize fillColor;
@synthesize center;
@synthesize isSelected;
@synthesize name;

// 实现父类方法，深度复制
- (id)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    if (self) {
        ZMCSectorLayer *sector = (ZMCSectorLayer *)layer;
        self.startAngle = sector.startAngle;
        self.endAngle = sector.endAngle;
        self.fillColor = sector.fillColor;
        self.center = sector.center;
        self.isSelected = sector.isSelected;
        self.percentage = sector.percentage;
        self.name = sector.name;
    }
    return self;
}

// 判断那些kay需要重新加载
+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"endAngle"] || [key isEqualToString:@"center"]) {
        return YES;
    }
    else {
        return [super needsDisplayForKey:key];
    }
}

// 返回对应到key到动画
- (id<CAAction>)actionForKey:(NSString *)event
{
    if ([event isEqualToString:@"endAngle"] || [event isEqualToString:@"center"]) {
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:event];
        basicAnimation.duration = 0.5f;
        basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        return basicAnimation;
    }
    return [super actionForKey:event];
}

// 重新加载时执行的方法
- (void)drawInContext:(CGContextRef)ctx
{
    // 添加一段路径
    CGMutablePathRef path = CGPathCreateMutable();
    // 在路径中添加一段弧线
    CGPathAddArc(path, NULL, center.x, center.y, kZMCSectorBigRadius, startAngle, endAngle, NO);
    CGPathAddArc(path, NULL, center.x, center.y, kZMCSectorSmallRadius, endAngle, startAngle, YES);
    // 将路径闭合
    CGPathCloseSubpath(path);
    // 在上下文中添加路径
    CGContextAddPath(ctx, path);
    // 设置填充的颜色
    CGContextSetFillColorWithColor(ctx, fillColor);
    // 以什么样到方式描绘路径
    if (isSelected) {
        CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 10, [UIColor blackColor].CGColor);
        CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    }
    else {
        CGContextSetLineWidth(ctx, 0.5);
        CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    }
    // 画出路径的画面（填充和描边）
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

@end

@implementation ZMCPieChartView

@synthesize pieColors;
@synthesize columnNames;
@synthesize data;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        // 初始化颜色
        pieColors = [NSArray arrayWithObjects:
                     [UIColor colorWithRed:93.0f/255.0f green:150.0f/255.0f blue:72.0f/255.0f alpha:1.0f],
                     [UIColor colorWithRed:46.0f/255.0f green:87.0f/255.0f blue:140.0f/255.0f alpha:1.0f],
                     [UIColor colorWithRed:231.0f/255.0f green:161.0f/255.0f blue:61.0f/255.0f alpha:1.0f],
                     [UIColor colorWithRed:188.0f/255.0f green:45.0f/255.0f blue:48.0f/255.0f alpha:1.0f],
                     [UIColor colorWithRed:111.0f/255.0f green:61.0f/255.0f blue:121.0f/255.0f alpha:1.0f],
                     [UIColor colorWithRed:125.0f/255.0f green:128.0f/255.0f blue:127.0f/255.0f alpha:1.0f],
                     nil];
        
        // 初始化存储layer到数组
        layerArray = [[NSMutableArray alloc] initWithCapacity:self.columnNames.count];
        
        // 在中间到圆中添加一个label，显示数据类型
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kZMCSectorCenter.x - kZMCSectorSmallRadius/sqrtf(2) - 5, kZMCSectorCenter.y - kZMCSectorSmallRadius/sqrtf(2) + 5, 2 * kZMCSectorSmallRadius/sqrtf(2) + 10, kZMCSectorSmallRadius/sqrtf(2))];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.text = @"";
        [self addSubview:nameLabel];
        
        // 添加一个label现实百分比
        percentageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kZMCSectorCenter.x - kZMCSectorSmallRadius/sqrtf(2), kZMCSectorCenter.y + 5, 2 * kZMCSectorSmallRadius/sqrtf(2), 10)];
        percentageLabel.textAlignment = NSTextAlignmentCenter;
        percentageLabel.backgroundColor = [UIColor clearColor];
        percentageLabel.font = [UIFont systemFontOfSize:10];
        //        percentageLabel.text = @"10.0%";
        [self addSubview:percentageLabel];
        
        // 添加单机到手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [self addGestureRecognizer:tapGesture];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // 获取当前到上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 设置中间到圆到矩形
    CGRect centerRect = CGRectMake(kZMCSectorCenter.x - kZMCSectorSmallRadius, kZMCSectorCenter.y - kZMCSectorSmallRadius, 2 * kZMCSectorSmallRadius, 2 * kZMCSectorSmallRadius);
    // 添加一个椭圆（此处为添加一个圆）
    CGContextAddEllipseInRect(context, centerRect);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillPath(context);
}

// 开始加载数据方法
- (void)startLoadingData
{
    CGFloat angle = 0.0f;
    percentages = [self percentageColumn:self.data];
    // 初始化一系列到扇形区域
    for (NSInteger i = 0; i < percentages.count; i ++) {
        CGFloat percentage = [[percentages objectAtIndex:i] floatValue];
        ZMCSectorLayer *sectorLayer = [ZMCSectorLayer layer];
        sectorLayer.bounds = self.bounds;
        sectorLayer.position = kZMCSectorCenter;
        sectorLayer.center = kZMCSectorCenter;
        sectorLayer.startAngle = angle;
        sectorLayer.endAngle = angle + percentage * 2 * M_PI;
        sectorLayer.fillColor = ((UIColor *)[pieColors objectAtIndex:(i % pieColors.count)]).CGColor;
        sectorLayer.name = [self.columnNames objectAtIndex:i];
        sectorLayer.percentage = percentage;
        [self.layer addSublayer:sectorLayer];
        [layerArray addObject:sectorLayer];
        angle = sectorLayer.endAngle;
    }
    // 开始执行动画
    [self startAnimation];
}

// 开始执行动画，动画总时间1秒
- (void)startAnimation
{
    // 第一个扇形执行动画，动画执行玩调用委托方法
    ZMCSectorLayer *sectorLayer = (ZMCSectorLayer *)[layerArray objectAtIndex:index];
    index ++;
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"endAngle"];
    basicAnimation.duration = (sectorLayer.endAngle - sectorLayer.startAngle) / (2 * M_PI);
    basicAnimation.delegate = self;
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    basicAnimation.fromValue = [NSNumber numberWithFloat:sectorLayer.startAngle];
    basicAnimation.toValue = [NSNumber numberWithFloat:sectorLayer.endAngle];
    [sectorLayer addAnimation:basicAnimation forKey:@"endAngle"];
}
// 动画执行委托方法，当i大于数据数时跳出回调
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (index >= self.columnNames.count) {
        return;
    }
    else {
        ZMCSectorLayer *sectorLayer = (ZMCSectorLayer *)[layerArray objectAtIndex:index];
        index ++;
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"endAngle"];
        basicAnimation.duration = (sectorLayer.endAngle - sectorLayer.startAngle) / (2 * M_PI);
        basicAnimation.delegate = self;
        basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        basicAnimation.fromValue = [NSNumber numberWithFloat:sectorLayer.startAngle];
        basicAnimation.toValue = [NSNumber numberWithFloat:sectorLayer.endAngle];
        [sectorLayer addAnimation:basicAnimation forKey:@"endAngle"];
    }
}

// 选择一个扇形区域的方法
- (void)selectSector:(ZMCSectorLayer *)layer
{
    // 已被选择时什么也不做
    if (!layer.isSelected) {
        // 在所有扇形中有被选择的变成不选择
        for (ZMCSectorLayer *sector in [self.layer sublayers]) {
            if ([sector isKindOfClass:[ZMCSectorLayer class]]) {
                if (sector.isSelected) {
                    // 执行取消选中的动画
                    sector.isSelected = NO;
                    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"center"];
                    basicAnimation.duration = 0.5f;
                    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
                    basicAnimation.fromValue = [NSValue valueWithCGPoint:sector.center];
                    basicAnimation.toValue = [NSValue valueWithCGPoint:kZMCSectorCenter];
                    basicAnimation.fillMode = kCAFillModeForwards;
                    [sector addAnimation:basicAnimation forKey:@"center"];
                    sector.center = kZMCSectorCenter;
                }
            }
        }
        
        // 计算新到圆心
        CGPoint newCenter = [self centerSelected:layer];
        // 执行选中的动画
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"center"];
        basicAnimation.duration = 0.5f;
        basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        basicAnimation.fromValue = [NSValue valueWithCGPoint:kZMCSectorCenter];
        basicAnimation.toValue = [NSValue valueWithCGPoint:newCenter];
        basicAnimation.fillMode = kCAFillModeForwards;
        [layer addAnimation:basicAnimation forKey:@"center"];
        layer.center = newCenter;
        layer.isSelected = YES;
    }
}

// 计算被选择之后执行动画的新圆心
- (CGPoint)centerSelected:(ZMCSectorLayer *)layer
{
    CGFloat angle = layer.startAngle + (layer.endAngle - layer.startAngle)/2;
    CGFloat x = layer.center.x + 4 * cosf(2 * M_PI - angle);
    CGFloat y = layer.center.y - 4 * sinf(2 * M_PI - angle);
    return CGPointMake(x, y);
}

// 计算每个数据转换成百分比
- (NSArray *)percentageColumn:(NSArray *)array
{
    float sum = 0;
    for (NSString *s in array) {
        sum += [s floatValue];
    }
    NSMutableArray *column = [NSMutableArray arrayWithCapacity:array.count];
    for (NSString *s in array) {
        [column addObject:[NSString stringWithFormat:@"%f", [s floatValue]/sum]];
    }
    return column;
}

// 点击事件调用的方法
- (void)tapGesture:(UITapGestureRecognizer *)gesture
{
    // 获取点击的位置
    CGPoint touchPoint = [gesture locationInView:self];
    // 根据位置找到被点击的扇形
    ZMCSectorLayer *sectorLayer = [self sectorContainsPoint:touchPoint];
    if (sectorLayer) {
        [self selectSector:sectorLayer];
        NSInteger i = [layerArray indexOfObject:sectorLayer];
        nameLabel.textColor = [pieColors objectAtIndex:i];
        nameLabel.text = [self.columnNames objectAtIndex:i];
        percentageLabel.textColor = [pieColors objectAtIndex:i];
        percentageLabel.text = [NSString stringWithFormat:@"%.1f%%", [(NSString *)[percentages objectAtIndex:i] floatValue] * 100];
    }
}

// 点击的位置在哪个扇形区域
- (ZMCSectorLayer *)sectorContainsPoint:(CGPoint)point
{
    // 计算点击的位置到中心点到距离
    CGFloat distance = sqrtf((point.x - kZMCSectorCenter.x) * (point.x - kZMCSectorCenter.x) + (point.y - kZMCSectorCenter.y) * (point.y - kZMCSectorCenter.y));
    // 判断点击位置是否在扇形区域里
    if (distance < kZMCSectorBigRadius && distance > kZMCSectorSmallRadius) {
        // 求出点击位置与圆点水平向右的角度
        float angle = acosf((point.x - kZMCSectorCenter.x)/distance);
        if (point.y < kZMCSectorCenter.y) {
            angle = 2 * (M_PI - angle) + angle;
        }
        for (ZMCSectorLayer *sector in layerArray) {
            if (sector.startAngle < angle && sector.endAngle > angle) {
                return sector;
            }
        }
    }
    return nil;
}

@end
