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
@property (nonatomic,strong) NSArray *weiboCommentModels;
/**评论数据(frame)*/
@property (nonatomic,strong) NSMutableArray *weiboInfoModels;
/**转发数据(frame)*/
@property (nonatomic,strong) NSMutableArray *weiboRetweetModels;

@property (nonatomic,strong) WeiboInfoModel *weiboInfoModel;

@property (nonatomic,strong) WeiboInfoCellHeadView *headView;

@property (nonatomic,assign) NSUInteger currentState;

@property (nonatomic,assign) BOOL IsMoreComment;

@property (nonatomic,assign) BOOL IsMoreRetweet;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    //属性初始化
    self.title = @"微博正文";
    _currentState = CommentState;
    _IsMoreComment = YES;
    _IsMoreRetweet = YES;

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
    
    self.tableView.footer.automaticallyRefresh = NO;
    [self.tableView.header beginRefreshing];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithImageName:@"navigationbar_back_os7" HighlightImageName:@"navigationbar_back_highlighted_os7" target:self action:@selector(backBtnClick)]];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headBtnClick:) name:@"headbtn" object:nil];
    
    
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

- (void)LoadDataWithUrl:(NSString *)urlStr
{
    AFHTTPRequestOperationManager *AFNManager = [AFHTTPRequestOperationManager manager];
    //封装数据体
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"tokenInfo"] objectForKey:@"access_token"];
    dict[@"id"] = self.weiboModel.idstr;
    dict[@"count"] = @10;
    
    //判断是否加载新数据
    if (self.currentState == CommentState && self.weiboInfoModels.count != 0) {
        dict[@"since_id"] = ((WeiboInfoModel *)self.weiboInfoModels[0]).weiboCommentModel.idstr;
    }
    else if (self.currentState == RetweetState && self.weiboRetweetModels.count != 0)
        dict[@"since_id"] = ((WeiboInfoModel *)self.weiboRetweetModels[0]).weiboCommentModel.idstr;
    
    [AFNManager GET:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //字典数组转模型数组
        if (self.currentState == CommentState) {
            self.weiboCommentModels = [WeiboCommentModel objectArrayWithKeyValuesArray:responseObject[@"comments"]];
            self.weiboModel.comments_count = [responseObject[@"total_number"] intValue];
        } else if (self.currentState == RetweetState)
        {
            self.weiboCommentModels = [WeiboCommentModel objectArrayWithKeyValuesArray:responseObject[@"reposts"]];
            self.weiboModel.reposts_count = [responseObject[@"total_number"] intValue];
        }
        self.headView.weiboModel = self.weiboModel;
        
        
        NSMutableArray *InfoModelsTemp = [NSMutableArray array];
        for (WeiboCommentModel *weiboCommentModel in self.weiboCommentModels) {
            WeiboInfoModel *weiboInfoModel = [[WeiboInfoModel alloc] init];
            weiboInfoModel.weiboCommentModel = weiboCommentModel;
            [InfoModelsTemp addObject:weiboInfoModel];
        }
        
        //合成新数据
        NSMutableArray *tempArr = [NSMutableArray array];
        [tempArr addObjectsFromArray:InfoModelsTemp];
        
        
        if (self.currentState == CommentState) {
            //合成旧数据
            [tempArr addObjectsFromArray:self.weiboInfoModels];
            //将合成后的数组赋值给属性
            self.weiboInfoModels = tempArr;
            [self.tableView.header endRefreshing];
            if (self.weiboCommentModels.count < 10) {
                _IsMoreComment = NO;
                [self.tableView.footer noticeNoMoreData];
            }
        } else if (self.currentState == RetweetState)
        {
            [tempArr addObjectsFromArray:self.weiboRetweetModels];
            self.weiboRetweetModels = tempArr;
            [self.tableView.header endRefreshing];
            if (self.weiboCommentModels.count < 10) {
                _IsMoreRetweet = NO;
                [self.tableView.footer noticeNoMoreData];
            }
        }
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self.tableView.header endRefreshing];
    }];

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
        dict[@"max_id"] = ((WeiboInfoModel *)[self.weiboInfoModels lastObject]).weiboCommentModel.idstr;
    }
    else if (self.currentState == RetweetState)
        dict[@"max_id"] = ((WeiboInfoModel *)[self.weiboRetweetModels lastObject]).weiboCommentModel.idstr;
    
    
    [AFNManager GET:urlstr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //字典数组转模型数组
        if (self.currentState == CommentState) {
            self.weiboCommentModels = [WeiboCommentModel objectArrayWithKeyValuesArray:responseObject[@"comments"]];
        } else if (self.currentState == RetweetState)
            self.weiboCommentModels = [WeiboCommentModel objectArrayWithKeyValuesArray:responseObject[@"reposts"]];
        
        
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
            [self.tableView.footer endRefreshing];
        
        //组合数据,将新加载的评论+到数组尾部
        if (self.currentState == CommentState) {
            [self.weiboInfoModels addObjectsFromArray:InfoModelsTemp];
            _IsMoreComment = InfoModelsTemp.count == 0 ? NO : YES;
        } else if (self.currentState == RetweetState && InfoModelsTemp.count != 0)
        {
            [self.weiboRetweetModels addObjectsFromArray:InfoModelsTemp];
            _IsMoreRetweet = InfoModelsTemp.count == 0 ? NO : YES;
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
        if (self.currentState == CommentState && self.weiboInfoModels.count != 0) {
            return self.weiboInfoModels.count;
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
        if (self.currentState == CommentState && self.weiboInfoModels.count != 0) {
            infoModel = self.weiboInfoModels[indexPath.row];
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
//        if (self.tableView.footer.noMoreLabel.hidden) {
//            self.tableView.footer.noMoreLabel.hidden = NO;
//        }
        WeiboCommentCell *cell = [WeiboCommentCell cellWithtableView:tableView];
        if (self.currentState == CommentState && self.weiboInfoModels.count != 0) {
            cell.weiboInfoModel = self.weiboInfoModels[indexPath.row];
        }
        else if (self.currentState == RetweetState && self.weiboRetweetModels.count != 0) {
            cell.weiboInfoModel = self.weiboRetweetModels[indexPath.row];
        }
        else
        {
            //self.tableView.footer.noMoreLabel.hidden = YES;
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
        if (self.weiboRetweetModels.count == 0) {
            [self LoadDataWithUrl:@"https://api.weibo.com/2/statuses/repost_timeline.json"];
        }
        if (_IsMoreRetweet) {
            [self.tableView.footer resetNoMoreData];
        } else
            [self.tableView.footer noticeNoMoreData];
        [self.tableView reloadData];
    } else if ([notice.userInfo[@"btnType"] integerValue] == CommentState)
    {
        self.currentState = CommentState;
        if (_IsMoreComment) {
            [self.tableView.footer resetNoMoreData];
        } else
            [self.tableView.footer noticeNoMoreData];
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

@end
