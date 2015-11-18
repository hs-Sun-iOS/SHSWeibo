//
//  DiscoveryRowsModel.h
//  新浪微博by孙浩胜
//
//  Created by sunhaosheng on 15/11/18.
//  Copyright © 2015年 孙浩胜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DiscoveryItemsModel : NSObject

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,assign) CGSize itemSize;

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) NSArray *items;

@end
