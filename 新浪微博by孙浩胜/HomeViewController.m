//
//  HomeViewController.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-17.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "HomeViewController.h"
#import "UIButton+FastBtn.h"
#import "TitleButton.h"
#import "ClassifyTableView.h"
#import "AFNetworking.h"
#import "MBProgressHUD+fastSetup.h"
#import "WeiboModel.h"
#import "UserModel.h"
#import "WeiboCell.h"
#import "CellModel.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "PhotoModel.h"
#import "MJRefresh.h"
#import <AVFoundation/AVFoundation.h>


#define TITLE_BUTTON_UP 1
#define TITLE_BUTTON_DOWN 2
#define CLIENT_ID 831372268
#define CLIENT_SECRET 1f624b050701de067967899646bb7072
#define UID 3192181484
@interface HomeViewController () <ClassifyTableViewDelegate>

@property (nonatomic,strong) ClassifyTableView *ctb; //下拉表格

@property (nonatomic,weak) TitleButton *titleBtn;

@property (nonatomic,strong) NSArray *weiboModels;

@property (nonatomic,strong) NSMutableArray *cellModels;



@end

@implementation HomeViewController
//数组的延迟加载

- (NSMutableArray *)cellModels
{
    if (_cellModels == nil) {
        _cellModels = [NSMutableArray array];
    }
    return _cellModels;
}
- (NSArray *)weiboModels
{
    if (_weiboModels == nil) {
        _weiboModels = [NSArray array];
    }
    return _weiboModels;
}
- (ClassifyTableView *)ctb
{
    if (_ctb == nil) {
        _ctb = [[ClassifyTableView alloc] initWithFrame:CGRectMake(0, 0, 200, 400)];
        _ctb.delegate = self;
        _ctb.titleBtn = _titleBtn;
    }
    return _ctb;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //表格初始化
    self.tableView.backgroundColor = [UIColor colorWithRed:226.0/255 green:226.0/255 blue:226.0/255 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    
    [self loadCurrentUserData];
    
    //添加下拉刷新
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableView.header beginRefreshing];
    
//    NSURL *songUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"]];
//    AVAudioPlayer *play = [[AVAudioPlayer alloc] initWithContentsOfURL:songUrl error:nil];
//    play.numberOfLoops = -1;
//    [play prepareToPlay];
//    [play play];
//    play.volume = 1.0;
//    
}

- (void)loadMoreData
{
    AFHTTPRequestOperationManager *AFNManager = [AFHTTPRequestOperationManager manager];
    
    //封装数据体
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"tokenInfo"] objectForKey:@"access_token"];
    dict[@"max_id"] = ((CellModel *)[self.cellModels lastObject]).weiboModel.idstr;
    dict[@"count"] = @5;
    
    [AFNManager GET:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //字典数组转模型数组
        self.weiboModels = [WeiboModel objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        
        NSMutableArray *cellModelsTemp = [NSMutableArray array];
        
        for (WeiboModel *weiboModel in self.weiboModels) {
            CellModel *cellModel = [[CellModel alloc] init];
            cellModel.weiboModel = weiboModel;
            [cellModelsTemp addObject:cellModel];
        }
        
        //合成新旧 数据
        [self.cellModels addObjectsFromArray:cellModelsTemp];
        
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.footer endRefreshing];
    }];

}

//加载当前用户信息
- (void)loadCurrentUserData
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"tokenInfo"] objectForKey:@"access_token"];
    dict[@"uid"] = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"tokenInfo"] objectForKey:@"uid"];
    AFHTTPRequestOperationManager *AFNManager = [AFHTTPRequestOperationManager manager];
    [AFNManager GET:@"https://api.weibo.com/2/users/show.json" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _userModel = [UserModel objectWithKeyValues:responseObject];
        //初始化导航栏
        [self setupNav];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

//显示新加载的微博个数
- (void)showNewWeiboCounts:(int)count
{
    UIButton *showView;
    if (count) {
        showView = [UIButton buttonWithTitle:[NSString stringWithFormat:@"增加%d条新微薄",count] BackgroundImageName:@"timeline_new_status_background_os7" target:nil action:nil];

    }
    else
        showView = [UIButton buttonWithTitle:@"没有新的微博" BackgroundImageName:@"timeline_new_status_background_os7" target:nil action:nil];
    
    showView.frame = CGRectMake(0, 24, self.view.window.frame.size.width, 40);
    [showView setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    showView.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.navigationController.view insertSubview:showView belowSubview:self.navigationController.navigationBar];
    
    [UIView animateWithDuration:1.0f animations:^{
        showView.center = CGPointMake(self.view.window.frame.size.width/2, 84);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:1.0 animations:^{
                showView.center = CGPointMake(self.view.window.frame.size.width/2, 44);
            } completion:^(BOOL finished) {
                if (finished) {
                    [showView removeFromSuperview];
                }
            }];
        }
    }];

}

