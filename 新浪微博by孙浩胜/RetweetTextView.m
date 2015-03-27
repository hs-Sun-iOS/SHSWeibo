//
//  RetweetTextView.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/25.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "RetweetTextView.h"
#import "WeiboModel.h"
#import "UserModel.h"
#import "WeiboItemView.h"

@interface RetweetTextView ()
@property (nonatomic,weak) UILabel *placeHolder;

@property (nonatomic,strong) WeiboModel *weiboModel;
@end

@implementation RetweetTextView

- (instancetype)initWithWeiboModel:(WeiboModel *)weiboModel
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        self.delegate = self;
        [self addPlaceHolder];
        self.weiboModel = weiboModel;
        self.font = [UIFont systemFontOfSize:15.0];
        self.selectedRange = NSMakeRange(0, 0);
        
        WeiboItemView *weiboItemView = [[WeiboItemView alloc] init];
        weiboItemView.frame = CGRectMake(10, 110, self.bounds.size.width - 20, 50);
        weiboItemView.weiboModel = weiboModel;
        [self addSubview:weiboItemView];
        
    }
    return self;
}

- (void)setWeiboModel:(WeiboModel *)weiboModel
{
    _weiboModel = weiboModel;
    
    if (weiboModel.retweeted_status) {
        self.text = [NSString stringWithFormat:@"//@%@:%@",weiboModel.user.name,weiboModel.text];
    } else
        self.placeHolder.hidden = NO;
    
    
}

- (void) addPlaceHolder
{
    UILabel *placeholder = [[UILabel alloc] init];
    placeholder.backgroundColor = [UIColor clearColor];
    placeholder.text = @"说说分享心得...";
    placeholder.font = [UIFont systemFontOfSize:15.0];
    CGSize size = [placeholder.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:placeholder.font} context:nil].size;
    placeholder.frame = CGRectMake(10, 6, size.width, size.height);
    placeholder.textColor = [UIColor lightGrayColor];
    placeholder.hidden = YES;
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
