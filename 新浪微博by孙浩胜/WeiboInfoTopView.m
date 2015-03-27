//
//  WeiboInfoTopView.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/26.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "WeiboInfoTopView.h"
#import "PhotosView.h"
#import "WeiboInfoModel.h"
#import "WeiboModel.h"
#import "UserModel.h"
#import "WeiboCommentModel.h"
#import "UIImageView+WebCache.h"
#import "UIImage+AutoStretch.h"


@interface WeiboInfoTopView ()

/**头像*/
@property (nonatomic,weak) UIImageView *headPhotoView;
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

@end
@implementation WeiboInfoTopView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.image = [UIImage autoStretchWithimageName:@"statusdetail_comment_background_middle"];
        self.highlightedImage = [UIImage autoStretchWithimageName:@"statusdetail_comment_background_middle_highlighted"];
        
        
        self.backgroundColor = [UIColor whiteColor];
        self.headPhotoView = [self setupImageView];
        
        PhotosView *pv = [[PhotosView alloc] init];
        [self addSubview:pv];
        self.pictureView = pv;
        
        UIFont *font = NAME_LABEL_FONT;
        
        self.nameLabel = [self setupLabelWithFont:font color:[UIColor blackColor]];
        
        font = TIME_LABEL_FONT;
        self.timeLabel = [self setupLabelWithFont:font color:[UIColor lightGrayColor]];
        
        font = SOURCE_LABEL_FONT
        self.sourceLabel = [self setupLabelWithFont:font color:[UIColor blackColor]];
        
        font = CONTENT_LABEL_FONT;
        self.contentLabel = [self setupLabelWithFont:font color:[UIColor blackColor]];
        self.contentLabel.numberOfLines = 0;

    }
    return self;
}

- (UIImageView *)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    return imageView;
}

- (UILabel *)setupLabelWithFont:(UIFont *)font color:(UIColor *)color
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = font;
    //label.numberOfLines = 0;
    [self addSubview:label];
    return label;
}


- (void)setWeiboInfoModel:(WeiboInfoModel *)weiboInfoModel
{
    _weiboInfoModel = weiboInfoModel;
    
    if (weiboInfoModel.weiboCommentModel) {
         self.weiboCommentModel = weiboInfoModel.weiboCommentModel;
    } else
         self.weiboModel = weiboInfoModel.weiboModel;
    
}

- (void)setWeiboModel:(WeiboModel *)weiboModel
{
    _weiboModel = weiboModel;
    self.frame = self.weiboInfoModel.topViewFrame;
    
    self.headPhotoView.frame = self.weiboInfoModel.headPhotoViewFrame;
    [self.headPhotoView setImageWithURL:[NSURL URLWithString:weiboModel.user.profile_image_url] placeholderImage:[UIImage imageNamed:@"group_avator_default"]];
    
    self.nameLabel.frame = self.weiboInfoModel.nameLabelFrame;
    self.nameLabel.text = self.weiboModel.user.name;
    
    self.timeLabel.frame = self.weiboInfoModel.timeLabelFrame;
    self.timeLabel.text = self.weiboModel.created_at;
    self.timeLabel.textColor = [UIColor orangeColor];
    
    self.sourceLabel.frame = self.weiboInfoModel.sourceLabelFrame;
    self.sourceLabel.text = self.weiboModel.source;
    
    self.contentLabel.frame = self.weiboInfoModel.contentLabelFrame;
    self.contentLabel.text = self.weiboModel.text;
    
    
    if (self.weiboModel.pic_urls.count)
    {
        // 有配图
        self.pictureView.hidden = NO;
        self.pictureView.frame = self.weiboInfoModel.pictureViewFrame;
        self.pictureView.photos = self.weiboInfoModel.weiboModel.pic_urls;
    }
    else
    {
        // 无配图
        self.pictureView.hidden = YES;
    }

}

- (void)setWeiboCommentModel:(WeiboCommentModel *)weiboCommentModel
{
    _weiboCommentModel = weiboCommentModel;
    
    self.frame = self.weiboInfoModel.topViewFrame;
    
    self.headPhotoView.frame = self.weiboInfoModel.headPhotoViewFrame;
    [self.headPhotoView setImageWithURL:[NSURL URLWithString:weiboCommentModel.user.profile_image_url] placeholderImage:[UIImage imageNamed:@"group_avator_default"]];
    
    self.nameLabel.frame = self.weiboInfoModel.nameLabelFrame;
    self.nameLabel.text = self.weiboCommentModel.user.name;
    
    self.timeLabel.frame = self.weiboInfoModel.timeLabelFrame;
    self.timeLabel.text = self.weiboCommentModel.created_at;
    
    self.contentLabel.frame = self.weiboInfoModel.contentLabelFrame;
    self.contentLabel.text = self.weiboCommentModel.text;

}

@end
