//
//  OAuthViewController.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-20.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "OAuthViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+fastSetup.h"
#import "ViewController.h"
#import "NewFeatureViewController.h"

@implementation OAuthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadWebview];
    
}


- (void)loadWebview
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=831372268&redirect_uri=www.baidu.com"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showMessage:@"努力加载中..."];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUD];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSRange range = [url rangeOfString:@"code="];
    if (range.length != 0) {
        NSString *code = [url substringFromIndex:range.location+range.length];
        AFHTTPRequestOperationManager *AFNManager = [AFHTTPRequestOperationManager manager];
        
        //封装数据体
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"client_id"] = @"831372268";
        dict[@"client_secret"] = @"1f624b050701de067967899646bb7072";
        dict[@"grant_type"] = @"authorization_code";
        dict[@"code"] = code;
        dict[@"redirect_uri"] = @"http://www.baidu.com";
        
        
        [AFNManager POST:[NSString stringWithFormat:@"https://api.weibo.com/oauth2/access_token"] parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"tokenInfo"];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"uid"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [MBProgressHUD hideHUD];
            [self isFirstSetup];

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
        return NO;
        
    }
    return YES;
}

- (void) isFirstSetup
{
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastVersion"];
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
    
    if ([lastVersion isEqualToString:currentVersion]) {
        self.view.window.rootViewController = [[ViewController alloc] init];
    } else {
        self.view.window.rootViewController = [[NewFeatureViewController alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"lastVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
