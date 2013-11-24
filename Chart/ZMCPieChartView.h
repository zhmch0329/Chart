//
//  ZMCPieChartView.h
//  Chart
//
//  Created by zhmch0329 on 13-11-24.
//  Copyright (c) 2013年 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMCPieChartView : UIView
{
    NSArray *pieColors;
    NSMutableArray *layerArray;
    
    UILabel *nameLabel;
    UILabel *percentageLabel;
    
    NSArray *columnNames;
    NSArray *data;
    NSArray *percentages;
    
    NSInteger index;
    NSInteger selectedIndex;
}

@property (strong, nonatomic) NSArray *pieColors;
@property (strong, nonatomic) NSArray *columnNames;
@property (strong, nonatomic) NSArray *data;

- (void)startLoadingData;

@end
