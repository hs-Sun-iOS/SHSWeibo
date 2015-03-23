//
//  WeiboCell.h
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-21.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CellModel;
@class CellToolBar;
@class PhotosView;

@interface WeiboCell : UITableViewCell
/**上部分背景view*/
@property (nonatomic,weak) UIImageView *topView;
/**头像*/
@property (nonatomic,weak) UIImageView *headPhotoView;
/**vip等级*/
@property (nonatomic,weak) UIImageView *vipView;
/**昵称*/
@property (nonatomic,weak) UILabel *nameLabel;
/**发布时间*/
@property (nonatomic,weak) UILabel *timeLabel;
/**来源*/
@property (nonatomic,weak) UILabel *sourceLabel;
/**内容*/
@property (nonatomic,weak) UILabel *contentLabel;
/**微博配图*/
@property (nonatomic,weak) PhotosView *pictureView;
/**转发的背景view*/
@property (nonatomic,weak) UIImageView *retweetView;
/**被转发的用户昵称*/
@property (nonatomic,weak) UILabel *retweet_nameLabel;
/**被转发的微博的内容*/
@property (nonatomic,weak) UILabel *retweet_contentLabel;
/**被转发的微博的配图*/
@property (nonatomic,weak) PhotosView *retweet_pictureView;
/**下部分背景view*/
@property (nonatomic,weak) CellToolBar *bottomView;
/**cell模型*/
@property (nonatomic,strong) CellModel *cellModel;



+ (instancetype)cellWithTableView:(UITableView *)tableView;

//- (instancetype)initWithTableView:(UITableView *)tableView;
@end
