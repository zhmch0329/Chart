//
//  ZMCChartView.m
//  Chart
//
//  Created by zhmch0329 on 13-11-24.
//  Copyright (c) 2013年 zhmch0329. All rights reserved.
//

#import "ZMCChartView.h"
#import "ZMCBarChartView.h"
#import "ZMCLineChartView.h"
#import "ZMCPieChartView.h"

#define kZMCCoordinateXHeight 260
#define kZMCCoordinateYHeight 200
#define kZMCCoordinateSignWidth 4

@implementation ZMCChartView

@synthesize chartViewType = _chartViewType;
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    if (self) {
        data = [[NSArray alloc] init];
        dataType = 1;
        columnNames = [[NSArray alloc] init];
        chartColor = [[NSArray alloc] init];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        data = [[NSArray alloc] init];
        dataType = 1;
        columnNames = [[NSArray alloc] init];
        chartColor = [[NSArray alloc] init];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withChartViewType:(ZMCChartViewType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        //        data = [[NSArray alloc] init];
        //        dataType = 1;
        //        columnNames = [[NSArray alloc] init];
        //        chartColor = [[NSArray alloc] init];
        self.chartViewType = type;
    }
    return self;
}

- (void)startLoadingData
{
    if ([self.dataSource respondsToSelector:@selector(dataInChartView:)]) {
        data = [self.dataSource dataInChartView:self];
    }
    else {
        return;
    }
    
    if ([self.dataSource respondsToSelector:@selector(dataTypeInChartView:)]) {
        dataType = [self.dataSource dataTypeInChartView:self];
    }
    else {
        dataType = 1;
    }
    
    if ([self.dataSource respondsToSelector:@selector(columnNamesInChartView:)]) {
        columnNames = [self.dataSource columnNamesInChartView:self];
    }
    else {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(columnColor:)]) {
        chartColor = [self.delegate columnColor:self];
    }
    else {
        // 初始化颜色
        chartColor = [NSArray arrayWithObjects:
                      [UIColor colorWithRed:93.0f/255.0f green:150.0f/255.0f blue:72.0f/255.0f alpha:1.0f],
                      [UIColor colorWithRed:46.0f/255.0f green:87.0f/255.0f blue:140.0f/255.0f alpha:1.0f],
                      [UIColor colorWithRed:231.0f/255.0f green:161.0f/255.0f blue:61.0f/255.0f alpha:1.0f],
                      [UIColor colorWithRed:188.0f/255.0f green:45.0f/255.0f blue:48.0f/255.0f alpha:1.0f],
                      [UIColor colorWithRed:111.0f/255.0f green:61.0f/255.0f blue:121.0f/255.0f alpha:1.0f],
                      [UIColor colorWithRed:125.0f/255.0f green:128.0f/255.0f blue:127.0f/255.0f alpha:1.0f],
                      nil];
    }
    
    if (dataType == 1 || self.chartViewType == kZMCPieChartView) {
        if (data.count != columnNames.count) {
            return;
        }
    }
    else {
        for (NSArray *array in data) {
            if (array.count != columnNames.count) {
                return;
            }
        }
    }
    
    switch (self.chartViewType) {
        case kZMCBarChartView:
        {
            ZMCBarChartView *barChartView = [[ZMCBarChartView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
            barChartView.dataType = dataType;
            barChartView.data = dataType == 1 ? [[NSArray alloc] initWithObjects:data, nil] : data;
            barChartView.columnNames = columnNames;
            barChartView.barColors = chartColor;
            [self addSubview:barChartView];
            [barChartView startLoadingData];
            break;
        }
        case kZMCLineChartView:
        {
            ZMCLineChartView *lineChartView = [[ZMCLineChartView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
            lineChartView.lineColors = chartColor;
            lineChartView.dataType = dataType;
            lineChartView.data = dataType == 1 ? [[NSArray alloc] initWithObjects:data, nil] : data;
            lineChartView.columnNames = columnNames;
            [self addSubview:lineChartView];
            [lineChartView startLoadingData];
            break;
        }
        case kZMCPieChartView:
        {
            ZMCPieChartView *pieChartView = [[ZMCPieChartView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
            pieChartView.pieColors = chartColor;
            pieChartView.data = data;
            pieChartView.columnNames = columnNames;
            [self addSubview:pieChartView];
            [pieChartView startLoadingData];
            break;
        }
        default:
            break;
    }
}

@end
