//
//  TitleButton.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-18.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "TitleButton.h"
#import "UIImage+AutoStretch.h"
#define IMAGE_WIDTH 20

@implementation TitleButton


+ (instancetype)TitleButton
{
    return [[TitleButton alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.adjustsImageWhenHighlighted = NO;
        [self setBackgroundImage:[UIImage autoStretchWithimageName:@"navigationbar_filter_background_highlighted_os7"] forState:UIControlStateHighlighted];
        
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
    }
    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    CGFloat Y = 0;
    CGFloat W = IMAGE_WIDTH;
    CGFloat X = contentRect.size.width - W;
    CGFloat H = contentRect.size.height;
    
    return CGRectMake(X, Y, W, H);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat Y = 0;
    CGFloat W = contentRect.size.width - IMAGE_WIDTH;
    CGFloat X = 0;
    CGFloat H = contentRect.size.height;
    
    return CGRectMake(X, Y, W, H);
    
}


- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    CGFloat X = 0;
    CGFloat Y = 0;
    CGSize Size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size;
    self.frame = CGRectMake(X, Y, Size.width + IMAGE_WIDTH, Size.height + 10);
}
@end
