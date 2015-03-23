//
//  SearchBar.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-18.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "SearchBar.h"
#import "UIImage+AutoStretch.h"

@implementation SearchBar


+(instancetype)SearchBar
{
    return [[SearchBar alloc] init];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setBackground:[UIImage autoStretchWithimageName:@"searchbar_textfield_background_os7"]];
        self.frame = CGRectMake(0, 0, 320, 30);
        UIImageView *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        searchImage.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
        searchImage.contentMode = UIViewContentModeCenter;
        self.leftView = searchImage;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.clearButtonMode = UITextFieldViewModeAlways;
        self.font = [UIFont systemFontOfSize:13.0f];
        self.placeholder = @"搜索";
        self.returnKeyType = UIReturnKeySearch;
        self.enablesReturnKeyAutomatically = YES;
    }
    return self;
}

@end
