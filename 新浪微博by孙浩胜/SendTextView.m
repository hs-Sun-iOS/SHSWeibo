//
//  SendTextView.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-19.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "SendTextView.h"

@interface SendTextView ()
@property (nonatomic,weak) UILabel *placeHolder;
@end

@implementation SendTextView

+ (instancetype)SendTextView
{
    return [[SendTextView alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        self.delegate = self;
        [self addPlaceHolder];
        
    }
    return self;
}

- (void) addPlaceHolder;
{
    UILabel *placeholder = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, 100, 60)];
    placeholder.backgroundColor = [UIColor clearColor];
    placeholder.text = @"分享新鲜事...";
    placeholder.font = [UIFont systemFontOfSize:14.0];
    placeholder.textColor = [UIColor blackColor];
    [self addSubview:placeholder];
    self.placeHolder = placeholder;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"invaildInput" object:textView];
        self.placeHolder.hidden = NO;
    }
    else if(textView.text.length == 1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"vaildInput" object:textView];
        self.placeHolder.hidden = YES;
    }
}

@end
