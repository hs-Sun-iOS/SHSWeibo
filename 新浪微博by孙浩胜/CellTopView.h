//
//  CellTopView.h
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-22.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CellModel;
@class CellRetweetView;
@interface CellTopView : UIImageView

@property (nonatomic,strong) CellModel *cellModel;

@property (nonatomic,weak) CellRetweetView *retweetView;

@end
