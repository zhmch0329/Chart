//
//  ZMCChartView.h
//  Chart
//
//  Created by zhmch0329 on 13-11-24.
//  Copyright (c) 2013年 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZMCChartViewType) {
    kZMCBarChartView = 0,
    kZMCLineChartView,
    kZMCPieChartView
};

@protocol ZMCChartViewDelegate;
@protocol ZMCChartViewDataSource;
@interface ZMCChartView : UIView
{
    NSArray *columnNames;
    NSArray *data;
    NSInteger dataType;
    NSArray *chartColor;
    
    id chartView;
}

@property (assign, nonatomic) ZMCChartViewType chartViewType;
@property (strong, nonatomic) id<ZMCChartViewDataSource> dataSource;
@property (strong, nonatomic) id<ZMCChartViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withChartViewType:(ZMCChartViewType)type;

- (void)startLoadingData;

@end

@protocol ZMCChartViewDelegate <NSObject>

@optional
- (NSArray *)columnColor:(ZMCChartView *)chartView;

@end


@protocol ZMCChartViewDataSource <NSObject>

@required
- (NSArray *)columnNamesInChartView:(ZMCChartView *)chartView;
- (NSArray *)dataInChartView:(ZMCChartView *)chartView;

@optional
- (NSInteger)dataTypeInChartView:(ZMCChartView *)chartView;

@optional


@end