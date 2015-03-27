//
//  RetweetTextView.h
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/25.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WeiboModel;
@interface RetweetTextView : UITextView<UITextViewDelegate>


- (instancetype)initWithWeiboModel:(WeiboModel *)weiboModel;
@end
