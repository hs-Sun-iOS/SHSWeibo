//
//  NewFeatureView.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-19.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "NewFeatureView.h"
#import "UIScrollView+FastScrollView.h"
#import "UIButton+FastBtn.h"
#import "ViewController.h"

@interface NewFeatureView ()

@property (nonatomic,weak) UIPageControl *pageControl;

@end
@implementation NewFeatureView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIScrollView *scrollView = [UIScrollView srollViewWithImageViews:[self addImageViews]];
        [self addSubview:scrollView];
        scrollView.delegate = self;
        [self addPageControl];
    }
    return self;
}


- (void)addPageControl
{
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = 3;
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    pageControl.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height-50);
    _pageControl = pageControl;
    [self addSubview:pageControl];
    
}

- (NSArray *)addImageViews
{
    NSMutableArray *arr = [NSMutableArray array];
    for(int i = 0; i < 3; i++)
    {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height)];
        iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"new_feature_%d",i+1]];
        iv.center = CGPointMake(self.bounds.size.width/2 + i*self.bounds.size.width, self.bounds.size.height/2);
        if (i == 2) {
            
            UIButton *enterBtn = [UIButton buttonWithImageName:@"new_feature_button" HighlightImageName:@"new_feature_button_highlighted" target:self action:@selector(enterWeibo)];
            enterBtn.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2+50);
            
            [iv addSubview:enterBtn];
            
            UIButton *shareBtn = [UIButton buttonWithImageName:@"new_feature_share_true-1" SelectedImageName:@"new_feature_share_false-1" target:self action:@selector(shareBtnClick:)];
            shareBtn.center = CGPointMake(enterBtn.center.x - 65, enterBtn.center.y - 50);
            
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 80)];
            label.text = @"发微博告诉朋友";
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor blackColor];
            label.center = CGPointMake(shareBtn.center.x + 90, shareBtn.center.y);
            
            [iv addSubview:label];
            [iv addSubview:shareBtn];
            iv.userInteractionEnabled = YES;
            
            
        }
        [arr addObject:iv];
    }
    return arr;
}

- (void)shareBtnClick:(UIButton *)btn
{
    if (btn.selected) {
        btn.selected = NO;
    } else
        btn.selected = YES;
}

- (void)enterWeibo
{
    self.window.rootViewController = [[ViewController alloc] init];
}

#pragma mark -- UIscrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentIndex = (int)(scrollView.contentOffset.x/scrollView.bounds.size.width + 0.5);
    _pageControl.currentPage = currentIndex;
    
}

@end
