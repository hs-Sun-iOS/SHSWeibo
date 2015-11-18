//
//  DiscoveryTableViewCell.h
//  新浪微博by孙浩胜
//
//  Created by sunhaosheng on 15/11/18.
//  Copyright © 2015年 孙浩胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoveryItemsModel.h"
@interface DiscoveryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *BgView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)configureCellWithItem:(DiscoveryItemsModel *)item;

@end
