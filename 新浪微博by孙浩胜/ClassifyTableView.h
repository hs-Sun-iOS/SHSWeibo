//
//  ClassifyTableView.h
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-19.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleButton.h"

@class ClassifyTableView;
@protocol ClassifyTableViewDelegate <NSObject>

- (void)ClassifyTableView:(ClassifyTableView *)ctv selectedItem:(NSString *)itemName;

@end
@interface ClassifyTableView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) TitleButton *titleBtn;
@property (nonatomic,weak) id<ClassifyTableViewDelegate>delegate;

@end
