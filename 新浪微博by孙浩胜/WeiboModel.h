//
//  WeiboModel.h
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-20.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;
@class LocationModel;

@interface WeiboModel : NSObject

@property (nonatomic,copy) NSString *created_at;

@property (nonatomic,assign) long long mid;

@property (nonatomic,copy) NSString *idstr;

@property (nonatomic,copy) NSString *text;

@property (nonatomic,copy) NSString *source;

@property (nonatomic,assign) int reposts_count;

@property (nonatomic,assign) int comments_count;

@property (nonatomic,copy) NSString *original_pic;

@property (nonatomic,copy) NSString *thumbnail_pic;

@property (nonatomic,strong) NSArray *pic_urls;

@property (nonatomic,assign) int attitudes_count;

@property (nonatomic,strong) UserModel *user;

@property (nonatomic,strong) WeiboModel *retweeted_status;

+ (instancetype)WeiboModelWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
