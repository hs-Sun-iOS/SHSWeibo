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
#import "UnReadModel.h"
#import "AFNetworking.h"
#import "MJExtension.h"


#define UID 3192181484
@interface ViewController () <TabbarDelegate>
@property (nonatomic,weak) Tabbar *customTabbar;

@property (nonatomic,strong) UnReadModel *unReadModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadCustonTabbar];
    
    //初始化所有子视图控制器
    [self setupAllChildViewController];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(loadUnreadData) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    

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



//加载未读数据
- (void)loadUnreadData
{
    // https://rm.api.weibo.com/2/remind/unread_count.json
    AFHTTPRequestOperationManager *AFNManager = [AFHTTPRequestOperationManager manager];
    
    //封装数据体
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"tokenInfo"] objectForKey:@"access_token"];
    dict[@"uid"] = @UID;
    
    [AFNManager GET:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //字典数组转模型数组
        self.unReadModel = [UnReadModel objectWithKeyValues:responseObject];
        //NSLog(@"%d",self.unReadModel.status);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)setUnReadModel:(UnReadModel *)unReadModel
{
    _unReadModel = unReadModel;
    if (unReadModel.status == 0) {
        ((UIViewController *)self.viewControllers[0]).tabBarItem.badgeValue = nil;
    } else
        ((UIViewController *)self.viewControllers[0]).tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",unReadModel.status];
    if ([unReadModel messageCount] == 0) {
        ((UIViewController *)self.viewControllers[1]).tabBarItem.badgeValue = nil;
    }
    else
        ((UIViewController *)self.viewControllers[1]).tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",[unReadModel messageCount]];
    if (unReadModel.follower == 0) {
         ((UIViewController *)self.viewControllers[3]).tabBarItem.badgeValue = nil;
    }
    else
         ((UIViewController *)self.viewControllers[3]).tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",unReadModel.follower];
    
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

#pragma mark --tabbarDelegate
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
    [self setupChildViewController:HomeVC title:@"首页" itemImageName:@"tabbar_home_os7" selectedImageName:@"tabbar_home_selected_os7"];
    
    
    
    MessageViewController *MessageVC = [[MessageViewController alloc] init];
    [self setupChildViewController:MessageVC title:@"消息" itemImageName:@"tabbar_message_center_os7" selectedImageName:@"tabbar_message_center_selected_os7"];
    
    DiscoverViewController *DiscoverVC = [[DiscoverViewController alloc] init];
    [self setupChildViewController:DiscoverVC title:@"发现" itemImageName:@"tabbar_discover_os7" selectedImageName:@"tabbar_discover_selected_os7"];
    
    
    UsersViewController *UsersVC = [[UsersViewController alloc] init];
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
