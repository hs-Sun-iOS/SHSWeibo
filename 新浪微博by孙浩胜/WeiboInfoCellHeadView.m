//
//  WeiboInfoCellHeadView.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/26.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "WeiboInfoCellHeadView.h"
#import "UIButton+FastBtn.h"
#import "WeiboModel.h"
#import "UIImage+AutoStretch.h"



@interface WeiboInfoCellHeadView ()

@property (nonatomic,weak) UIButton *selectedBtn;

@property (nonatomic,weak) UIButton *retweetBtn;

@property (nonatomic,weak) UIButton *commentBtn;

@property (nonatomic,weak) UIButton *attitudeBtn;

@property (nonatomic,weak) UIImageView *divider;

@property (nonatomic,weak) UIImageView *indicator;

@end
@implementation WeiboInfoCellHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50);
        self.image = [UIImage autoStretchWithimageName:@"statusdetail_comment_background_middle"];
        [self setupChildView];
        
    }
    return self;
}

- (void)setWeiboModel:(WeiboModel *)weiboModel
{
    _weiboModel = weiboModel;
    
    [self.retweetBtn setTitle:[NSString stringWithFormat:@"转发 %d",_weiboModel.reposts_count] forState:UIControlStateNormal];
    CGSize size = [self.retweetBtn.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.retweetBtn.titleLabel.font} context:nil].size;
    self.retweetBtn.frame = CGRectMake(10, 0, size.width, size.height);
    self.retweetBtn.center = CGPointMake(self.retweetBtn.center.x, self.frame.size.height/2);
    
    self.divider.frame = CGRectMake(CGRectGetMaxX(self.retweetBtn.frame) + 10, 0, 2, 50);
    
    [self.commentBtn setTitle:[NSString stringWithFormat:@"评论 %d",_weiboModel.comments_count] forState:UIControlStateNormal];
    size = [self.commentBtn.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.commentBtn.titleLabel.font} context:nil].size;
    self.commentBtn.frame = CGRectMake(CGRectGetMaxX(self.divider.frame) + 10, 0, size.width, size.height);
    self.commentBtn.center = CGPointMake(self.commentBtn.center.x, self.frame.size.height/2);
    
    [self.attitudeBtn setTitle:[NSString stringWithFormat:@"赞 %d",_weiboModel.attitudes_count] forState:UIControlStateNormal];
    size = [self.attitudeBtn.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.attitudeBtn.titleLabel.font} context:nil].size;
    self.attitudeBtn.frame = CGRectMake(self.frame.size.width - size.width - 10, 0, size.width, size.height);
    self.attitudeBtn.center = CGPointMake(self.attitudeBtn.center.x, self.frame.size.height/2);
    
    self.indicator.center = CGPointMake(self.selectedBtn.center.x, 49);
}

- (void)setupChildView
{
    UIButton *retweetBtn = [UIButton buttonWithTitle:@"转发" NormalTitleColor:[UIColor lightGrayColor] SelectedTitleColor:[UIColor blackColor] target:self action:@selector(btnClick:)];
    retweetBtn.tag = RetweetButtonType;
    self.retweetBtn = retweetBtn;
    [self addSubview:retweetBtn];
    
    UIImageView *divider = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_card_bottom_line_os7"]];
    [self addSubview:divider];
    self.divider = divider;
    
    UIButton *CommentBtn = [UIButton buttonWithTitle:@"评论" NormalTitleColor:[UIColor lightGrayColor] SelectedTitleColor:[UIColor blackColor] target:self action:@selector(btnClick:)];
    CommentBtn.tag = CommentButtonType;
    CommentBtn.selected = YES;
    self.selectedBtn = CommentBtn;
    [self addSubview:CommentBtn];
    self.commentBtn = CommentBtn;
    
    UIButton *attitudeBtn = [UIButton buttonWithTitle:@"赞" NormalTitleColor:[UIColor lightGrayColor] SelectedTitleColor:[UIColor blackColor] target:self action:@selector(btnClick:)];
    attitudeBtn.tag = AttitudeButtonType;
    [self addSubview:attitudeBtn];
    self.attitudeBtn = attitudeBtn;
    

    UIImageView *indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"statusdetail_segmented_bottom_arrow"]];
    [self addSubview:indicator];
    self.indicator = indicator;
    
    
}

- (void)btnClick:(UIButton *)btn
{
    self.selectedBtn.selected = NO;
    self.selectedBtn = btn;
    btn.selected = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.indicator.center = CGPointMake(btn.center.x, 51);
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"headbtn" object:nil userInfo:@{@"btnType":[NSString stringWithFormat:@"%ld",(long)btn.tag]}];
}

@end
