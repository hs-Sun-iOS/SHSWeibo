//
//  WeiboInfoToolbar.h
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import <UIKit/UIKit.h>




@class WeiboInfoToolbar;


typedef enum : NSUInteger {
    WeiboInfoToolBarRetweetButton,
    WeiboInfoToolBarCommentButton,
    WeiboInfoToolBarAttitudeButton
} WeiboInfoToolbarButtonType;

@protocol WeiboInfoToolBarDelegate <NSObject>

- (void)WeiboInfoToolbar:(WeiboInfoToolbar *)toolBar WithButtonType:(WeiboInfoToolbarButtonType)buttonType;

@end


@interface WeiboInfoToolbar : UIImageView

/**转发按钮*/
@property (nonatomic,weak) UIButton *retweetBtn;
/**评论按钮*/
@property (nonatomic,weak) UIButton *commentBtn;
/**点赞按钮*/
@property (nonatomic,weak) UIButton *attitudeBtn;

@property (nonatomic,assign) id<WeiboInfoToolBarDelegate> delegate;

@end
