//
//  MessageViewController.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-17.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "MessageViewController.h"
#import "UIButton+FastBtn.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBarbuttonitem];
}

#pragma mark --导航栏右按钮
- (void) addBarbuttonitem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithTitle:@"发起聊天" NormalTitleColor:[UIColor orangeColor] HighlightTitleColor:[UIColor grayColor] target:self action:@selector(rightBtnClick) isEnable:YES]];
}

- (void)rightBtnClick
{
    NSLog(@"rightbtn click");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 0;
}


@end
