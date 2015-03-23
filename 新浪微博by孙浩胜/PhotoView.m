//
//  PhotoView.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/22.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "PhotoView.h"
#import "PhotoModel.h"
#import "UIImageView+WebCache.h"

@interface PhotoView ()

@property (nonatomic,weak) UIImageView *gifView;

@end

@implementation PhotoView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        UIImageView *gifView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_image_gif"]];
        [self addSubview:gifView];
        self.gifView = gifView;
    }
    return self;
}

- (void)setPhotoModel:(PhotoModel *)photoModel
{
    _photoModel = photoModel;
    
    self.gifView.hidden = ![photoModel.thumbnail_pic hasSuffix:@".gif"];
    [self setImageWithURL:[NSURL URLWithString:photoModel.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gifView.layer.anchorPoint = CGPointMake(1, 1);
    self.gifView.layer.position = CGPointMake(self.frame.size.width, self.frame.size.height);
}

@end
