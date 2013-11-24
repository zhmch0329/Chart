//
//  ZMCLineChartView.h
//  Chart
//
//  Created by zhmch0329 on 13-11-24.
//  Copyright (c) 2013年 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMCLineChartView : UIView
{
    NSArray *lineColors;
    
    NSArray *columnNames;
    NSArray *data;
    NSInteger dataType;
    
    NSMutableArray *points;
    
    UILabel *dataLabel;
}

@property (strong, nonatomic) NSArray *lineColors;
@property (strong, nonatomic) NSArray *columnNames;
@property (strong, nonatomic) NSArray *data;
@property (nonatomic) NSInteger dataType;

- (void)startLoadingData;

@end
