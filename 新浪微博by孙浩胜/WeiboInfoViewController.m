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


@interface WeiboInfoViewController () <WeiboInfoToolBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *weiboCommentModels;

@property (nonatomic,strong) NSMutableArray *weiboInfoModels;

@property (nonatomic,strong) WeiboInfoModel *weiboInfoModel;

@property (nonatomic,strong) WeiboInfoCellHeadView *headView;

@end

@implementation WeiboInfoViewController

- (NSArray *)weiboCommentModels
{
    if (_weiboCommentModels == nil) {
        _weiboCommentModels = [NSArray array];
    }
    return _weiboCommentModels;
}

- (NSMutableArray *)weiboInfoModels
{
    if (_weiboInfoModels == nil) {
        _weiboInfoModels = [NSMutableArray array];
    }
    return _weiboInfoModels;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"微博正文";

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:226.0/255 green:226.0/255 blue:226.0/255 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(LoadData)];
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(LoadMore)];
    [self.tableView.header beginRefreshing];
    
    
    [self setupChildView];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void) setupChildView
{
    WeiboInfoCellHeadView *headView = [[WeiboInfoCellHeadView alloc] init];
    headView.weiboModel = self.weiboInfoModel.weiboModel;
    self.headView = headView;
    
    WeiboInfoToolbar *infoToolbar = [[WeiboInfoToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44)];
    [self.view addSubview:infoToolbar];
    infoToolbar.delegate = self;
}

- (void)LoadData
{
    AFHTTPRequestOperationManager *AFNManager = [AFHTTPRequestOperationManager manager];
    //封装数据体
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"tokenInfo"] objectForKey:@"access_token"];
    dict[@"id"] = self.weiboModel.idstr;
    dict[@"count"] = @10;
    
    //判断是否加载新数据
    if ((self.weiboCommentModels.count)) {
        dict[@"since_id"] = ((WeiboCommentModel *)self.weiboCommentModels[0]).idstr;
    }
    
    [AFNManager GET:@"https://api.weibo.com/2/comments/show.json" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //字典数组转模型数组
        self.weiboCommentModels = [WeiboCommentModel objectArrayWithKeyValuesArray:responseObject[@"comments"]];
        
        NSMutableArray *InfoModelsTemp = [NSMutableArray array];
        for (WeiboCommentModel *weiboCommentModel in self.weiboCommentModels) {
            WeiboInfoModel *weiboInfoModel = [[WeiboInfoModel alloc] init];
            weiboInfoModel.weiboCommentModel = weiboCommentModel;
            [InfoModelsTemp addObject:weiboInfoModel];
        }
        
        //合成新旧 数据
        NSMutableArray *tempArr = [NSMutableArray array];
        [tempArr addObjectsFromArray:InfoModelsTemp];
        [tempArr addObjectsFromArray:self.weiboInfoModels];
        self.weiboInfoModels = tempArr;
        
        if (self.weiboInfoModels.count < 10) {
            [self.tableView.footer noticeNoMoreData];
        }
        
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.header endRefreshing];
    }];

}

- (void)LoadMore
{
    AFHTTPRequestOperationManager *AFNManager = [AFHTTPRequestOperationManager manager];
    //封装数据体
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"tokenInfo"] objectForKey:@"access_token"];
    dict[@"id"] = self.weiboModel.idstr;
    dict[@"count"] = @10;
    
    //判断是否加载新数据
    dict[@"max_id"] = ((WeiboCommentModel *)[self.weiboCommentModels lastObject]).idstr;
    
    [AFNManager GET:@"https://api.weibo.com/2/comments/show.json" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //字典数组转模型数组
        self.weiboCommentModels = [WeiboCommentModel objectArrayWithKeyValuesArray:responseObject[@"comments"]];
        
        NSMutableArray *InfoModelsTemp = [NSMutableArray array];
        for (int i = 0; i<self.weiboCommentModels.count; i++) {
            //删除第一个重复的元素
            if (i == 0) {
                continue;
            }
            WeiboInfoModel *weiboInfoModel = [[WeiboInfoModel alloc] init];
            weiboInfoModel.weiboCommentModel = self.weiboCommentModels[i];
            [InfoModelsTemp addObject:weiboInfoModel];
        }
        if (InfoModelsTemp.count == 0) {
            [self.tableView.footer endRefreshing];
            [self.tableView.footer noticeNoMoreData];
        } else
            [self.tableView.footer resetNoMoreData];
        
        //组合数据,将新加载的评论+到数组尾部
        [self.weiboInfoModels addObjectsFromArray:InfoModelsTemp];
        [self.tableView.footer endRefreshing];
        
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
    } else if (self.weiboInfoModels.count == 0) {
        return 1;
    } else
        return self.weiboInfoModels.count;
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
    } else
    {
        if (self.weiboInfoModels.count != 0)
        {
            WeiboInfoModel *model = self.weiboInfoModels[indexPath.row];
            return model.cellHight;
        } else
            return 100;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        WeiboInfoCellTableViewCell *cell = [WeiboInfoCellTableViewCell cellWithModel:self.weiboInfoModel tableView:tableView];
        return cell;
    }
    else {
        if (self.weiboInfoModels.count != 0) {
            WeiboCommentCell *cell = [WeiboCommentCell cellWithtableView:tableView];
            cell.weiboInfoModel = self.weiboInfoModels[indexPath.row];
            return cell;
        } else {
            NodataCell *cell = [NodataCell cellWithTableView:tableView];
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
