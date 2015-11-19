//
//  SendToolbar.h
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/24.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SendToolbar;

typedef enum : NSUInteger {
    SendToolbarButtonTypeCamera,
    SendToolbarButtonTypePicture,
    SendToolbarButtonTypeMention,
    SendToolbarButtonTypeTrend,
    SendToolbarButtonTypeEmotion,
    SendToolbarButtonTypeKeyboard,
    SendToolbarButtonTypeIsComment
} SendToolbarButtonType;

@protocol SendToolbarDelegate <NSObject>

- (void)SendToolbar:(SendToolbar *)sendtoolbar DidClickBtntype:(SendToolbarButtonType)btntype;

@end


@interface SendToolbar : UIView

@property (nonatomic,assign) id<SendToolbarDelegate> delegate;

@property (nonatomic,weak) UIButton *smallBtn;

@property (nonatomic,weak) UILabel *smallLabel;

@end
