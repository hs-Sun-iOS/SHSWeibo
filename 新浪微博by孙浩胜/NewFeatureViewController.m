//
//  NewFeatureViewController.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-19.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "NewFeatureViewController.h"
#import "NewFeatureView.h"
#import "ViewController.h"

@implementation NewFeatureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NewFeatureView *nfv = [[NewFeatureView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:nfv];
    
}

@end
