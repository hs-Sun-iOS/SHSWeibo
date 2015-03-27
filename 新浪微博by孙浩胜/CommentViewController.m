//
//  CommentViewController.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15/3/26.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "CommentViewController.h"
#import "SendToolbar.h"
#import "CommentTextView.h"
#import "AFNetworking.h"
#import "MBProgressHUD+fastSetup.h"
#import "UIButton+FastBtn.h"

@interface CommentViewController ()
@property (nonatomic,weak) CommentTextView *commentTextView;

@property (nonatomic,weak) SendToolbar *sendToolbar;

@property (nonatomic,strong) NSMutableDictionary *parameters;

@end

@implementation CommentViewController

- (NSMutableDictionary *)parameters
{
    if (_parameters == nil) {
        _parameters = [NSMutableDictionary dictionary];
    }
    return _parameters;
}
- (void)viewDidLoad
{
    [self addCommentTextView];
    
    [self addSendToolbar];
    
    self.navigationItem.prompt = @"评论微博";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithTitle:@"取消" NormalTitleColor:[UIColor orangeColor] HighlightTitleColor:[UIColor grayColor] target:self action:@selector(backBtnClick) isEnable:YES]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithTitle:@"发送" NormalTitleColor:[UIColor orangeColor] HighlightTitleColor:[UIColor grayColor] target:self action:@selector(sendWeibo) isEnable:NO]];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnEnable) name:@"vaildInput" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnDisable) name:@"invaildInput" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDisappear:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)sendWeibo
{
    AFHTTPRequestOperationManager *AFNManager = [AFHTTPRequestOperationManager manager];
    
    self.parameters[@"access_token"] = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"tokenInfo"] objectForKey:@"access_token"];
    self.parameters[@"comment"] = self.commentTextView.text;
    self.parameters[@"id"] = self.weiboId;
    if (self.sendToolbar.smallBtn.selected) {
        self.parameters[@"comment_ori"] = @1;
    }
    
    [AFNManager POST:@"https://api.weibo.com/2/comments/create.json" parameters:self.parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD showSuccess:@"评论成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"评论失败"];
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
    sendToolbar.smallBtn.hidden = NO;
    sendToolbar.smallLabel.hidden = NO;
    [self.view addSubview:sendToolbar];
    _sendToolbar = sendToolbar;
}
- (void)addCommentTextView
{
    CommentTextView *commentTextView = [[CommentTextView alloc] init];
    _commentTextView = commentTextView;
    [self.view addSubview:commentTextView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.commentTextView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.commentTextView resignFirstResponder];
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

@end
