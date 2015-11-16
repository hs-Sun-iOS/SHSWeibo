//
//  CellToolBar.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-22.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "CellToolBar.h"
#import "UIImage+AutoStretch.h"
#import "CellModel.h"
#import "WeiboModel.h"


@implementation CellToolBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.image = [UIImage autoStretchWithimageName:@"timeline_card_bottom_background_os7"];
        self.highlightedImage = [UIImage autoStretchWithimageName:@"timeline_card_bottom_background_highlighted_os7"];
        
        self.userInteractionEnabled = YES;
    
    
        UIImageView *line1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_card_bottom_line_os7"]];
        line1.contentMode = UIViewContentModeCenter;
        [self addSubview:line1];
        
        UIImageView *line2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_card_bottom_line_os7"]];
        line2.contentMode = UIViewContentModeCenter;
        [self addSubview:line2];
        
        self.retweetBtn = [self BtnWithTitle:@"转发" imageName:@"timeline_icon_retweet_os7" backgroundImage:@"timeline_card_leftbottom_highlighted_os7" buttonType:CellToolBarRetweetButton];
        
        self.commentBtn = [self BtnWithTitle:@"评论" imageName:@"timeline_icon_comment_os7" backgroundImage:@"timeline_card_middlebottom_highlighted_os7" buttonType:CellToolBarCommentButton];
        
        self.attitudeBtn = [self BtnWithTitle:@"赞" imageName:@"timeline_icon_unlike_os7" backgroundImage:@"timeline_card_rightbottom_highlighted_os7" buttonType:CellToolBarAttitudeButton];
        [self.attitudeBtn setImage:[UIImage imageNamed:@"statusdetail_comment_icon_like_highlighted"] forState:UIControlStateSelected];
        

        
    }
    return self;
}

- (void)setCellModel:(CellModel *)cellModel
{
    _cellModel = cellModel;
    
    self.frame = cellModel.bottomViewFrame;
    
    if (cellModel.weiboModel.reposts_count != 0) {
        [self.retweetBtn setTitle:[NSString stringWithFormat:@"%d",cellModel.weiboModel.reposts_count] forState:UIControlStateNormal];
    }
    else
        [self.retweetBtn setTitle:@"转发" forState:UIControlStateNormal];
    
    if (cellModel.weiboModel.comments_count != 0) {
        [self.commentBtn setTitle:[NSString stringWithFormat:@"%d",cellModel.weiboModel.comments_count] forState:UIControlStateNormal];
    }
    else
        [self.commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    
    if (cellModel.weiboModel.attitudes_count != 0) {
        [self.attitudeBtn setTitle:[NSString stringWithFormat:@"%d",cellModel.weiboModel.attitudes_count] forState:UIControlStateNormal];
    }
    else
        [self.attitudeBtn setTitle:@"赞" forState:UIControlStateNormal];
}

- (UIButton *)BtnWithTitle:(NSString *)title imageName:(NSString *)imageName backgroundImage:(NSString *)backgroundImage buttonType:(CellToolBarButtonType)buttonType
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.adjustsImageWhenHighlighted = NO;
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage autoStretchWithimageName:backgroundImage] forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = buttonType;
    [self addSubview:btn];
   
    return btn;
}

- (void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(CellToolBar:WithButtonType:)]) {
        [_delegate CellToolBar:self WithButtonType:btn.tag];
    }
    
    if (btn.tag == CellToolBarAttitudeButton) {
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
    [super layoutSubviews];
    
    CGFloat border = (self.bounds.size.width - 4) / 3;
    for (int i = 0;i < self.subviews.count ; i++) {
        if ([self.subviews[i] isKindOfClass:[UIImageView class]])
            ((UIView *)self.subviews[i]).frame = CGRectMake((i+1) * border + i*2, 0, 2, self.bounds.size.height);
        else
            ((UIView *)self.subviews[i]).frame = CGRectMake((i-2) * border + (i-2)*2, 0, border, self.bounds.size.height);
    }
}

@end
