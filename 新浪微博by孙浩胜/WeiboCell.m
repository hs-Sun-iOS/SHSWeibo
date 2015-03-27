//
//  WeiboCell.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-21.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "WeiboCell.h"
#import "CellModel.h"
#import "WeiboModel.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"
#import "UIImage+AutoStretch.h"
#import "CellToolBar.h"
#import "CellTopView.h"

@interface WeiboCell ()

@end

@implementation WeiboCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *cellIdentify = @"weibo_cell";
    
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    
    if (cell == nil) {
        cell = [[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addAllView];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    frame.origin.x += 10;
    frame.origin.y += 10;
    frame.size.width -=20;
    frame.size.height -= 10;
    [super setFrame:frame];
}

- (void)addAllView
{
    CellTopView *cellTopView = [[CellTopView alloc] init];
    [self.contentView addSubview:cellTopView];
    self.cellTopView = cellTopView;
    
    CellToolBar *bottomView = [[CellToolBar alloc] init];
    [self.contentView addSubview:bottomView];
    self.bottomView = bottomView;
}

- (void)setCellModel:(CellModel *)cellModel
{
    _cellModel = cellModel;
    _cellTopView.cellModel = cellModel;
    _bottomView.cellModel = cellModel;
}
@end
