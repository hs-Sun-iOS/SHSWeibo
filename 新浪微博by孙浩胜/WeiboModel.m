//
//  WeiboModel.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-20.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "WeiboModel.h"
#import "UserModel.h"
#import "MJExtension.h"
#import "NSDate+MJ.h"
#import "PhotoModel.h"

@implementation WeiboModel

+ (instancetype)WeiboModelWithDictionary:(NSDictionary *)dictionary
{
    return [[WeiboModel alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.created_at = dictionary[@"created_at"];
        
        self.mid = [dictionary[@"mid"] longLongValue];
        
        self.idstr = dictionary[@"idstr"];
        
        self.text = dictionary[@"text"];
        
        self.source = dictionary[@"source"];
        
        self.reposts_count = [dictionary[@"reposts_count"] intValue];
        
        self.comments_count = [dictionary[@"comments_count"] intValue];
        
        self.original_pic = dictionary[@"original_pic"];
        
        self.attitudes_count = [dictionary[@"attitudes_count"] intValue];
        
        self.user = [UserModel userModelWithDictionary:dictionary[@"user"]];
        
        
    }
    return self;
}


- (NSDictionary *)objectClassInArray
{
    
    return @{@"pic_urls":[PhotoModel class]};
}


- (int)comments_count
{
   // NSLog(@" weibomodel   %@ , comment %d  retweet %d  zan %d",_text,_comments_count,_reposts_count,_attitudes_count);
    return _comments_count;
}

- (void)setSource:(NSString *)source
{
    NSInteger loc = [source rangeOfString:@">"].location + 1;
    if (loc > 0) {
        NSInteger len = [source rangeOfString:@"</"].location - loc;
        NSRange range = {loc,len};
        _source = [NSString stringWithFormat:@"来自%@",[source substringWithRange:range]];
    }
    

}


- (NSString *)created_at
{
    NSCalendar *calendar =[NSCalendar currentCalendar];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"EEE MMM dd HH:mm:ss z yyyy";
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
   
    NSDate *creatDate = [df dateFromString:_created_at];
    
    if ([calendar isDateInToday:creatDate]) {
        if ([creatDate deltaWithNow].hour >= 1)
            return [NSString stringWithFormat:@"%ld小时前",[creatDate deltaWithNow].hour];
        else if ([creatDate deltaWithNow].minute >= 1)
            return [NSString stringWithFormat:@"%ld分钟前",[creatDate deltaWithNow].minute];
        else
            return @"刚刚";
    }
    else if ([calendar isDateInYesterday:creatDate])
    {
        df.dateFormat = @"昨天 HH:mm";
        return [df stringFromDate:creatDate];
    }
    else if ([creatDate isThisYear])
    {
        df.dateFormat = @"MM-dd HH:mm";
        return [df stringFromDate:creatDate];
    }
    else
    {
        df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        return [df stringFromDate:creatDate];
    }
    
}
@end
