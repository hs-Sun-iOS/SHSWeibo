//
//  PhotosView.h
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/22.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosView : UIView

@property (nonatomic,strong) NSArray *photos;


+ (CGSize)photosViewSizeWithPhotoCounts:(NSInteger)count;
@end
