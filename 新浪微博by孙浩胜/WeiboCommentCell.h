//
//  WeiboCommentCell.h
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeiboInfoModel;

@interface WeiboCommentCell : UITableViewCell

@property (nonatomic,strong) WeiboInfoModel *weiboInfoModel;


+ (instancetype)cellWithtableView:(UITableView *)tableview;

@end
