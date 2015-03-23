//
//  PhotosView.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/22.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "PhotosView.h"
#import "PhotoView.h"
#import "PhotoModel.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#define PhotoW 70
#define PhotoH 70
#define PhotoMargin 10


@implementation PhotosView



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        //初始化9个子photoVIew
        for (int i = 0; i<9; i++) {
            PhotoView *photoView = [[PhotoView alloc] init];
            photoView.userInteractionEnabled = YES;
            photoView.tag = i;
            [photoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)]];
            [self addSubview:photoView];
        }
        
    }
    return self;
}


- (void)tapEvent:(UITapGestureRecognizer *)tapGR
{
    
    //图片数组
    NSMutableArray *photosM = [NSMutableArray arrayWithCapacity:self.photos.count];
    
    for (int i = 0; i<self.photos.count; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.srcImageView = self.subviews[i];
        PhotoModel *photoModel = self.photos[i];
        photo.url = [NSURL URLWithString:[photoModel.thumbnail_pic stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"]];
        [photosM addObject:photo];
    }
    //图片浏览器
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tapGR.view.tag;
    browser.photos = photosM;
    [browser show];
    
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    

    for (int i = 0; i<self.subviews.count; i++) {
        // 取出i位置对应的imageView
        PhotoView *photoView = self.subviews[i];
        
        // 判断这个imageView是否需要显示数据
        if (i < photos.count) {
            // 显示图片
            photoView.hidden = NO;
            
            // 传递模型数据
            photoView.photoModel = photos[i];
            
            // 设置子控件的frame
            int maxColumns = (photos.count == 4) ? 2 : 3;
            int col = i % maxColumns;
            int row = i / maxColumns;
            CGFloat photoX = col * (PhotoW + PhotoMargin);
            CGFloat photoY = row * (PhotoH + PhotoMargin);
            photoView.frame = CGRectMake(photoX, photoY, PhotoW, PhotoH);
            
            // Aspect : 按照图片的原来宽高比进行缩
            // UIViewContentModeScaleAspectFit : 按照图片的原来宽高比进行缩放(一定要看到整张图片)
            // UIViewContentModeScaleAspectFill :  按照图片的原来宽高比进行缩放(只能图片最中间的内容)
            // UIViewContentModeScaleToFill : 直接拉伸图片至填充整个imageView
            
            if (photos.count == 1) {
                photoView.contentMode = UIViewContentModeScaleAspectFit;
                photoView.clipsToBounds = NO;
            } else {
                photoView.contentMode = UIViewContentModeScaleAspectFill;
                photoView.clipsToBounds = YES;
            }
        } else { // 隐藏imageView
            photoView.hidden = YES;
        }
    }

}

+ (CGSize)photosViewSizeWithPhotoCounts:(int)count
{
    // 一行最多有3列
    int maxColumns = (count == 4) ? 2 : 3;
    
    //  总行数
    int rows = (count + maxColumns - 1) / maxColumns;
    // 高度
    CGFloat photosH = rows * PhotoH + (rows - 1) * PhotoMargin;
    
    // 总列数
    int cols = (count >= maxColumns) ? maxColumns : count;
    // 宽度
    CGFloat photosW = cols * PhotoW + (cols - 1) * PhotoMargin;
    
    return CGSizeMake(photosW, photosH);
}

@end
