//
//  SendToolbar.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/24.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "SendToolbar.h"
#import "UIButton+FastBtn.h"

@interface SendToolbar ()

@property (nonatomic,weak) UIView *backgroundView;

@end

@implementation SendToolbar
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 80, [UIScreen mainScreen].bounds.size.width, 80);
        self.backgroundColor = [UIColor clearColor];
        [self addBackgroundView];
        [self addSmallBtn];
       
    }
    return self;
}

//同时评论给原微博
- (void)addSmallBtn
{
    UIButton *Btn = [UIButton buttonWithImageName:@"new_feature_share_false-1" SelectedImageName:@"new_feature_share_true-1" target:self action:@selector(btnClick:)];
    Btn.tag = SendToolbarButtonTypeIsComment;
    Btn.frame = (CGRect){{10,0},Btn.bounds.size};
    Btn.hidden = YES;
    self.smallBtn = Btn;
    [self addSubview:Btn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(Btn.frame)+10, 0, 150, Btn.frame.size.height)];
    label.font = [UIFont systemFontOfSize:13];
    label.text = @"同时评论给原微博";
    label.hidden = YES;
    self.smallLabel = label;
    [self addSubview:label];
}

- (void)addBackgroundView
{
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background_os7"]];
    backgroundView.frame = CGRectMake(0, self.bounds.size.height - 44, [UIScreen mainScreen].bounds.size.width, 44);
    backgroundView.userInteractionEnabled = YES;
    self.backgroundView = backgroundView;
    [self addSubview:backgroundView];
    [self addButtonItem];
}

- (void)addButtonItem
{
    UIButton *btn1 = [UIButton buttonWithImageName:@"compose_camerabutton_background_os7" HighlightImageName:@"compose_camerabutton_background_highlighted_os7" target:self action:@selector(btnClick:)];
    btn1.tag = SendToolbarButtonTypeCamera;
    [self.backgroundView addSubview:btn1];
    
    
    UIButton *btn4 = [UIButton buttonWithImageName:@"compose_toolbar_picture_os7" HighlightImageName:@"compose_toolbar_picture_highlighted_os7" target:self action:@selector(btnClick:)];
    btn4.tag = SendToolbarButtonTypePicture;
    [self.backgroundView addSubview:btn4];
    
    UIButton *btn2 = [UIButton buttonWithImageName:@"compose_emoticonbutton_background_os7" HighlightImageName:@"compose_emoticonbutton_background_highlighted_os7" target:self action:@selector(btnClick:)];
    btn2.tag = SendToolbarButtonTypeEmotion;
    [self.backgroundView addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithImageName:@"compose_mentionbutton_background_os7" HighlightImageName:@"compose_mentionbutton_background_highlighted_os7" target:self action:@selector(btnClick:)];
    btn3.tag = SendToolbarButtonTypeMention;
    [self.backgroundView addSubview:btn3];
    
    
    UIButton *btn5 = [UIButton buttonWithImageName:@"compose_trendbutton_background_os7" HighlightImageName:@"compose_trendbutton_background_highlighted_os7" target:self action:@selector(btnClick:)];
    btn5.tag = SendToolbarButtonTypeTrend;
    [self.backgroundView addSubview:btn5];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat border = self.backgroundView.frame.size.width/self.backgroundView.subviews.count;
    for (int i = 0; i<self.backgroundView.subviews.count; i++) {
        ((UIView *)self.backgroundView.subviews[i]).frame = CGRectMake(border*i, 0, border, 44);
        
    }
}

- (void)btnClick:(UIButton *)btn
{
    if (btn.tag == SendToolbarButtonTypeIsComment) {
        if (btn.selected) {
            btn.selected = NO;
        } else
            btn.selected = YES;
    }
    if (btn.tag == SendToolbarButtonTypeEmotion) {
        [btn setImage:[UIImage imageNamed:@"compose_keyboardbutton_background"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"compose_keyboardbutton_background_highlighted"] forState:UIControlStateHighlighted];
        btn.tag = SendToolbarButtonTypeKeyboard;
    } else if (btn.tag == SendToolbarButtonTypeKeyboard) {
        [btn setImage:[UIImage imageNamed:@"compose_emoticonbutton_background_os7"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"compose_emoticonbutton_background_highlighted_os7"] forState:UIControlStateHighlighted];
        btn.tag = SendToolbarButtonTypeEmotion;
    }
    if ([_delegate respondsToSelector:@selector(SendToolbar:DidClickBtntype:)]) {
        [_delegate SendToolbar:self DidClickBtntype:btn.tag];
    }
}
@end
