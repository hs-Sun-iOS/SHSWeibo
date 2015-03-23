//
//  CellRetweetView.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-22.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "CellRetweetView.h"
#import "WeiboModel.h"
#import "UserModel.h"
#import "CellModel.h"
#import "UIImage+AutoStretch.h"
#import "UIImageView+WebCache.h"
#import "PhotosView.h"

@interface CellRetweetView ()

/**被转发的用户昵称*/
@property (nonatomic,weak) UILabel *retweet_nameLabel;
/**被转发的微博的内容*/
@property (nonatomic,weak) UILabel *retweet_contentLabel;
/**被转发的微博的配图*/
@property (nonatomic,weak) PhotosView *retweet_pictureView;



@end

@implementation CellRetweetView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.image = [UIImage autoStretchWithimageName:@"timeline_retweet_background_os7" Left:0.9 top:0.5];
        
        
        UIFont *font = RETWEET_NAME_LABEL_FONT;
        self.retweet_nameLabel = [self setupLabelWithFont:font color:[UIColor colorWithRed:57.0/255 green:109.0/255 blue:182.0/255 alpha:1.0]];
        
        font = RETWEET_CONTENT_LABEL_FONT;
        self.retweet_contentLabel = [self setupLabelWithFont:font color:[UIColor blackColor]];
        
        
        self.retweet_pictureView = [self setupImageView];
    }
    return self;
}

- (PhotosView *)setupImageView
{
    PhotosView *imageView = [[PhotosView alloc] init];
    [self addSubview:imageView];
    return imageView;
}

- (UILabel *)setupLabelWithFont:(UIFont *)font color:(UIColor *)color
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = font;
    label.numberOfLines = 0;
    [self addSubview:label];
    return label;
}

- (void)setCellModel:(CellModel *)cellModel
{
    _cellModel = cellModel;
    WeiboModel *retweeted_status = cellModel.weiboModel.retweeted_status;
    
    self.frame = cellModel.retweetViewFrame;
    
    self.retweet_nameLabel.frame = cellModel.retweet_nameFrame;
    self.retweet_nameLabel.text = [NSString stringWithFormat:@"@%@",retweeted_status.user.name];
    
    self.retweet_contentLabel.frame = cellModel.retweet_contentLabelFrame;
    self.retweet_contentLabel.text = retweeted_status.text;
    
    if (retweeted_status.pic_urls.count) {
        self.retweet_pictureView.hidden = NO;
        self.retweet_pictureView.frame = cellModel.retweet_pictureViewFrame;
        self.retweet_pictureView.photos = cellModel.weiboModel.retweeted_status.pic_urls;
    } else
    {
        self.retweet_pictureView.hidden = YES;
    }

}

@end
