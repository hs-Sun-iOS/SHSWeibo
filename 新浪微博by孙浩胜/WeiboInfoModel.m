//
//  WeiboInfoModel.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/26.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "WeiboInfoModel.h"
#import "WeiboModel.h"
#import "WeiboCommentModel.h"
#import "UserModel.h"
#import "PhotosView.h"

@implementation WeiboInfoModel

- (void)setWeiboModel:(WeiboModel *)weiboModel
{
    _weiboModel = weiboModel;
    
    //上部分背景
    CGFloat topViewX = 0;
    CGFloat topViewY = 0;
    CGFloat topViewW = [UIScreen mainScreen].bounds.size.width;
    CGFloat topViewH = 0;
    
    
    //头像
    CGFloat headPhotoX = topViewX + WEIBO_INFO_BORDER;
    CGFloat headPhotoY = topViewY + WEIBO_INFO_BORDER;
    CGFloat headPhotoW = 35;
    CGFloat headPhotoH = 35;
    _headPhotoViewFrame = CGRectMake(headPhotoX, headPhotoY, headPhotoW, headPhotoH);
    
    //昵称
    UIFont *nameFont = NAME_LABEL_FONT;
    
    CGFloat nameLabelX = CGRectGetMaxX(_headPhotoViewFrame) + WEIBO_INFO_BORDER - 5;
    CGFloat nameLabelY = headPhotoY;
    CGSize nameLabelSize = [weiboModel.user.name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:nameFont} context:nil].size;
    _nameLabelFrame = (CGRect){{nameLabelX, nameLabelY}, nameLabelSize};
    
    
    //发布时间
    UIFont *timeFont = TIME_LABEL_FONT;
    
    CGFloat timeLabelX = nameLabelX;
    CGFloat timeLabelY = CGRectGetMaxY(_nameLabelFrame) + WEIBO_INFO_BORDER -5;
    CGSize timeLabelSize = [weiboModel.created_at boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:timeFont} context:nil].size;
    _timeLabelFrame = (CGRect){{timeLabelX, timeLabelY}, timeLabelSize};
    
    //来源
    UIFont *sourceFont = SOURCE_LABEL_FONT;
    
    CGFloat sourceLabelX = CGRectGetMaxX(_timeLabelFrame) + WEIBO_INFO_BORDER;
    CGFloat sourceLabelY = timeLabelY;
    CGSize sourceLabelSize = [weiboModel.source boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:sourceFont} context:nil].size;
    _sourceLabelFrame = (CGRect){{sourceLabelX, sourceLabelY}, sourceLabelSize};
    
    //内容
    UIFont *ContentFont = CONTENT_LABEL_FONT;
    
    CGFloat contentLabelX = headPhotoX;
    CGFloat contentLabelY = CGRectGetMaxY(_headPhotoViewFrame) + WEIBO_INFO_BORDER;
    CGSize contentLabelSize = [weiboModel.text boundingRectWithSize:CGSizeMake(topViewW - 2 * WEIBO_INFO_BORDER, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:ContentFont} context:nil].size;
    _contentLabelFrame = (CGRect){{contentLabelX, contentLabelY}, contentLabelSize};
    
    if (weiboModel.pic_urls.count == 0) {
        topViewH = CGRectGetMaxY(_contentLabelFrame) + WEIBO_INFO_BORDER;
    } else {
        //微博配图
        CGFloat pictureViewX = contentLabelX;
        CGFloat pictureViewY = CGRectGetMaxY(_contentLabelFrame) + WEIBO_INFO_BORDER;
        CGSize pictureViewSize = [PhotosView photosViewSizeWithPhotoCounts:weiboModel.pic_urls.count];
        _pictureViewFrame = (CGRect){{pictureViewX,pictureViewY},pictureViewSize};
        
        topViewH = CGRectGetMaxY(_pictureViewFrame) + WEIBO_INFO_BORDER;
    }
    _topViewFrame = CGRectMake(topViewX, topViewY, topViewW, topViewH);
    _cellHight = CGRectGetMaxY(_topViewFrame) + WEIBO_INFO_BORDER + 10;
}

- (void)setWeiboCommentModel:(WeiboCommentModel *)weiboCommentModel
{
    _weiboCommentModel = weiboCommentModel;
    
    //背景
    CGFloat topViewX = 0;
    CGFloat topViewY = 0;
    CGFloat topViewW = [UIScreen mainScreen].bounds.size.width;
    CGFloat topViewH = 0;
    
    
    //头像
    CGFloat headPhotoX = topViewX + WEIBO_INFO_BORDER;
    CGFloat headPhotoY = topViewY + WEIBO_INFO_BORDER;
    CGFloat headPhotoW = 35;
    CGFloat headPhotoH = 35;
    _headPhotoViewFrame = CGRectMake(headPhotoX, headPhotoY, headPhotoW, headPhotoH);
    
    //昵称
    UIFont *nameFont = NAME_LABEL_FONT;
    
    CGFloat nameLabelX = CGRectGetMaxX(_headPhotoViewFrame) + WEIBO_INFO_BORDER - 5;
    CGFloat nameLabelY = headPhotoY;
    CGSize nameLabelSize = [weiboCommentModel.user.name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:nameFont} context:nil].size;
    _nameLabelFrame = (CGRect){{nameLabelX, nameLabelY}, nameLabelSize};
    
    
    //发布时间
    UIFont *timeFont = TIME_LABEL_FONT;
    
    CGFloat timeLabelX = nameLabelX;
    CGFloat timeLabelY = CGRectGetMaxY(_nameLabelFrame) + WEIBO_INFO_BORDER -5;
    CGSize timeLabelSize = [weiboCommentModel.created_at boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:timeFont} context:nil].size;
    _timeLabelFrame = (CGRect){{timeLabelX, timeLabelY}, timeLabelSize};
    
    //内容
    UIFont *ContentFont = CONTENT_LABEL_FONT;
    
    CGFloat contentLabelX = timeLabelX;
    CGFloat contentLabelY = CGRectGetMaxY(_timeLabelFrame) + WEIBO_INFO_BORDER -5;
    CGSize contentLabelSize = [weiboCommentModel.text boundingRectWithSize:CGSizeMake(topViewW - headPhotoW - 2*WEIBO_INFO_BORDER, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:ContentFont} context:nil].size;
    _contentLabelFrame = (CGRect){{contentLabelX, contentLabelY}, contentLabelSize};

    topViewH = CGRectGetMaxY(_contentLabelFrame) + WEIBO_INFO_BORDER;
    _topViewFrame = CGRectMake(topViewX, topViewY, topViewW, topViewH);
    
    _cellHight = topViewH;
    
}

@end
