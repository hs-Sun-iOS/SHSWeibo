//
//  WeiboCommentCell.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "WeiboCommentCell.h"
#import "WeiboInfoModel.h"
#import "WeiboInfoTopView.h"

@interface WeiboCommentCell ()

@property (nonatomic,weak) WeiboInfoTopView *weiboInfoTopView;

@end

@implementation WeiboCommentCell


+ (instancetype)cellWithtableView:(UITableView *)tableview
{
    static NSString *reuseIdentifier = @"commentcell";
    WeiboCommentCell *cell = [tableview dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[WeiboCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupWeiboInfoTopView];
    }
    return self;
}

- (void)setupWeiboInfoTopView
{
    WeiboInfoTopView *infoTopView = [[WeiboInfoTopView alloc] init];
    [self.contentView addSubview:infoTopView];
    self.weiboInfoTopView = infoTopView;
}
- (void)setWeiboInfoModel:(WeiboInfoModel *)weiboInfoModel
{
    _weiboInfoModel = weiboInfoModel;
    
    self.weiboInfoTopView.weiboInfoModel = weiboInfoModel;
}

@end
