//
//  UserModel.h
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-20.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic,copy) NSString *idstr;

@property (nonatomic,copy) NSString *profile_image_url;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,assign) int mbrank;



+ (instancetype)userModelWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
