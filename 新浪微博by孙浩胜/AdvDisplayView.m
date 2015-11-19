//
//  AdvDisplayView.m
//  新浪微博by孙浩胜
//
//  Created by sunhaosheng on 15/11/19.
//  Copyright © 2015年 孙浩胜. All rights reserved.
//

#import "AdvDisplayView.h"
#import "AdvCollectionCell.h"

@interface AdvDisplayView () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,weak) UICollectionView *collectionView;

@property (nonatomic,weak) UIPageControl *pageControl;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,strong) NSMutableArray *tempImageUrls;

@end

@implementation AdvDisplayView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentIndex = 0;
    }
    return self;
}
#pragma mark - public method
- (void)beginAutoScrolling {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerFunc) userInfo:nil repeats:YES];
}

- (void)stopAutoScrolling {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - UICollectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tempImageUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AdvCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"advcell" forIndexPath:indexPath];
    [cell.imageView setImageWithURL:self.tempImageUrls[indexPath.item] placeholderImage:[UIImage imageNamed:@"message_placeholder_picture"]];
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopAutoScrolling];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateImages];
    [self beginAutoScrolling];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self updateImages];
}

- (void)updateImages {
    NSInteger currentItem = self.collectionView.contentOffset.x / self.collectionView.width;
    if (currentItem == 0) {
        self.currentIndex = self.currentIndex == 0 ? self.imageUrls.count-1:self.currentIndex - 1;
    } else if (currentItem == 2) {
        self.currentIndex = self.currentIndex == self.imageUrls.count-1 ? 0:self.currentIndex + 1;
    }
    [self.collectionView reloadData];
    //    [scrollView setContentOffset:CGPointMake(scrollView.width, 0) animated:NO];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    self.pageControl.currentPage = self.currentIndex;
}

#pragma mark - getter/setter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.width, self.height);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:layout];
        [collectionView registerNib:[UINib nibWithNibName:@"AdvCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"advcell"];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        [self addSubview:collectionView];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        pageControl.numberOfPages = self.imageUrls.count;
        pageControl.currentPage = 0;
        pageControl.center = CGPointMake(self.width/2, self.height - 10);
        [self addSubview:pageControl];
        _pageControl = pageControl;
    }
    return _pageControl;
}
- (void)setImageUrls:(NSArray *)imageUrls {
    _imageUrls = imageUrls;
    self.collectionView.backgroundColor = [UIColor clearColor];
    if (_imageUrls.count != 1 && _imageUrls.count != 0) {
        self.tempImageUrls = [NSMutableArray arrayWithObjects:[_imageUrls lastObject],_imageUrls[0],_imageUrls[1] ,nil];
    } else {
        self.tempImageUrls = [NSMutableArray arrayWithObjects:_imageUrls[0],nil];
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    self.tempImageUrls[0] = self.imageUrls[currentIndex == 0 ? self.imageUrls.count-1:currentIndex - 1];
    self.tempImageUrls[1] = self.imageUrls[currentIndex];
    self.tempImageUrls[2] = self.imageUrls[currentIndex == self.imageUrls.count-1 ? 0:currentIndex + 1];
}

#pragma mark - private method

- (void)didMoveToSuperview {
    [self beginAutoScrolling];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (void)timerFunc {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}


@end
