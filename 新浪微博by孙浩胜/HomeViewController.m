//
//  HomeViewController.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-17.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "HomeViewController.h"
#import "ViewController.h"
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
#import "CellToolBar.h"
#import "CellTopView.h"
#import "CellRetweetView.h"
#import "RetweetViewController.h"
#import "CommentViewController.h"
#import "WeiboInfoViewController.h"
#import "DataBase.h"
#import <AudioToolbox/AudioToolbox.h>


#define TITLE_BUTTON_UP 1
#define TITLE_BUTTON_DOWN 2
#define CLIENT_ID 831372268
#define CLIENT_SECRET 1f624b050701de067967899646bb7072
#define UID 3192181484
@interface HomeViewController () <ClassifyTableViewDelegate,CellToolBarDelegate,UITableViewDataSource,UITableViewDelegate> {
    NSString *url;
    ClassifyTableViewItemType _currentCTVItemType;
}

@property (nonatomic,strong) ClassifyTableView *ctb; //下拉表格

@property (nonatomic,weak) TitleButton *titleBtn;

@property (nonatomic,strong) NSArray *weiboModels;

@property (nonatomic,weak) NSMutableArray *cellModels;

@property (nonatomic,strong) NSMutableArray *homeCellModels;
@property (nonatomic,strong) NSMutableArray *friendCellModels;
@property (nonatomic,strong) NSMutableArray *userCellModels;

@end

/*https://api.weibo.com/2/statuses/public_timeline.json //公共
 https://api.weibo.com/2/statuses/user_timeline.json // 当前用户 、 uid
 https://api.weibo.com/2/statuses/bilateral_timeline.json  // 双向关注
 
 @"https://api.weibo.com/2/statuses/friends_timeline.json"
 
 */


@implementation HomeViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];

    url = @"https://api.weibo.com/2/statuses/public_timeline.json";
    _currentCTVItemType = ClassifyTableViewItemTypeHome;
    [self loadCurrentUserData];
    
    //表格初始化
    self.tableView.backgroundColor = [UIColor colorWithRed:226.0/255 green:226.0/255 blue:226.0/255 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delaysContentTouches = NO;
    
    //添加下拉刷新
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadDataFromWebservice)];
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.footer.automaticallyRefresh = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushOriginalWeiboInfo:) name:@"pushOriginal" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"tokenInfo"] objectForKey:@"access_token"];
    dict[@"count"] = @10;
    if ([DataBase getJsonDataArrayFromDataBaseWithParameters:dict].count != 0) {
        [self LoadLocalCacheDataWithParameters:dict];
        self.tableView.header.state = MJRefreshFooterStateIdle;
    } else
        [self.tableView.header beginRefreshing];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadMoreData
{
    //封装数据体
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"tokenInfo"] objectForKey:@"access_token"];
    dict[@"max_id"] = ((CellModel *)[self.cellModels lastObject]).weiboModel.idstr;
    dict[@"count"] = @10;
    
    if ([DataBase getJsonDataArrayFromDataBaseWithParameters:dict].count != 0) {
        self.weiboModels = [WeiboModel objectArrayWithKeyValuesArray:[DataBase getJsonDataArrayFromDataBaseWithParameters:dict]];
    } else
    {
        AFHTTPRequestOperationManager *AFNManager = [AFHTTPRequestOperationManager manager];
        [AFNManager GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            //字典数组转模型数组
            self.weiboModels = [WeiboModel objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            [self.tableView.footer endRefreshing];
        }];
    }
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
- (void)showNewWeiboCounts:(NSInteger)count
{
    UIButton *showView;
    if (count != 0) {
        showView = [UIButton buttonWithTitle:[NSString stringWithFormat:@"增加%ld条新微博",count] BackgroundImageName:@"timeline_new_status_background_os7" target:nil action:nil];
        [((ViewController *)self.tabBarController) loadUnreadData];
        
        NSURL *songUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"]];
        SystemSoundID soundid;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(songUrl), &soundid);
        AudioServicesPlaySystemSound(soundid);
    }
    else {
        showView = [UIButton buttonWithTitle:@"没有新的微博" BackgroundImageName:@"timeline_new_status_background_os7" target:nil action:nil];
    }
    
    showView.frame = CGRectMake(0, 24, self.view.window.frame.size.width, 40);
    [showView setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    showView.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.navigationController.view insertSubview:showView belowSubview:self.navigationController.navigationBar];
    
    [UIView animateWithDuration:1.0f animations:^{
        showView.center = CGPointMake(self.view.window.frame.size.width/2, 84);
    } completion:^(BOOL finished) {
        if (finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1.0 animations:^{
                    showView.center = CGPointMake(self.view.window.frame.size.width/2, 44);
                } completion:^(BOOL finished) {
                    [showView removeFromSuperview];
                }];
            });
        } else {
            [showView removeFromSuperview];
        }
    }];

}

