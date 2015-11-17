//
//  Tabbar.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-18.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "Tabbar.h"
#import "TabbarButton.h"


@implementation Tabbar

- (id)init
{
    self = [super init];
    if(self)
    {
        //添加 “+”号 按钮
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_os7"] forState:UIControlStateNormal];
        [addBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted_os7"] forState:UIControlStateHighlighted];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_os7"] forState:UIControlStateNormal];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted_os7"] forState:UIControlStateHighlighted];
        addBtn.frame = CGRectMake(0, 0, addBtn.currentBackgroundImage.size.width, addBtn.currentBackgroundImage.size.height);
        [addBtn addTarget:self action:@selector(addbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addBtn];
        return self;
    }
    return nil;
}

- (NSMutableArray *)tabbarBtns
{
    if (_tabbarBtns == nil) {
        _tabbarBtns = [NSMutableArray array];
    }
    return _tabbarBtns;
}

- (void)addTabbarButtonWithItem:(UITabBarItem *)item
{
    TabbarButton *btn = [[TabbarButton alloc]initWithItem:item];
    
    [self addSubview:btn];

    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    
    [self.tabbarBtns addObject:btn];
    
    if (self.tabbarBtns.count == 1) {
        [self btnClick:btn];
    }
}

- (void)addbtnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(tabbar:btndidClick:)]) {
        [self.delegate tabbar:self btndidClick:btn];
    }
   
}

- (void)btnClick:(UIButton *)btn
{
    if([self.delegate respondsToSelector:@selector(tabbar:SelectedBtnFrom:to:)]) {
        [self.delegate tabbar:self SelectedBtnFrom:self.selectedBtn.tag to:btn.tag];
    }
    
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    self.selectedBtn = btn;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat btnY = self.bounds.origin.y;
    CGFloat btnW = self.bounds.size.width/self.subviews.count;
    CGFloat btnH = self.bounds.size.height;
    
    UIButton *btn = (UIButton *)[self.subviews objectAtIndex:0];
    btn.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    for (int index = 0; index < self.tabbarBtns.count; index++) {
        UIView *childView = self.tabbarBtns[index];
        CGFloat btnX = btnW*index;
        if(index > 1)
            btnX += btnW;
        childView.frame = CGRectMake(btnX, btnY, btnW, btnH);
        childView.tag = index;
        
    }
}

@end
