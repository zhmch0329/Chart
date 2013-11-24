//
//  ZMCBarChartView.h
//  Chart
//
//  Created by zhmch0329 on 13-11-24.
//  Copyright (c) 2013年 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMCBarChartView : UIView
{
    NSArray *barColors;
    
    NSArray *columnNames;
    NSArray *data;
    NSInteger dataType;
    
    UILabel *dataLabel;
    
    NSMutableArray *points;
}

@property (strong, nonatomic) NSArray *barColors;
@property (strong, nonatomic) NSArray *columnNames;
@property (strong, nonatomic) NSArray *data;
@property (nonatomic) NSInteger dataType;

- (void)startLoadingData;

@end
