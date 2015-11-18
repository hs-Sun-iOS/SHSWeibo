//
//  TopicCollectionView.m
//  新浪微博by孙浩胜
//
//  Created by sunhaosheng on 15/11/18.
//  Copyright © 2015年 孙浩胜. All rights reserved.
//

#import "TopicCollectionView.h"
#import "UIImage+AutoStretch.h"
@interface TopicCollectionView() <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation TopicCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCollectionView];
        [self setupDevideLine];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setupDevideLine {
    UIImageView *topline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_card_bottom_line"]];
    topline.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2/2);
    UIImageView *bottomline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_card_bottom_line"]];
    bottomline.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + self.frame.size.height/2/2);
    UIImageView *leftline = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 2, self.frame.size.width/2/1.1)];
    leftline.image = [UIImage autoStretchWithimageName:@"timeline_card_bottom_line_os7"];
    leftline.center = CGPointMake(self.frame.size.width/2/2, self.frame.size.height/2);
    leftline.transform = CGAffineTransformMakeRotation(M_PI_2);
    UIImageView *rightline = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 2, self.frame.size.width/2/1.1)];
    rightline.image = [UIImage autoStretchWithimageName:@"timeline_card_bottom_line_os7"];
    rightline.center = CGPointMake(self.frame.size.width/2 + self.frame.size.width/2/2, self.frame.size.height/2);
    rightline.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self addSubview:topline];
    [self addSubview:bottomline];
    [self addSubview:leftline];
    [self addSubview:rightline];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"topicCell"];
    [self addSubview:_collectionView];
}
#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width/2-10, collectionView.frame.size.height/2-10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"topicCell" forIndexPath:indexPath];
    UILabel *label = [[UILabel alloc] initWithFrame:cell.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"#%@#",self.topics[indexPath.row]];
    [cell.contentView addSubview:label];
    [cell sizeToFit];
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 0, 0, 0);
}



@end
