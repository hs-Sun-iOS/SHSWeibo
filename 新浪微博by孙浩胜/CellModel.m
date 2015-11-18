//
//  CellModel.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-21.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "CellModel.h"
#import "WeiboModel.h"
#import "UserModel.h"
#import "PhotosView.h"

#define WEIBO_CELL_BORDER 10





@implementation CellModel

- (void)setWeiboModel:(WeiboModel *)weiboModel
{
    _weiboModel = weiboModel;

    //上部分背景
    CGFloat topViewX = 0;
    CGFloat topViewY = 0;
    CGFloat topViewW = [UIScreen mainScreen].bounds.size.width; //- 2 * WEIBO_CELL_BORDER;
    CGFloat topViewH = 0;
    
    
    //头像
    CGFloat headPhotoX = topViewX + WEIBO_CELL_BORDER;
    CGFloat headPhotoY = topViewY + WEIBO_CELL_BORDER;
    CGFloat headPhotoW = 35;
    CGFloat headPhotoH = 35;
    _headPhotoViewFrame = CGRectMake(headPhotoX, headPhotoY, headPhotoW, headPhotoH);
    
    //昵称
    UIFont *nameFont = NAME_LABEL_FONT;
    
    CGFloat nameLabelX = CGRectGetMaxX(_headPhotoViewFrame) + WEIBO_CELL_BORDER - 5;
    CGFloat nameLabelY = headPhotoY;
    CGSize nameLabelSize = [weiboModel.user.name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:nameFont} context:nil].size;
    _nameLabelFrame = (CGRect){{nameLabelX, nameLabelY}, nameLabelSize};
    
    //vip等级
    CGFloat vipViewX = CGRectGetMaxX(_nameLabelFrame) + WEIBO_CELL_BORDER;
    CGFloat vipViewY = nameLabelY;
    CGFloat vipViewW = 14;
    CGFloat vipViewH = nameLabelSize.height;
    _vipViewFrame = CGRectMake(vipViewX, vipViewY, vipViewW, vipViewH);
    
    
    //发布时间
    UIFont *timeFont = TIME_LABEL_FONT;
    
    CGFloat timeLabelX = nameLabelX;
    CGFloat timeLabelY = CGRectGetMaxY(_nameLabelFrame) ;
    CGSize timeLabelSize = [weiboModel.created_at boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:timeFont} context:nil].size;
    _timeLabelFrame = (CGRect){{timeLabelX, timeLabelY}, timeLabelSize};
   
    //来源
    UIFont *sourceFont = SOURCE_LABEL_FONT;
    
    CGFloat sourceLabelX = CGRectGetMaxX(_timeLabelFrame) + WEIBO_CELL_BORDER;
    CGFloat sourceLabelY = timeLabelY;
    CGSize sourceLabelSize = [weiboModel.source boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:sourceFont} context:nil].size;
    _sourceLabelFrame = (CGRect){{sourceLabelX, sourceLabelY}, sourceLabelSize};
    
    //内容
    UIFont *ContentFont = CONTENT_LABEL_FONT;
    
    CGFloat contentLabelX = headPhotoX;
    CGFloat contentLabelY = CGRectGetMaxY(_headPhotoViewFrame) + WEIBO_CELL_BORDER;
    CGSize contentLabelSize = [weiboModel.text boundingRectWithSize:CGSizeMake(topViewW - 2 * WEIBO_CELL_BORDER, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:ContentFont} context:nil].size;
    _contentLabelFrame = (CGRect){{contentLabelX, contentLabelY}, contentLabelSize};
    
    
    if (weiboModel.retweeted_status) {
        
        //转发的背景view
        CGFloat retweetViewX = topViewX + WEIBO_CELL_BORDER;
        CGFloat retweetViewY = CGRectGetMaxY(_contentLabelFrame) + WEIBO_CELL_BORDER;
        CGFloat retweetViewW = topViewW - 2 * WEIBO_CELL_BORDER;
        CGFloat retweetViewH = 0;
        
        //被转发的用户昵称
        UIFont *retweet_nameLabelFont = RETWEET_NAME_LABEL_FONT;
        
        CGFloat retweet_nameLabelX = WEIBO_CELL_BORDER;
        CGFloat retweet_nameLabelY = WEIBO_CELL_BORDER;
        CGSize retweet_nameLabelSize = [[NSString stringWithFormat:@"@%@",weiboModel.retweeted_status.user.name] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:retweet_nameLabelFont} context:nil].size;
        _retweet_nameFrame = (CGRect){{retweet_nameLabelX, retweet_nameLabelY}, retweet_nameLabelSize};
        
        //被转发的微博的内容
        UIFont *retweet_contentLabelFont = RETWEET_CONTENT_LABEL_FONT;
        
        CGFloat retweet_contentLabelX = retweet_nameLabelX;
        CGFloat retweet_contentLabelY = CGRectGetMaxY(_nameLabelFrame) + WEIBO_CELL_BORDER;
        CGSize retweet_contentLabelSize = [weiboModel.retweeted_status.text boundingRectWithSize:CGSizeMake(retweetViewW - 2 * WEIBO_CELL_BORDER, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:retweet_contentLabelFont} context:nil].size;
        _retweet_contentLabelFrame = (CGRect){{retweet_contentLabelX, retweet_contentLabelY}, retweet_contentLabelSize};
        
        
        if (weiboModel.retweeted_status.pic_urls.count) {
            //被转发的微博的配图
            CGFloat retweet_pictureViewX = retweet_contentLabelX;
            CGFloat retweet_pictureViewY = CGRectGetMaxY(_retweet_contentLabelFrame) + WEIBO_CELL_BORDER;
            CGSize retweet_pictureViewSize = [PhotosView photosViewSizeWithPhotoCounts:weiboModel.retweeted_status.pic_urls.count];
            _retweet_pictureViewFrame = (CGRect){{retweet_pictureViewX,retweet_pictureViewY},retweet_pictureViewSize};
            
            retweetViewH = CGRectGetMaxY(_retweet_pictureViewFrame) + WEIBO_CELL_BORDER;
            
        } else
            retweetViewH = CGRectGetMaxY(_retweet_contentLabelFrame) + WEIBO_CELL_BORDER;
        
        _retweetViewFrame = CGRectMake(retweetViewX, retweetViewY, retweetViewW, retweetViewH);
        topViewH = CGRectGetMaxY(_retweetViewFrame) + WEIBO_CELL_BORDER;
    }
    else
    {
        //微博配图
        CGFloat pictureViewX = contentLabelX;
        CGFloat pictureViewY = CGRectGetMaxY(_contentLabelFrame) + WEIBO_CELL_BORDER;
        CGSize pictureViewSize = [PhotosView photosViewSizeWithPhotoCounts:weiboModel.pic_urls.count];
        _pictureViewFrame = (CGRect){{pictureViewX,pictureViewY},pictureViewSize};
        
        topViewH = CGRectGetMaxY(_pictureViewFrame) + WEIBO_CELL_BORDER;
    }
    
    _topViewFrame = CGRectMake(topViewX, topViewY, topViewW, topViewH);
    
    //下部分背景view
    CGFloat bottomViewX = topViewX;
    CGFloat bottomViewY = CGRectGetHeight(_topViewFrame);
    CGFloat bottomViewW = topViewW;
    CGFloat bottomViewH = 40;
    _bottomViewFrame = CGRectMake(bottomViewX, bottomViewY, bottomViewW, bottomViewH);
    
    
    _cellHeight = topViewH + bottomViewH + WEIBO_CELL_BORDER;
    
}

- (CGRect)timeLabelFrame
{
    //发布时间
    UIFont *timeFont = TIME_LABEL_FONT;
    
    CGFloat timeLabelX = _nameLabelFrame.origin.x;
    CGFloat timeLabelY = CGRectGetMaxY(_nameLabelFrame) + WEIBO_CELL_BORDER - 5;
    CGSize timeLabelSize = [_weiboModel.created_at boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:timeFont} context:nil].size;
    _timeLabelFrame = (CGRect){{timeLabelX, timeLabelY}, timeLabelSize};
    
    return _timeLabelFrame;
}

- (CGRect)sourceLabelFrame
{
    //来源
    UIFont *sourceFont = SOURCE_LABEL_FONT;
    
    CGFloat sourceLabelX = CGRectGetMaxX(_timeLabelFrame) + WEIBO_CELL_BORDER;
    CGFloat sourceLabelY = _timeLabelFrame.origin.y;
    CGSize sourceLabelSize = [_weiboModel.source boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:sourceFont} context:nil].size;
    _sourceLabelFrame = (CGRect){{sourceLabelX, sourceLabelY}, sourceLabelSize};
    return _sourceLabelFrame;
}

@end
