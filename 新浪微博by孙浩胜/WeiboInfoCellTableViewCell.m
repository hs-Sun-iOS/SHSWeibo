//
//  WeiboInfoCellTableViewCell.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/26.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "WeiboInfoCellTableViewCell.h"
#import "WeiboInfoModel.h"
#import "WeiboInfoTopView.h"

@interface WeiboInfoCellTableViewCell ()

@property (nonatomic,strong) WeiboInfoTopView *weiboInfoTopView;

@end

@implementation WeiboInfoCellTableViewCell

+ (instancetype)cellWithModel:(WeiboInfoModel *)weiboinfoModel tableView:(UITableView *)tableview
{
    static NSString *reuseIdentifier = @"infocell";
    WeiboInfoCellTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[WeiboInfoCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.weiboInfoModel = weiboinfoModel;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


-(void)setFrame:(CGRect)frame
{
    frame.origin.y += 10;
    frame.size.height -= 10;
    [super setFrame:frame];
}

- (WeiboInfoTopView *)weiboInfoTopView
{
    if (_weiboInfoTopView == nil) {
        _weiboInfoTopView = [[WeiboInfoTopView alloc] init];
        [self.contentView addSubview:_weiboInfoTopView];
    }
    return _weiboInfoTopView;
}
- (void)setWeiboInfoModel:(WeiboInfoModel *)weiboInfoModel
{
    _weiboInfoModel = weiboInfoModel;
    
    self.weiboInfoTopView.weiboInfoModel = weiboInfoModel;
}

@end
