//
//  UIScrollView+FastScrollView.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-19.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "UIScrollView+FastScrollView.h"

@implementation UIScrollView (FastScrollView)

+ (instancetype)srollViewWithImageViews:(NSArray *)imageViews
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = [[UIScreen mainScreen] bounds];
    scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width * imageViews.count, scrollView.bounds.size.height);
    for (id imageView in imageViews) {
        [scrollView addSubview:imageView];
    }
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    return scrollView;
}

@end
