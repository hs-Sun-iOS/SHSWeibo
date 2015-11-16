//
//  WeiboInfoCellHeadView.h
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/26.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeiboModel;

typedef enum : NSUInteger {
    RetweetButtonType,
    CommentButtonType,
    AttitudeButtonType,
} ButtonType;
@interface WeiboInfoCellHeadView : UIImageView

@property (nonatomic,strong) WeiboModel *weiboModel;

@end
