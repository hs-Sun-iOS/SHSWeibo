//
//  WeiboInfoToolbar.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "WeiboInfoToolbar.h"
#import "UIImage+AutoStretch.h"

@implementation WeiboInfoToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.image = [UIImage autoStretchWithimageName:@"more_Individuation_toolbar"];
        self.userInteractionEnabled = YES;
        
        
        UIImageView *line1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_card_bottom_line_os7"]];
        line1.contentMode = UIViewContentModeCenter;
        [self addSubview:line1];
        
        UIImageView *line2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_card_bottom_line_os7"]];
        line2.contentMode = UIViewContentModeCenter;
        [self addSubview:line2];
        
        self.retweetBtn = [self BtnWithTitle:@"转发" imageName:@"timeline_icon_retweet_os7" backgroundImage:@"timeline_card_leftbottom_highlighted_os7" buttonType:WeiboInfoToolBarRetweetButton];
        
        self.commentBtn = [self BtnWithTitle:@"评论" imageName:@"timeline_icon_comment_os7" backgroundImage:@"timeline_card_middlebottom_highlighted_os7" buttonType:WeiboInfoToolBarCommentButton];
        
        self.attitudeBtn = [self BtnWithTitle:@"赞" imageName:@"timeline_icon_unlike_os7" backgroundImage:@"timeline_card_rightbottom_highlighted_os7" buttonType:WeiboInfoToolBarAttitudeButton];
        [self.attitudeBtn setImage:[UIImage imageNamed:@"statusdetail_comment_icon_like_highlighted"] forState:UIControlStateSelected];
        
        
        
    }
    return self;
}

- (UIButton *)BtnWithTitle:(NSString *)title imageName:(NSString *)imageName backgroundImage:(NSString *)backgroundImage buttonType:(WeiboInfoToolbarButtonType)buttonType
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.adjustsImageWhenHighlighted = NO;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = buttonType;
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 105, 40)];

    [btn setBackgroundImage:[UIImage autoStretchWithimageName:backgroundImage] forState:UIControlStateHighlighted];
    [self addSubview:btn];
    btn.backgroundColor = [UIColor clearColor];
    
    return btn;
}

- (void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(WeiboInfoToolbar:WithButtonType:)]) {
        [_delegate WeiboInfoToolbar:self WithButtonType:btn.tag];
    }
    
    if (btn.tag == WeiboInfoToolBarAttitudeButton) {
        if (btn.selected) {
            btn.selected = NO;
        } else
            btn.selected = YES;
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        animation.keyPath = @"transform";
        NSValue *v1 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.5)];
        NSValue *v2 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 0.8)];
        NSValue *v3 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
        
        
        animation.values = @[v1,v2,v3];
        animation.duration = 0.3;
        
        [btn.layer addAnimation:animation forKey:nil];
    }
    
}
- (void)layoutSubviews
{
    CGFloat border = (self.bounds.size.width - 4) / 3;
    for (int i = 0;i < self.subviews.count ; i++) {
        if ([self.subviews[i] isKindOfClass:[UIImageView class]])
            ((UIView *)self.subviews[i]).frame = CGRectMake((i+1) * border + i*2, 2, 2, self.bounds.size.height + 2);
        else
            ((UIView *)self.subviews[i]).frame = CGRectMake((i-2) * border + (i-2)*2, 2, border, self.bounds.size.height);
    }
    [super layoutSubviews];
}

@end
