//
//  CellTopView.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-22.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "CellTopView.h"
#import "CellRetweetView.h"
#import "CellModel.h"
#import "WeiboModel.h"
#import "UserModel.h"
#import "UIImage+AutoStretch.h"
#import "UIImageView+WebCache.h"
#import "PhotosView.h"

@interface CellTopView ()



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

@end

@implementation CellTopView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.image = [UIImage autoStretchWithimageName:@"timeline_card_top_background_os7"];
        self.highlightedImage = [UIImage autoStretchWithimageName:@"timeline_card_top_background_highlighted_os7"];
        
        self.headPhotoView = [self setupImageView];
        
        self.vipView = [self setupImageView];
    
        PhotosView *pv = [[PhotosView alloc] init];
        [self addSubview:pv];
        self.pictureView = pv;
        
        
        UIFont *font = NAME_LABEL_FONT;
        
        self.nameLabel = [self setupLabelWithFont:font color:[UIColor blackColor]];
    
        font = TIME_LABEL_FONT;
        self.timeLabel = [self setupLabelWithFont:font color:[UIColor orangeColor]];
        
        font = SOURCE_LABEL_FONT
        self.sourceLabel = [self setupLabelWithFont:font color:[UIColor blackColor]];
        
        font = CONTENT_LABEL_FONT;
        self.contentLabel = [self setupLabelWithFont:font color:[UIColor blackColor]];
        self.contentLabel.numberOfLines = 0;
        
        CellRetweetView *retweetView = [[CellRetweetView alloc] init];
        [self addSubview:retweetView];
        self.retweetView = retweetView;
        
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

- (void)setCellModel:(CellModel *)cellModel
{
    _cellModel = cellModel;
    
    self.frame = cellModel.topViewFrame;
    
    self.headPhotoView.frame = cellModel.headPhotoViewFrame;
    self.headPhotoView.layer.mask = ({
        CAShapeLayer *mask = [CAShapeLayer layer];
        mask.path = CGPathCreateWithEllipseInRect(self.headPhotoView.bounds, NULL);
        mask;
    });
    [self.headPhotoView setImageWithURL:[NSURL URLWithString:cellModel.weiboModel.user.profile_image_url] placeholderImage:[UIImage imageNamed:@"group_avator_default"]];
    
    self.nameLabel.frame = cellModel.nameLabelFrame;
    self.nameLabel.text = cellModel.weiboModel.user.name;
    
    if (cellModel.weiboModel.user.mbrank) {
        self.vipView.hidden = NO;
        self.vipView.frame = cellModel.vipViewFrame;
        self.vipView.contentMode = UIViewContentModeCenter;
        self.vipView.image = [UIImage imageNamed:[NSString stringWithFormat:@"common_icon_membership_level%d",cellModel.weiboModel.user.mbrank]];
        self.nameLabel.textColor = [UIColor colorWithRed:245.0/255 green:81.0/255 blue:39.0/255 alpha:1.0];
    } else
    {
        self.vipView.hidden = YES;
        self.nameLabel.textColor = [UIColor blackColor];
    }
    
    self.timeLabel.frame = cellModel.timeLabelFrame;
    self.timeLabel.text = cellModel.weiboModel.created_at;
    
    self.sourceLabel.frame = cellModel.sourceLabelFrame;
    self.sourceLabel.text = cellModel.weiboModel.source;
    
    self.contentLabel.frame = cellModel.contentLabelFrame;
    self.contentLabel.text = cellModel.weiboModel.text;
    
    //判断有无转发
    
    WeiboModel *retweeted_status = cellModel.weiboModel.retweeted_status;
    if (retweeted_status) {
        //有转发 则无配图
        self.retweetView.cellModel = cellModel;
        self.pictureView.hidden = YES;
        self.retweetView.hidden = NO;
        
    } else
    {
        self.retweetView.hidden = YES;
        if (cellModel.weiboModel.pic_urls.count)
        {
            //无转发 有配图
            self.pictureView.hidden = NO;
            self.pictureView.frame = cellModel.pictureViewFrame;
            self.pictureView.photos = cellModel.weiboModel.pic_urls;
        }
        else
        {
            //无转发 无配图
            self.pictureView.hidden = YES;
        }
    }

    
    
}
@end
