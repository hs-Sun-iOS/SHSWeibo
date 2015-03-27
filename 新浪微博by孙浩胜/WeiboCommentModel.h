//
//  WeiboCommentModel.h
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/26.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;

@interface WeiboCommentModel : NSObject

@property (nonatomic,copy) NSString *created_at;

@property (nonatomic,copy) NSString *idstr;

@property (nonatomic,copy) NSString *text;

@property (nonatomic,strong) UserModel *user;

@end
