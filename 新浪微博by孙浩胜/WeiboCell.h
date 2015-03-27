//
//  WeiboCell.h
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-21.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CellModel;
@class CellToolBar;
@class CellTopView;

@interface WeiboCell : UITableViewCell

/**上部分背景view*/
@property (nonatomic,weak) CellTopView *cellTopView ;
/**下部分背景view*/
@property (nonatomic,weak) CellToolBar *bottomView;
/**cell模型*/
@property (nonatomic,strong) CellModel *cellModel;




+ (instancetype)cellWithTableView:(UITableView *)tableView;

//- (instancetype)initWithTableView:(UITableView *)tableView;
@end
