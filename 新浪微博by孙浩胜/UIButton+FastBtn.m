//
//  UIButton+FastBtn.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-18.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "UIButton+FastBtn.h"
#import "UIImage+AutoStretch.h"
@implementation UIButton (FastBtn)

+ (UIButton *)buttonWithImageName:(NSString *)imageName HighlightImageName:(NSString *)highlightImageName target:(id)target action:(SEL)selector
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (imageName||highlightImageName) {
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    };
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, btn.currentImage.size.width, btn.currentImage.size.height);
    return btn;
}

+ (UIButton *)buttonWithImageName:(NSString *)imageName SelectedImageName:(NSString *)selectedName target:(id)target action:(SEL)selector
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (imageName||selectedName) {
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selectedName] forState:UIControlStateSelected];
    };
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, btn.currentImage.size.width, btn.currentImage.size.height);
    return btn;
}

+ (UIButton *)buttonWithTitle:(NSString *)title NormalTitleColor:(UIColor *)NormalColor HighlightTitleColor:(UIColor *)highlightColor target:(id)target action:(SEL)selector isEnable:(BOOL)isEnable
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:NormalColor forState:UIControlStateNormal];
    [btn setTitleColor:highlightColor forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    btn.frame = CGRectMake(0, 0, 70, 30);
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    btn.enabled = isEnable;
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    return btn;
}

+ (UIButton *)buttonWithTitle:(NSString *)title BackgroundImageName:(NSString *)BackgroundImageName target:(id)target action:(SEL)selector
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage autoStretchWithimageName:BackgroundImageName] forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, btn.currentImage.size.width, btn.currentImage.size.height);
    return btn;
}

+ (UIButton *)buttonWithTitle:(NSString *)title NormalTitleColor:(UIColor *)NormalColor SelectedTitleColor:(UIColor *)selectedColor target:(id)target action:(SEL)selector
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:NormalColor forState:UIControlStateNormal];
    [btn setTitleColor:selectedColor forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchDown];
    return btn;
}
@end
