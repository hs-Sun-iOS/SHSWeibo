//
//  UnReadModel.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/24.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "UnReadModel.h"

@implementation UnReadModel

- (int)messageCount
{
    return self.mention_cmt + self.mention_status + self.cmt + self.dm;
}
@end
