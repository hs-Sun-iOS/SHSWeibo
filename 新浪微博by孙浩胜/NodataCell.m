//
//  NodataCell.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "NodataCell.h"
#import "UIImage+AutoStretch.h"


@implementation NodataCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString* reuseIdentifier = @"nodatacell";
    NodataCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[NodataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addShowInfo];
    }
    return self;
}

- (void)setCurrentState:(InfoTableViewState)currentState
{
    _currentState = currentState;
    if (_currentState == CommentState) {
        self.showInfo.text = @"还没有人评论~";
    } else if (_currentState == RetweetState)
        self.showInfo.text = @"还没有人转发~";
    else
        self.showInfo.text = @"还没有人赞过~";
}

- (void)addShowInfo
{
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 100)];
    bg.image = [UIImage autoStretchWithimageName:@"statusdetail_comment_background_middle"];
    bg.highlightedImage = [UIImage autoStretchWithimageName:@"statusdetail_comment_background_middle_highlighted"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 100)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.0];
    self.showInfo = label;
    [bg addSubview:label];
    [self.contentView addSubview:bg];
}

@end
