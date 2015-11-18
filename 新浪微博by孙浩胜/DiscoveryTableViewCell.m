//
//  DiscoveryTableViewCell.m
//  新浪微博by孙浩胜
//
//  Created by sunhaosheng on 15/11/18.
//  Copyright © 2015年 孙浩胜. All rights reserved.
//

#import "DiscoveryTableViewCell.h"

@implementation DiscoveryTableViewCell

- (void)awakeFromNib {
}

- (void)configureCellWithItem:(DiscoveryItemsModel *)item {
    if (item.title) {
        self.titleLabel.text = item.title;
        self.titleLabel.hidden = NO;
    } else {
        self.titleLabel.hidden = YES;
    }
    if (item.image) {
        self.iconImageView.image = item.image;
        self.iconImageView.hidden = NO;
    } else {
        self.iconImageView.hidden = YES;
    }
    if (item.contentView) {
        [self.BgView addSubview:item.contentView];
        self.BgView.hidden = NO;
    } else {
        self.BgView.hidden = YES;
    }
}

@end
