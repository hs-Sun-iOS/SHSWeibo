//
//  CellRetweetView.h
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-22.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeViewController;
typedef void (^pushVCBlock)(HomeViewController *);

@class CellModel;
@interface CellRetweetView : UIImageView

@property (nonatomic,strong) CellModel *cellModel;

@property (nonatomic,assign) pushVCBlock pushOriginalWeiboInfo;


@end
