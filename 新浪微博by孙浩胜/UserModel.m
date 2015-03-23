//
//  UserModel.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-20.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (instancetype)userModelWithDictionary:(NSDictionary *)dictionary
{
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.idstr = dictionary[@"idstr"];
        self.profile_image_url = dictionary[@"profile_image_url"];
        self.name = dictionary[@"name"];
    }
    return self;
}

@end
