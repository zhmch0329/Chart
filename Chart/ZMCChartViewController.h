//
//  ZMCChartViewController.h
//  Chart
//
//  Created by zhmch0329 on 13-11-24.
//  Copyright (c) 2013年 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMCChartView.h"

@interface ZMCChartViewController : UIViewController <ZMCChartViewDataSource, ZMCChartViewDelegate>

@property (strong, nonatomic) NSNumber *buttonTag;
@property (strong, nonatomic) IBOutlet UIView *chartView;

@end
