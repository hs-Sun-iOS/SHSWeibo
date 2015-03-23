//
//  TabbarButton.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-18.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "TabbarButton.h"
#import "BadgeValueButton.h"


@interface TabbarButton ()
@property (nonatomic,strong) BadgeValueButton *badgeValueBtn;
@property (nonatomic,weak) UITabBarItem *item;

@end

@implementation TabbarButton


//取消按钮的高亮
- (void)setHighlighted:(BOOL)highlighted{}


- (TabbarButton *)initWithItem:(UITabBarItem *)item
{
    
    
    TabbarButton *btn = [[TabbarButton alloc] init];
    
    btn.imageView.contentMode = UIViewContentModeCenter;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    
    
    [btn setTitle:item.title forState:UIControlStateNormal];
    [btn setImage:item.image forState:UIControlStateNormal];
    [btn setImage:item.selectedImage forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    
    btn.badgeValueBtn = [[BadgeValueButton alloc] initWithBadgeView:item.badgeValue];
    
    [btn addSubview:btn.badgeValueBtn];
    [_item addObserver:btn forKeyPath:@"badgeValue" options:0 context:nil];
    
    return btn;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UITabBarItem *item = (UITabBarItem *)object;
    _item = item;
    self.badgeValueBtn.badgeValue = item.badgeValue;
}

- (void)dealloc
{
    [_item removeObserver:self forKeyPath:@"badgeValue"];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.origin.x, contentRect.origin.y, contentRect.size.width, contentRect.size.height*0.6);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.origin.x, self.imageView.frame.size.height, contentRect.size.width, contentRect.size.height-self.imageView.frame.size.height);
}

@end
