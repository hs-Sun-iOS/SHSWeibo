//
//  BadgeValueButton.h
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-18.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgeValueButton : UIButton
@property (nonatomic,copy) NSString *badgeValue;


- (BadgeValueButton *)initWithBadgeView:(NSString *)badgeValue;


@end
