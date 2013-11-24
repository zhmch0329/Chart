//
//  ZMCViewController.m
//  Chart
//
//  Created by zhmch0329 on 13-11-24.
//  Copyright (c) 2013年 zhmch0329. All rights reserved.
//

#import "ZMCViewController.h"
#import "ZMCChartViewController.h"

@interface ZMCViewController ()

@end

@implementation ZMCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ZMCChartViewController *chartViewController = segue.destinationViewController;
    UIButton *button = (UIButton *)sender;
    if ([chartViewController respondsToSelector:@selector(setButtonTag:)]) {
        [chartViewController setValue:[NSNumber numberWithInteger:button.tag] forKey:@"buttonTag"];
    }
}

@end
