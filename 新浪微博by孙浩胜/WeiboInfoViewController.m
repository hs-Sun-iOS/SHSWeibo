//
//  WeiboInfoViewController.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/26.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "WeiboInfoViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+fastSetup.h"
#import "WeiboInfoModel.h"
#import "WeiboModel.h"
#import "UserModel.h"
#import "WeiboCommentModel.h"
#import "WeiboInfoCellHeadView.h"
#import "WeiboInfoCellTableViewCell.h"
#import "WeiboCommentCell.h"
#import "WeiboInfoToolbar.h"
#import "RetweetViewController.h"
#import "CommentViewController.h"
#import "NodataCell.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "UIImage+AutoStretch.h"
#import "UIButton+FastBtn.h"


@interface WeiboInfoViewController () <WeiboInfoToolBarDelegate,UITableViewDataSource,UITableViewDelegate>
/**网络原始数据*/
@property (nonatomic,strong) NSArray *weiboOriginDates;
/**评论数据(frame)*/
@property (nonatomic,strong) NSMutableArray *weiboCommentModels;
/**转发数据(frame)*/
@property (nonatomic,strong) NSMutableArray *weiboRetweetModels;

@property (nonatomic,strong) WeiboInfoModel *weiboInfoModel;

@property (nonatomic,strong) WeiboInfoCellHeadView *headView;

@property (nonatomic,assign) NSUInteger currentState;

@end
@implementation WeiboInfoViewController
@synthesize weiboOriginDates = _weiboOriginDates;

- (void)viewDidLoad {
    [super viewDidLoad];
    //属性初始化
    self.title = @"微博正文";
    _currentState = CommentState;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:226.0/255 green:226.0/255 blue:226.0/255 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    __block WeiboInfoViewController *infoVC = self;
    
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        
        if (infoVC.currentState == CommentState) {
            [infoVC LoadDataWithUrl:@"https://api.weibo.com/2/comments/show.json"];
        } else if (infoVC.currentState == RetweetState)
            [infoVC LoadDataWithUrl:@"https://api.weibo.com/2/statuses/repost_timeline.json"];
    }];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        
        if (infoVC.currentState == CommentState) {
            [infoVC LoadMoreDataWithUrl:@"https://api.weibo.com/2/comments/show.json"];
        } else if (infoVC.currentState == RetweetState)
            [infoVC LoadMoreDataWithUrl:@"https://api.weibo.com/2/statuses/repost_timeline.json"];
    }];
    

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithImageName:@"navigationbar_back_os7" HighlightImageName:@"navigationbar_back_highlighted_os7" target:self action:@selector(backBtnClick)]];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headBtnClick:) name:@"headbtn" object:nil];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.footer.automaticallyRefresh = NO;
    [self.tableView.header beginRefreshing];
    [self setupChildView];
}

- (void)setupChildView
{
    WeiboInfoCellHeadView *headView = [[WeiboInfoCellHeadView alloc] init];
    headView.weiboModel = self.weiboInfoModel.weiboModel.retweeted_status;
    self.headView = headView;
    
    WeiboInfoToolbar *infoToolbar = [[WeiboInfoToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44)];
    [self.view addSubview:infoToolbar];
    infoToolbar.delegate = self;
}

