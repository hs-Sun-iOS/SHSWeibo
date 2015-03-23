//
//  UIButton+FastBtn.h
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-18.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (FastBtn)


+ (UIButton *)buttonWithImageName:(NSString *)imageName HighlightImageName:(NSString *)highlightImageName target:(id)target action:(SEL)selector;


+ (UIButton *)buttonWithTitle:(NSString *)title NormalTitleColor:(UIColor *)NormalColor HighlightTitleColor:(UIColor *)highlightColor target:(id)target action:(SEL)selector isEnable:(BOOL)isEnable;


+ (UIButton *)buttonWithImageName:(NSString *)imageName SelectedImageName:(NSString *)selectedName target:(id)target action:(SEL)selector;

+ (UIButton *)buttonWithTitle:(NSString *)title BackgroundImageName:(NSString *)BackgroundImageName target:(id)target action:(SEL)selector;
@end
