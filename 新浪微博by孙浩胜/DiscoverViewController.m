//
//  DiscoverViewController.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-17.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "DiscoverViewController.h"
#import "SearchResultViewController.h"
#import "DiscoveryTableViewCell.h"
#import "DiscoveryGroupsModel.h"
#import "DiscoveryItemsModel.h"
#import "TopicCollectionView.h"
#import "AdvDisplayView.h"

@interface DiscoverViewController ()<UISearchControllerDelegate,UISearchBarDelegate>
@property (nonatomic,strong) UISearchController *searchController;

@property (nonatomic,strong) SearchResultViewController *searchResultVC;

@property (nonatomic,strong) NSMutableArray *groups;
@end

@implementation DiscoverViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSearchController];
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscoveryTableViewCell" bundle:nil] forCellReuseIdentifier:@"discoveryTableViewCell"];
    
}

- (void)setupSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self.searchResultVC;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.placeholder = @"搜索热门话题";
    self.navigationItem.titleView = self.searchController.searchBar;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.groups[section] items].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscoveryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"discoveryTableViewCell" forIndexPath:indexPath];
    DiscoveryGroupsModel *group = self.groups[indexPath.section];
    DiscoveryItemsModel *item = group.items[indexPath.row];
    [cell configureCellWithItem:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscoveryGroupsModel *group = self.groups[indexPath.section];
    DiscoveryItemsModel *item = group.items[indexPath.row];
    return item.itemSize.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }
    return 2;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.view addSubview:self.searchResultVC.view];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.searchResultVC.view removeFromSuperview];
}
#pragma mark - getter and setter
- (SearchResultViewController *)searchResultVC {
    if (!_searchResultVC) {
        _searchResultVC = [[SearchResultViewController alloc] init];
        _searchResultVC.view.x = 0;
        _searchResultVC.view.y = 0;
    }
    return _searchResultVC;
}

- (NSMutableArray *)groups {
    if (!_groups) {
        DiscoveryGroupsModel *group0 = ({
        DiscoveryGroupsModel *group = [[DiscoveryGroupsModel alloc] init];
        DiscoveryItemsModel *item = [[DiscoveryItemsModel alloc] init];
        item.itemSize = CGSizeMake(self.view.frame.size.width, 150);
        item.contentView = ({
            AdvDisplayView *advDisplayView = [[AdvDisplayView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,150)];
            advDisplayView.imageUrls = @[@"http://pic.nipic.com/2007-11-09/2007119122519868_2.jpg",@"http://pic2.ooopic.com/01/03/51/25b1OOOPIC19.jpg",@"http://pic14.nipic.com/20110522/7411759_164157418126_2.jpg",@"http://img2.3lian.com/img2007/19/33/005.jpg"];
            advDisplayView;
        });
        group.items = @[item];
        group;
        });
        
        DiscoveryGroupsModel *group1 = ({
            DiscoveryGroupsModel *group = [[DiscoveryGroupsModel alloc] init];
            DiscoveryItemsModel *item = [[DiscoveryItemsModel alloc] init];
            item.itemSize = CGSizeMake(self.view.frame.size.width, 100);
            item.contentView = ({
                TopicCollectionView *view = [[TopicCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
                view.topics = @[@"二胎开放",@"巴黎遭恐怖袭击",@"琅琊榜",@"热门话题"];
                view;
            });
            group.items = @[item];
            group;
        });
        
        DiscoveryGroupsModel *group2 = ({
            DiscoveryGroupsModel *group = [[DiscoveryGroupsModel alloc] init];
            
            DiscoveryItemsModel *item1 = [[DiscoveryItemsModel alloc] init];
            item1.itemSize = CGSizeMake(self.view.frame.size.width, 44);
            item1.title = @"热门微博";
            item1.image = [UIImage imageNamed:@"hot_status"];
            
            DiscoveryItemsModel *item2 = [[DiscoveryItemsModel alloc] init];
            item2.itemSize = CGSizeMake(self.view.frame.size.width, 44);
            item2.title = @"找人";
            item2.image = [UIImage imageNamed:@"find_people"];
            
            group.items = @[item1,item2];
            group;
        });
        
        DiscoveryGroupsModel *group3 = ({
            DiscoveryGroupsModel *group = [[DiscoveryGroupsModel alloc] init];
            
            DiscoveryItemsModel *item1 = [[DiscoveryItemsModel alloc] init];
            item1.itemSize = CGSizeMake(self.view.frame.size.width, 44);
            item1.title = @"音乐";
            item1.image = [UIImage imageNamed:@"music"];
            
            DiscoveryItemsModel *item2 = [[DiscoveryItemsModel alloc] init];
            item2.itemSize = CGSizeMake(self.view.frame.size.width, 44);
            item2.title = @"电影";
            item2.image = [UIImage imageNamed:@"movie"];
            
            DiscoveryItemsModel *item3 = [[DiscoveryItemsModel alloc] init];
            item3.itemSize = CGSizeMake(self.view.frame.size.width, 44);
            item3.title = @"周边";
            item3.image = [UIImage imageNamed:@"near"];
            
            DiscoveryItemsModel *item4 = [[DiscoveryItemsModel alloc] init];
            item4.itemSize = CGSizeMake(self.view.frame.size.width, 44);
            item4.title = @"更多频道";
            item4.image = [UIImage imageNamed:@"more"];
            
            group.items = @[item1,item2,item3,item4];
            group;
        });
        _groups = [NSMutableArray arrayWithObjects:group0,group1,group2,group3, nil];
    }
    return _groups;
}


@end