- (void)LoadDataWithUrl:(NSString *)urlStr
{
    AFHTTPRequestOperationManager *AFNManager = [AFHTTPRequestOperationManager manager];
    //封装数据体
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"tokenInfo"] objectForKey:@"access_token"];
    dict[@"id"] = self.weiboModel.idstr;
    dict[@"count"] = @10;
    
    //判断是否加载新数据
    if (self.currentState == CommentState && self.weiboCommentModels.count != 0) {
        dict[@"since_id"] = ((WeiboInfoModel *)self.weiboCommentModels[0]).weiboCommentModel.idstr;
    }
    else if (self.currentState == RetweetState && self.weiboRetweetModels.count != 0)
        dict[@"since_id"] = ((WeiboInfoModel *)self.weiboRetweetModels[0]).weiboCommentModel.idstr;
    
    [AFNManager GET:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //字典数组转模型数组
        if (self.currentState == CommentState) {
            self.weiboOrininDates = [WeiboCommentModel objectArrayWithKeyValuesArray:responseObject[@"comments"]];
            self.weiboModel.comments_count = [responseObject[@"total_number"] intValue];
            self.weiboCommentModels = [self combineNewAndOldDataWith:self.weiboCommentModels];
            
        } else if (self.currentState == RetweetState)
        {
            self.weiboOrininDates = [WeiboCommentModel objectArrayWithKeyValuesArray:responseObject[@"reposts"]];
            self.weiboModel.reposts_count = [responseObject[@"total_number"] intValue];
            self.weiboRetweetModels = [self combineNewAndOldDataWith:self.weiboRetweetModels];
        }
        self.headView.weiboModel = self.weiboModel;
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.header endRefreshing];
    }];

}
- (NSMutableArray *)combineNewAndOldDataWith:(NSMutableArray *)models {

    NSMutableArray *InfoModelsTemp = [NSMutableArray array];
    //合成新数据
    for (WeiboCommentModel *weiboCommentModel in self.weiboOrininDates) {
        WeiboInfoModel *weiboInfoModel = [[WeiboInfoModel alloc] init];
        weiboInfoModel.weiboCommentModel = weiboCommentModel;
        [InfoModelsTemp addObject:weiboInfoModel];
    }
    [InfoModelsTemp addObjectsFromArray:models];
    return InfoModelsTemp;
}

- (void)LoadMoreDataWithUrl:(NSString *)urlstr
{
    AFHTTPRequestOperationManager *AFNManager = [AFHTTPRequestOperationManager manager];
    //封装数据体
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"tokenInfo"] objectForKey:@"access_token"];
    dict[@"id"] = self.weiboModel.idstr;
    dict[@"count"] = @10;
    
    if (self.currentState == CommentState) {
        dict[@"max_id"] = ((WeiboInfoModel *)[self.weiboCommentModels lastObject]).weiboCommentModel.idstr;
    }
    else if (self.currentState == RetweetState)
        dict[@"max_id"] = ((WeiboInfoModel *)[self.weiboRetweetModels lastObject]).weiboCommentModel.idstr;
    
    
    [AFNManager GET:urlstr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //字典数组转模型数组
        if (self.currentState == CommentState) {
            self.weiboOrininDates = [WeiboCommentModel objectArrayWithKeyValuesArray:responseObject[@"comments"]];
        } else if (self.currentState == RetweetState) {
            self.weiboOrininDates = [WeiboCommentModel objectArrayWithKeyValuesArray:responseObject[@"reposts"]];
        }
        
        
        NSMutableArray *InfoModelsTemp = [NSMutableArray array];
        for (int i = 0; i<self.weiboOrininDates.count; i++) {
            //删除第一个重复的元素
            if (i == 0) {
                continue;
            }
            WeiboInfoModel *weiboInfoModel = [[WeiboInfoModel alloc] init];
            weiboInfoModel.weiboCommentModel = self.weiboCommentModels[i];
            [InfoModelsTemp addObject:weiboInfoModel];
        }
        
        //组合数据,将新加载的评论+到数组尾部
        if (self.currentState == CommentState) {
            [self.weiboCommentModels addObjectsFromArray:InfoModelsTemp];
        } else if (self.currentState == RetweetState)
        {
            [self.weiboRetweetModels addObjectsFromArray:InfoModelsTemp];
        }
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.footer endRefreshing];
    }];

}


