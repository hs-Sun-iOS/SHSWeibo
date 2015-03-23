//
//  CellToolBar.h
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-22.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CellModel;
@interface CellToolBar : UIImageView

/**转发按钮*/
@property (nonatomic,weak) UIButton *retweetBtn;
/**评论按钮*/
@property (nonatomic,weak) UIButton *commentBtn;
/**点赞按钮*/
@property (nonatomic,weak) UIButton *attitudeBtn;

@property (nonatomic,strong) CellModel *cellModel;

@end
