//
//  CommentTextView.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/26.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "CommentTextView.h"

@interface CommentTextView ()<UITextViewDelegate>

@property (nonatomic,weak) UILabel *placeHolder;
@end

@implementation CommentTextView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        self.delegate = self;
        [self addPlaceHolder];
        self.font = [UIFont systemFontOfSize:15.0];
    }
    return self;
}

- (void) addPlaceHolder;
{
    UILabel *placeholder = [[UILabel alloc] init];
    placeholder.backgroundColor = [UIColor clearColor];
    placeholder.text = @"写评论...";
    placeholder.font = [UIFont systemFontOfSize:15.0];
    CGSize size = [placeholder.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:placeholder.font} context:nil].size;
    placeholder.frame = CGRectMake(10, 6, size.width, size.height);
    placeholder.textColor = [UIColor lightGrayColor];
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