#pragma mark - WeiboInfoToolBarDelegate
- (void)WeiboInfoToolbar:(WeiboInfoToolbar *)toolBar WithButtonType:(WeiboInfoToolbarButtonType)buttonType
{
    switch (buttonType) {
        case WeiboInfoToolBarRetweetButton:
            [self pushRetweetVC];
            break;
        case WeiboInfoToolBarCommentButton:
            [self pushCommentVC];
            break;
        default:
            break;
    }
}
- (void)pushRetweetVC
{
    RetweetViewController *retweetVC = [[RetweetViewController alloc] init];
    retweetVC.rewteetedWeiboModel = self.weiboModel;
    retweetVC.title = self.userMidel.name;
    [self.navigationController pushViewController:retweetVC animated:YES];
}
- (void)pushCommentVC
{
    CommentViewController *commentVC = [[CommentViewController alloc] init];
    commentVC.weiboId = self.weiboModel.idstr;
    commentVC.title = self.userMidel.name;
    [self.navigationController pushViewController:commentVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return self.headView;
    }
    return nil;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
    {
        if (self.currentState == CommentState && self.weiboCommentModels.count != 0) {
            return self.weiboCommentModels.count;
        }
        else if (self.currentState == RetweetState && self.weiboRetweetModels.count != 0) {
            return self.weiboRetweetModels.count;
        }
        else
            return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 55;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return self.weiboInfoModel.cellHight;
    }
    else
    {
        WeiboInfoModel *infoModel;
        if (self.currentState == CommentState && self.weiboCommentModels.count != 0) {
            infoModel = self.weiboCommentModels[indexPath.row];
            return infoModel.cellHight;
        }
        else if (self.currentState == RetweetState && self.weiboRetweetModels.count != 0) {
            infoModel = self.weiboRetweetModels[indexPath.row];
            return infoModel.cellHight;
        }
        else
            return 100;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        WeiboInfoCellTableViewCell *cell = [WeiboInfoCellTableViewCell cellWithModel:self.weiboInfoModel tableView:tableView];
        return cell;
    }
    else
    {
        WeiboCommentCell *cell = [WeiboCommentCell cellWithtableView:tableView];
       // self.tableView.footer.stateHidden = NO;
        if (self.currentState == CommentState && self.weiboCommentModels.count != 0) {
            cell.weiboInfoModel = self.weiboCommentModels[indexPath.row];
        }
        else if (self.currentState == RetweetState && self.weiboRetweetModels.count != 0) {
            cell.weiboInfoModel = self.weiboRetweetModels[indexPath.row];
        }
        else
        {
            //self.tableView.footer.stateHidden = YES;
            NodataCell *cell = [NodataCell cellWithTableView:tableView];
            cell.currentState = self.currentState;
            return cell;
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)headBtnClick:(NSNotification *)notice
{
    if ([notice.userInfo[@"btnType"] integerValue] == RetweetButtonType) {
        self.currentState = RetweetState;
        [self.tableView reloadData];
        if (self.weiboRetweetModels.count == 0) {
            [self.tableView.header beginRefreshing];
        }
    } else if ([notice.userInfo[@"btnType"] integerValue] == CommentState)
    {
        self.currentState = CommentState;
        [self.tableView reloadData];
    } else
    {
        self.currentState = AttitudeState;
        [self.tableView.footer noticeNoMoreData];
        [self.tableView reloadData];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - getter and setter
- (void)setWeiboOrininDates:(NSArray *)weiboOrininDates {
    _weiboOriginDates = weiboOrininDates;
    if (_weiboOriginDates.count < 10) {
        [self.tableView.footer noticeNoMoreData];
    } else {
        [self.tableView.footer resetNoMoreData];
    }
}
- (NSArray *)weiboOrininDates
{
    if (_weiboOriginDates == nil) {
        _weiboOriginDates = [NSArray array];
    }
    return _weiboOriginDates;
}

- (NSMutableArray *)weiboCommentModels
{
    if (_weiboCommentModels == nil) {
        _weiboCommentModels = [NSMutableArray array];
    }
    return _weiboCommentModels;
}

- (NSMutableArray *)weiboRetweetModels
{
    if (_weiboRetweetModels == nil) {
        _weiboRetweetModels = [NSMutableArray array];
    }
    return _weiboRetweetModels;
}

- (WeiboInfoModel *)weiboInfoModel
{
    if (_weiboInfoModel == nil) {
        _weiboInfoModel = [[WeiboInfoModel alloc] init];
    }
    return _weiboInfoModel;
}

- (void)setWeiboModel:(WeiboModel *)weiboModel
{
    _weiboModel = weiboModel;
    
    self.weiboInfoModel.weiboModel = weiboModel;
}

@end