//加载网络数据数据
- (void)loadDataFromWebservice
{
    //封装数据体
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"tokenInfo"] objectForKey:@"access_token"];
    
    //判断是否加载新数据
    if ((self.cellModels.count)) {
        dict[@"since_id"] = ((CellModel *)self.cellModels[0]).weiboModel.idstr;
        dict[@"count"] = @5;
    }
    else
        dict[@"count"] = @10;
    
    AFHTTPRequestOperationManager *AFNManager = [AFHTTPRequestOperationManager manager];
    [AFNManager GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (_currentCTVItemType == ClassifyTableViewItemTypeHome) {
            [DataBase addJsonDataArrayToDataBase:responseObject[@"statuses"]];
        }
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
        [self.cellModels removeAllObjects];
        [self.cellModels addObjectsFromArray:tempArr];
        
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
        
        [self showNewWeiboCounts:cellModelsTemp.count];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.header endRefreshing];
    }];
}

//加载本地数据
- (void)LoadLocalCacheDataWithParameters:(NSDictionary *)parameters
{
    self.weiboModels = [WeiboModel objectArrayWithKeyValuesArray:[DataBase getJsonDataArrayFromDataBaseWithParameters:parameters]];
    NSMutableArray *cellModelsTemp = [NSMutableArray array];
    for (WeiboModel *weiboModel in self.weiboModels) {
        CellModel *cellModel = [[CellModel alloc] init];
        cellModel.weiboModel = weiboModel;
        [cellModelsTemp addObject:cellModel];
    }
    [self.cellModels addObjectsFromArray:cellModelsTemp];
    [self.tableView reloadData];
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

- (void) cellToolBarRetweetButtonClickWithToolBar:(CellToolBar *)toolBar
{
    RetweetViewController *retweetVC = [[RetweetViewController alloc] init];
    retweetVC.title = self.userModel.name;
    retweetVC.rewteetedWeiboModel = toolBar.cellModel.weiboModel;

    [self.navigationController pushViewController:retweetVC animated:YES];
}

- (void)cellToolBarCommentButtonClickWithToolBar:(CellToolBar *)toolBar
{
    CommentViewController *commentVC = [[CommentViewController alloc] init];
    commentVC.title = self.userModel.name;
    commentVC.weiboId = toolBar.cellModel.weiboModel.idstr;
    
    [self.navigationController pushViewController:commentVC animated:YES];
}
#pragma mark -- CellToolBarDelegate

- (void)CellToolBar:(CellToolBar *)toolBar WithButtonType:(CellToolBarButtonType)buttonType
{
    switch (buttonType) {
        case CellToolBarRetweetButton:
            [self cellToolBarRetweetButtonClickWithToolBar:toolBar];
            break;
        case CellToolBarCommentButton:
            [self cellToolBarCommentButtonClickWithToolBar:toolBar];
            break;
        default:
            break;
    }
}

#pragma mark --ClassifyTableViewDelegate
- (void)ClassifyTableView:(ClassifyTableView *)ctv selectedItemType:(ClassifyTableViewItemType)itemType
{
    NSString *title = nil;
    switch (itemType) {
        case ClassifyTableViewItemTypeHome:
            title = self.userModel.name;
            url = @"https://api.weibo.com/2/statuses/friends_timeline.json";
            if (self.homeCellModels.count == 0) {
                [self.tableView.header beginRefreshing];
            }
            break;
        case ClassifyTableViewItemTypeFriend:
            title = @"好友圈";
            url = @"https://api.weibo.com/2/statuses/public_timeline.json";
            if (self.friendCellModels.count == 0) {
                [self.tableView.header beginRefreshing];
            }
            break;
        case ClassifyTableViewItemTypeUser:
            title = @"我的微博";
            url = @"https://api.weibo.com/2/statuses/user_timeline.json";
            if (self.userCellModels.count == 0) {
                [self.tableView.header beginRefreshing];
            }
            break;
        default:
            break;
    }
    if (_currentCTVItemType == itemType) {
        [self.tableView.header beginRefreshing];
    }
    _currentCTVItemType = itemType;
    [_titleBtn setTitle:title forState:UIControlStateNormal];
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellModels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeiboCell *cell = [WeiboCell cellWithTableView:tableView];
    
    cell.bottomView.delegate = self;
    
    cell.cellModel = self.cellModels[indexPath.row];
    //取消cell的点击延迟
    for (id obj in cell.subviews)
    {
        if ([NSStringFromClass([obj class])isEqualToString:@"UITableViewCellScrollView"])
        {
            UIScrollView *scroll = (UIScrollView *) obj;
            scroll.delaysContentTouches =NO;
            break;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellModel *cellModel = self.cellModels[indexPath.row];
    return cellModel.cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboCell *cell = (WeiboCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    WeiboInfoViewController *weiboInfo = [[WeiboInfoViewController alloc] init];
    weiboInfo.weiboModel = cell.cellModel.weiboModel;
    weiboInfo.userMidel = self.userModel;
    [self.navigationController pushViewController:weiboInfo animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)pushOriginalWeiboInfo:(NSNotification *)notice
{
    WeiboInfoViewController *weiboInfo = [[WeiboInfoViewController alloc] init];
    weiboInfo.weiboModel = notice.userInfo[@"weiboModel"];
    weiboInfo.userMidel = self.userModel;
    [self.navigationController pushViewController:weiboInfo animated:YES];
}
#pragma mark - lazy load
//数组的延迟加载

- (NSMutableArray *)cellModels
{
    switch (_currentCTVItemType) {
        case ClassifyTableViewItemTypeHome:
            _cellModels = self.homeCellModels;
            break;
        case ClassifyTableViewItemTypeFriend:
            _cellModels = self.friendCellModels;
            break;
        case ClassifyTableViewItemTypeUser:
            _cellModels = self.userCellModels;
            break;
        default:
            break;
    }
    return _cellModels;
}
- (NSMutableArray *)homeCellModels {
    if (!_homeCellModels) {
        _homeCellModels = [NSMutableArray array];
    }
    return _homeCellModels;
}
- (NSMutableArray *)friendCellModels {
    if (!_friendCellModels) {
        _friendCellModels = [NSMutableArray array];
    }
    return _friendCellModels;
}
- (NSMutableArray *)userCellModels {
    if (!_userCellModels) {
        _userCellModels = [NSMutableArray array];
    }
    return _userCellModels;
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
        _ctb = [[ClassifyTableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 50, 200, 400)];
        _ctb.delegate = self;
        _ctb.titleBtn = _titleBtn;
        _ctb.itemNames = [NSMutableArray arrayWithArray:@[@"首页",@"好友圈",@"我的微博"]];
    }
    return _ctb;
}
@end
