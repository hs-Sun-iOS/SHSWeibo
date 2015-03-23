//
//  Tabbar.h
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-18.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Tabbar;
@protocol TabbarDelegate <NSObject>

@optional

- (void)tabbar:(Tabbar *)tabbar SelectedBtnFrom:(NSInteger)from to:(NSInteger)to;
- (void)tabbar:(Tabbar *)tabbar btndidClick:(UIButton *)btn;

@end

@interface Tabbar : UIView
@property (nonatomic,weak) UIButton *selectedBtn;
@property (nonatomic,assign) id<TabbarDelegate>delegate;
@property (nonatomic,strong) NSMutableArray *tabbarBtns;
- (void) addTabbarButtonWithItem:(UITabBarItem *)item;
@end
