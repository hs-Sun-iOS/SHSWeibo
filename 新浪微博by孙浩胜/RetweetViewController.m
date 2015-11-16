//
//  RetweetViewController.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/25.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "RetweetViewController.h"
#import "RetweetTextView.h"
#import "SendToolbar.h"
#import "UIButton+FastBtn.h"
#import "AFNetworking.h"
#import "MBProgressHUD+fastSetup.h"
#import "WeiboModel.h"

@interface RetweetViewController ()
@property (nonatomic,weak) RetweetTextView *retweetTextView;

@property (nonatomic,weak) SendToolbar *sendToolbar;



@end

@implementation RetweetViewController


- (void)viewDidLoad
{
    [self addretweetTextView];
    
    [self addSendToolbar];
    
    self.navigationItem.prompt = @"转发微博";

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithTitle:@"取消" NormalTitleColor:[UIColor orangeColor] HighlightTitleColor:[UIColor grayColor] target:self action:@selector(backBtnClick) isEnable:YES]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithTitle:@"发送" NormalTitleColor:[UIColor orangeColor] HighlightTitleColor:[UIColor grayColor] target:self action:@selector(sendWeibo) isEnable:NO]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnEnable) name:@"vaildInput" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnDisable) name:@"invaildInput" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDisappear:) name:UIKeyboardWillHideNotification object:nil];
    [super viewDidLoad];
}


- (void)viewDidAppear:(BOOL)animated
{
    if (self.rewteetedWeiboModel.retweeted_status) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else
        self.navigationItem.rightBarButtonItem.enabled = NO;

    [super viewDidAppear:animated];
    [self.retweetTextView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.retweetTextView resignFirstResponder];
}

- (void)keyboardAppear:(NSNotification *)notice
{
    [UIView animateWithDuration:0.25f animations:^{
        self.sendToolbar.transform  = CGAffineTransformMakeTranslation(0, -252.0);
    }];
}
- (void)keyboardDisappear:(NSNotification *)notice
{
    [UIView animateWithDuration:0.25f animations:^{
        self.sendToolbar.transform = CGAffineTransformIdentity;
    }];
}


- (void)btnEnable
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

-(void) btnDisable
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
}


- (void)sendWeibo
{
    AFHTTPRequestOperationManager *AFNManager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"tokenInfo"] objectForKey:@"access_token"];
    dict[@"status"] = self.retweetTextView.text;
    dict[@"id"] = self.rewteetedWeiboModel.idstr;
    [AFNManager POST:@"https://api.weibo.com/2/statuses/repost.json" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD showSuccess:@"转发成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"转发失败"];
    }];
    
    
    [self backBtnClick];
    
    
}

- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addSendToolbar
{
    SendToolbar *sendToolbar = [[SendToolbar alloc] init];
    [self.view addSubview:sendToolbar];
    _sendToolbar = sendToolbar;
}
- (void)addretweetTextView
{
    RetweetTextView *retweetTextView = [[RetweetTextView alloc] initWithWeiboModel:self.rewteetedWeiboModel];
    _retweetTextView = retweetTextView;
    [self.view addSubview:retweetTextView];
}
@end
