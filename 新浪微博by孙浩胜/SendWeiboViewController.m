//
//  SendWeiboViewController.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-19.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "SendWeiboViewController.h"
#import "SendTextView.h"
#import "UIButton+FastBtn.h"

@interface SendWeiboViewController ()

@property (nonatomic,weak) SendTextView *sendTextView;

@end

@implementation SendWeiboViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addSendTextView];
    

    self.navigationItem.prompt = @"发微博";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithTitle:@"取消" NormalTitleColor:[UIColor orangeColor] HighlightTitleColor:[UIColor grayColor] target:self action:@selector(rightBtnClick) isEnable:YES]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithTitle:@"发送" NormalTitleColor:[UIColor orangeColor] HighlightTitleColor:[UIColor grayColor] target:self action:@selector(sendWeibo) isEnable:NO]];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnEnable) name:@"vaildInput" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnDisable) name:@"invaildInput" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.sendTextView becomeFirstResponder];
}

- (void)btnEnable
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

-(void) btnDisable
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)sendWeibo
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)rightBtnClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)addSendTextView
{
    SendTextView *sendTextView = [SendTextView SendTextView];
    _sendTextView = sendTextView;
    [self.view addSubview:sendTextView];
}

@end
