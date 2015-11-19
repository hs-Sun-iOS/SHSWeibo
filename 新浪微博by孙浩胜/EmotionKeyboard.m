//
//  EmotionKeyboard.m
//  新浪微博by孙浩胜
//
//  Created by sunhaosheng on 15/11/19.
//  Copyright © 2015年 孙浩胜. All rights reserved.
//

#import "EmotionKeyboard.h"
#import "EmotionListView.h"
#import "EmotionToolbar.h"
@interface EmotionKeyboard ()
@property (nonatomic,weak) EmotionListView *listView;

@property (nonatomic,weak) EmotionToolbar *toolbar;

@end

@implementation EmotionKeyboard

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupToolbar];
        [self setupListView];
    }
    return self;
}

- (void)setupListView {
    EmotionListView *listView = [[EmotionListView alloc] init];
    _listView = listView;
    listView.backgroundColor = [UIColor redColor];
    [self addSubview:self.listView];
}

- (void)setupToolbar {
    EmotionToolbar *toolbar = [[EmotionToolbar alloc] init];
    _toolbar = toolbar;
    toolbar.backgroundColor = [UIColor yellowColor];
    [self addSubview:self.toolbar];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _toolbar.height = 50;
    _toolbar.y = self.height - _toolbar.height;
    _toolbar.width = self.width;
    _listView.width = self.width;
    _listView.height = self.toolbar.y;
}

@end
