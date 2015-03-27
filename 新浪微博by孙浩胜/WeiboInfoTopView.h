//
//  WeiboInfoTopView.h
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/26.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeiboCommentModel;
@class WeiboModel;
@class WeiboInfoModel;
@interface WeiboInfoTopView : UIImageView

@property (nonatomic,strong) WeiboInfoModel *weiboInfoModel;

@property (nonatomic,strong) WeiboCommentModel *weiboCommentModel;

@property (nonatomic,strong) WeiboModel *weiboModel;

@end
