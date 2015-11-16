//
//  NodataCell.h
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboInfoViewController.h"

@interface NodataCell : UITableViewCell

@property (nonatomic,weak) UILabel *showInfo;
@property (nonatomic,assign) InfoTableViewState currentState;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
