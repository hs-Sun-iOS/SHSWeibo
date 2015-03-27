//
//  WeiboInfoModel.h
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/26.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class WeiboModel;
@class WeiboCommentModel;

#define NAME_LABEL_FONT [UIFont systemFontOfSize:13];
#define TIME_LABEL_FONT [UIFont systemFontOfSize:11];
#define SOURCE_LABEL_FONT [UIFont systemFontOfSize:11];
#define CONTENT_LABEL_FONT [UIFont systemFontOfSize:14];
#define WEIBO_INFO_BORDER 10

@interface WeiboInfoModel : NSObject


@property (nonatomic,strong) WeiboModel *weiboModel;

@property (nonatomic,strong) WeiboCommentModel *weiboCommentModel;



/**上部分背景view*/
@property (nonatomic,assign) CGRect topViewFrame;
/**头像*/
@property (nonatomic,assign) CGRect headPhotoViewFrame;
/**昵称*/
@property (nonatomic,assign) CGRect nameLabelFrame;
/**发布时间*/
@property (nonatomic,assign) CGRect timeLabelFrame;
/**来源*/
@property (nonatomic,assign) CGRect sourceLabelFrame;
/**内容*/
@property (nonatomic,assign) CGRect contentLabelFrame;
/**微博配图*/
@property (nonatomic,assign) CGRect pictureViewFrame;
/**cell的高度*/
@property (nonatomic,assign) CGFloat cellHight;


@end
