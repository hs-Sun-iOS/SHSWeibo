//
//  WeiboCommentModel.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/26.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "WeiboCommentModel.h"

@implementation WeiboCommentModel

- (NSString *)created_at
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"EEE MMM dd HH:mm:ss z yyyy";
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    NSDate *creatDate = [df dateFromString:_created_at];
    
    df.dateFormat = @"MM-dd HH:mm";
    
    return [df stringFromDate:creatDate];
}

@end
