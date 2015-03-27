//
//  CellModel.h
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-21.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define NAME_LABEL_FONT [UIFont systemFontOfSize:13];
#define TIME_LABEL_FONT [UIFont systemFontOfSize:11];
#define SOURCE_LABEL_FONT [UIFont systemFontOfSize:11];
#define CONTENT_LABEL_FONT [UIFont systemFontOfSize:14];
#define RETWEET_NAME_LABEL_FONT [UIFont systemFontOfSize:13];
#define RETWEET_CONTENT_LABEL_FONT [UIFont systemFontOfSize:14];

@class WeiboModel;
@interface CellModel : NSObject

@property (nonatomic,strong) WeiboModel *weiboModel;


/**上部分背景view*/
@property (nonatomic,assign) CGRect topViewFrame;
/**头像*/
@property (nonatomic,assign) CGRect headPhotoViewFrame;
/**vip等级*/
@property (nonatomic,assign) CGRect vipViewFrame;
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
/**转发的背景view*/
@property (nonatomic,assign) CGRect retweetViewFrame;
/**被转发的用户昵称*/
@property (nonatomic,assign) CGRect retweet_nameFrame;
/**被转发的微博的内容*/
@property (nonatomic,assign) CGRect retweet_contentLabelFrame;
/**被转发的微博的配图*/
@property (nonatomic,assign) CGRect retweet_pictureViewFrame;
/**下部分背景view*/
@property (nonatomic,assign) CGRect bottomViewFrame;

/**cell高度*/
@property (nonatomic,assign) float cellHeight;

@end