//加载数据
- (void)loadData
{
    AFHTTPRequestOperationManager *AFNManager = [AFHTTPRequestOperationManager manager];
    
    //封装数据体
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"tokenInfo"] objectForKey:@"access_token"];
    
    //判断是否加载新数据
    if ((self.cellModels.count)) {
         dict[@"since_id"] = ((CellModel *)self.cellModels[0]).weiboModel.idstr;
    }
    else
        dict[@"count"] = @5;
   
    [AFNManager GET:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //字典数组转模型数组
        self.weiboModels = [WeiboModel objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        NSMutableArray *cellModelsTemp = [NSMutableArray array];
        for (WeiboModel *weiboModel in self.weiboModels) {
            CellModel *cellModel = [[CellModel alloc] init];
            cellModel.weiboModel = weiboModel;
            [cellModelsTemp addObject:cellModel];
        }
        
        //合成新旧 数据
        NSMutableArray *tempArr = [NSMutableArray array];
        [tempArr addObjectsFromArray:cellModelsTemp];
        [tempArr addObjectsFromArray:self.cellModels];
        self.cellModels = tempArr;
        
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
        
        [self showNewWeiboCounts:cellModelsTemp.count];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.header endRefreshing];
    }];

    
}

//初始化导航栏

- (void)setupNav
{
    [self addBarButtonItem];
    [self addTitleButton];
    
}
- (void)addTitleButton
{
    TitleButton *titleBtn = [TitleButton TitleButton];
    
    [titleBtn setImage:[UIImage imageNamed:@"navigationbar_arrow_down_os7"] forState:UIControlStateNormal];
    [titleBtn setTitle:@"首页" forState:UIControlStateNormal];
    [titleBtn setTitle:_userModel.name forState:UIControlStateNormal];
    
    [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _titleBtn = titleBtn;

    self.navigationItem.titleView = titleBtn;
}

- (void) addBarButtonItem
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithImageName:@"navigationbar_friendsearch_os7" HighlightImageName:@"navigationbar_friendsearch_highlighted_os7" target:self action:@selector(leftBtnClick)]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithImageName:@"navigationbar_pop_os7" HighlightImageName:@"navigationbar_pop_highlighted_os7" target:self action:@selector(rightBtnClick)]];
    
    
}


- (void) titleBtnClick:(TitleButton *)btn
{
    if (btn.tag == TITLE_BUTTON_UP) {
        [btn setImage:[UIImage imageNamed:@"navigationbar_arrow_down_os7"] forState:UIControlStateNormal];
        btn.tag = TITLE_BUTTON_DOWN;
        [self.ctb removeFromSuperview];
        
    }else
    {
        [btn setImage:[UIImage imageNamed:@"navigationbar_arrow_up_os7"] forState:UIControlStateNormal];
        btn.tag = TITLE_BUTTON_UP;
        [self.navigationController.view addSubview:self.ctb];
        
    }
}

- (void)rightBtnClick
{
    NSLog(@"rightbtn click");
}

- (void)leftBtnClick
{
    NSLog(@"leftbtn click");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --ClassifyTableViewDelegate
- (void)ClassifyTableView:(ClassifyTableView *)ctv selectedItem:(NSString *)itemName
{
    [_titleBtn setTitle:itemName forState:UIControlStateNormal];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellModels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeiboCell *cell = [WeiboCell cellWithTableView:tableView];
    
    cell.cellModel = self.cellModels[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellModel *cellModel = self.cellModels[indexPath.row];
    return cellModel.cellHeight;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UIViewController *vc = [[UIViewController alloc]init];
//    vc.view.backgroundColor = [UIColor redColor];
//    [self.navigationController pushViewController:vc animated:YES];
//}

@end
