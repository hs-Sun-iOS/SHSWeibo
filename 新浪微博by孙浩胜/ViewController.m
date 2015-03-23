//
//  ViewController.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-17.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "DiscoverViewController.h"
#import "UsersViewController.h"
#import "CustomNavigationController.h"
#import "SendWeiboViewController.h"
#import "Tabbar.h"
#import "MJRefresh.h"
#import "UserModel.h"
@interface ViewController () <TabbarDelegate>
@property (nonatomic,weak) Tabbar *customTabbar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadCustonTabbar];
    
    //初始化所有子视图控制器
    [self setupAllChildViewController];

    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}
#pragma mark --加载自定义tabbar
- (void)loadCustonTabbar
{
    Tabbar *customTabbar = [[Tabbar alloc] init];
    customTabbar.frame = self.tabBar.bounds;
    [self.tabBar addSubview:customTabbar];
    self.customTabbar = customTabbar;
    self.customTabbar.delegate = self;
}


#pragma mark --tabbarDelegate

- (void)tabbar:(Tabbar *)tabbar SelectedBtnFrom:(NSInteger)from to:(NSInteger)to
{
    
    //再次点击首页 回到顶部 并刷新
    if (from == to && from == 0) {
        HomeViewController *homeVC = (HomeViewController *)((UINavigationController *)self.viewControllers[0]).viewControllers[0];
        homeVC.tableView.contentOffset = CGPointMake(0, -64);
        [homeVC.tableView.header beginRefreshing];
    }
    
    
    self.selectedIndex = to;
}

-(void)tabbar:(Tabbar *)tabbar btndidClick:(UIButton *)btn
{
    SendWeiboViewController *sendVC = [[SendWeiboViewController alloc] init];
    HomeViewController *homeVC = (HomeViewController *)((UINavigationController *)self.viewControllers[0]).viewControllers[0];
    sendVC.title = homeVC.userModel.name;
    CustomNavigationController *Nav = [[CustomNavigationController alloc] initWithRootViewController:sendVC];
    [self presentViewController:Nav animated:YES completion:^{
    }];
}


#pragma mark --初始化全部子视图控制器
- (void) setupAllChildViewController{
    HomeViewController *HomeVC = [[HomeViewController alloc] init];
    HomeVC.tabBarItem.badgeValue = @"5";
    [self setupChildViewController:HomeVC title:@"首页" itemImageName:@"tabbar_home_os7" selectedImageName:@"tabbar_home_selected_os7"];
    
    
    
    MessageViewController *MessageVC = [[MessageViewController alloc] init];
    MessageVC.tabBarItem.badgeValue = nil;
    [self setupChildViewController:MessageVC title:@"消息" itemImageName:@"tabbar_message_center_os7" selectedImageName:@"tabbar_message_center_selected_os7"];
    
    DiscoverViewController *DiscoverVC = [[DiscoverViewController alloc] init];
    DiscoverVC.tabBarItem.badgeValue = @"10";
    [self setupChildViewController:DiscoverVC title:@"发现" itemImageName:@"tabbar_discover_os7" selectedImageName:@"tabbar_discover_selected_os7"];
    
    
    UsersViewController *UsersVC = [[UsersViewController alloc] init];
    UsersVC.tabBarItem.badgeValue = @"2";
    [self setupChildViewController:UsersVC title:@"我" itemImageName:@"tabbar_profile_os7" selectedImageName:@"tabbar_profile_selected_os7"];
}

#pragma mark -- 初始化子视图控制器

- (void) setupChildViewController:(UIViewController *)childVC title:(NSString *)title itemImageName:(NSString *)imageName selectedImageName :(NSString *)selectedImageName{
    childVC.title = title;
    //childVC.tabBarItem.title = title;
    childVC.tabBarItem.image = [UIImage imageNamed:imageName];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CustomNavigationController *Nav = [[CustomNavigationController alloc] initWithRootViewController:childVC];
    [self addChildViewController:Nav];
    [self.customTabbar addTabbarButtonWithItem:childVC.tabBarItem];
}

@end
