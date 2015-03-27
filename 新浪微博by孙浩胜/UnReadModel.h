//
//  UnReadModel.h
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/24.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnReadModel : NSObject


/**未读微博数*/
@property (nonatomic,assign) int status;
/**新粉丝数*/
@property (nonatomic,assign) int follower;
/**新评论数*/
@property (nonatomic,assign) int cmt;
/**新私信数*/
@property (nonatomic,assign) int dm;
/**提及我的微博数*/
@property (nonatomic,assign) int mention_status;
/**提及我的评论数数*/
@property (nonatomic,assign) int mention_cmt;
/**新通知未读数*/
@property (nonatomic,assign) int notice;

- (int)messageCount;
@end
