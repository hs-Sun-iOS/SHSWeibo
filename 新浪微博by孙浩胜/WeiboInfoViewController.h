//
//  WeiboInfoViewController.h
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/26.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    RetweetState,
    CommentState,
    AttitudeState,
} InfoTableViewState;

@class WeiboModel;
@class UserModel;


@interface WeiboInfoViewController : UIViewController

@property (nonatomic,strong) WeiboModel *weiboModel;

@property (nonatomic,strong) UserModel *userMidel;

@property (nonatomic,strong) UITableView *tableView;


@end
