//
//  ZMCChartViewController.m
//  Chart
//
//  Created by zhmch0329 on 13-11-24.
//  Copyright (c) 2013年 zhmch0329. All rights reserved.
//

#import "ZMCChartViewController.h"

@interface ZMCChartViewController ()

@end

@implementation ZMCChartViewController

@synthesize buttonTag;
@synthesize chartView = _chartView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@", self.chartView);
    NSLog(@"%@", buttonTag);
    switch ([buttonTag integerValue]) {
        case 111:
        {
            ZMCChartView *chart = [[ZMCChartView alloc] initWithFrame:CGRectMake(0, 0, 320, 300) withChartViewType:kZMCBarChartView];
            chart.dataSource = self;
            [self.chartView addSubview:chart];
            [chart startLoadingData];
            break;
        }
        case 222:
        {
            ZMCChartView *chart = [[ZMCChartView alloc] initWithFrame:CGRectMake(0, 0, 320, 300) withChartViewType:kZMCLineChartView];
            chart.dataSource = self;
            [self.chartView addSubview:chart];
            [chart startLoadingData];
            break;
        }
        case 333:
        {
            ZMCChartView *chart = [[ZMCChartView alloc] initWithFrame:CGRectMake(0, 0, 320, 300) withChartViewType:kZMCPieChartView];
            chart.dataSource = self;
            [self.chartView addSubview:chart];
            [chart startLoadingData];
            break;
        }
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)dataTypeInChartView:(ZMCChartView *)chartView
{
    if (chartView.chartViewType != kZMCPieChartView) {
        return 2;
    }
    return 1;
}

- (NSArray *)columnNamesInChartView:(ZMCChartView *)chartView
{
    return [NSArray arrayWithObjects:@"一月", @"二月", @"三月", @"四月", @"五月", @"六月", nil];
}

- (NSArray *)dataInChartView:(ZMCChartView *)chartView
{
    if (chartView.chartViewType != kZMCPieChartView) {
        return [NSArray arrayWithObjects:
                [NSArray arrayWithObjects:@"100", @"30", @"201", @"22", @"10", @"300", nil],
                [NSArray arrayWithObjects:@"200", @"10", @"101", @"52", @"10", @"100", nil],
                nil];
    }
    return [NSArray arrayWithObjects:@"100", @"30", @"201", @"22", @"10", @"300", nil];
}

@end
