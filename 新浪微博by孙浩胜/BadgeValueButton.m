//
//  BadgeValueButton.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-18.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "BadgeValueButton.h"
#import "UIImage+AutoStretch.h"

@implementation BadgeValueButton

- (BadgeValueButton *)initWithBadgeView:(NSString *)badgeValue
{
    BadgeValueButton *badgeValuebtn = [[BadgeValueButton alloc] init];
    [badgeValuebtn setBackgroundImage:[UIImage autoStretchWithimageName:@"main_badge_os7"] forState:UIControlStateNormal];
    badgeValuebtn.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    badgeValuebtn.userInteractionEnabled = NO;
    badgeValuebtn.badgeValue = badgeValue;
    badgeValuebtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    return badgeValuebtn;
}

- (void)setBadgeValue:(NSString *)badgeValue
{
    if (badgeValue) {
        self.hidden = NO;
        _badgeValue = badgeValue;
        [self setTitle:self.badgeValue forState:UIControlStateNormal];
        CGFloat Y = 2;
        CGFloat Height = self.currentBackgroundImage.size.height;
        CGSize size = CGSizeMake(40, Height);
        CGFloat Width = [badgeValue boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size.width + 13;
        CGFloat X = self.superview.frame.size.width - Width -10;
       
        
        self.frame = CGRectMake(X,Y,Width,Height);
        
    }else
        self.hidden = YES;
}

@end
