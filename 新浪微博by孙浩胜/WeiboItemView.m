//
//  WeiboItemView.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/25.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "WeiboItemView.h"
#import "WeiboModel.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"

#define BORDER 5

@interface WeiboItemView ()

@property (nonatomic,weak) UIImageView *headPhoto;

@property (nonatomic,weak) UILabel *name;

@property (nonatomic,weak) UILabel *text;


@end

@implementation WeiboItemView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:231.0/255 green:231.0/255 blue:231.0/255 alpha:1.0];
        [self setupSubviews];
        
    }
    return self;
}

- (void)setupSubviews
{
    UIImageView *headPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self addSubview:headPhoto];
    self.headPhoto = headPhoto;
    
    UILabel *name = [[UILabel alloc] init];
    name.font = [UIFont boldSystemFontOfSize:13.0];
    name.textColor = [UIColor blackColor];
    [self addSubview:name];
    self.name = name;
    
    UILabel *text = [[UILabel alloc] init];
    text.font = [UIFont systemFontOfSize:11.0];
    text.textColor = [UIColor grayColor];
    text.numberOfLines = 0;
    [self addSubview:text];
    self.text = text;
}

- (void)setWeiboModel:(WeiboModel *)weiboModel
{
    _weiboModel = weiboModel;
    
    if (weiboModel.retweeted_status) {
        [self layoutSubviewsFromWeiboModel:weiboModel.retweeted_status];
        
    } else
    {
        [self layoutSubviewsFromWeiboModel:weiboModel];
    }

}

- (void)layoutSubviewsFromWeiboModel:(WeiboModel *)weiboModel
{
    [self.headPhoto setImageWithURL:[NSURL URLWithString:weiboModel.user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    
    self.name.text = [NSString stringWithFormat:@"@%@",weiboModel.user.name];
    CGSize nameSize = [self.name.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.name.font} context:nil].size;
    self.name.frame = CGRectMake(CGRectGetMaxX(self.headPhoto.frame) + BORDER, BORDER, nameSize.width, nameSize.height);
    
    self.text.text = weiboModel.text;
    CGSize textSize = [self.text.text boundingRectWithSize:CGSizeMake(self.frame.size.width - self.headPhoto.frame.size.width - 2*BORDER, self.frame.size.height - nameSize.height - 2*BORDER) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.text.font} context:nil].size;
    self.text.frame = CGRectMake(self.name.frame.origin.x, CGRectGetMaxY(self.name.frame) + BORDER, textSize.width, textSize.height);
    
}
@end
