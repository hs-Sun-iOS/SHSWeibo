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
#import "MBProgressHUD+fastSetup.h"
#import "SendToolbar.h"
#import "AFNetworking.h"
#import "EmotionKeyboard.h"

@interface SendWeiboViewController () <SendToolbarDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    BOOL _isSwitchingKeyboard;
}

@property (nonatomic,weak) SendTextView *sendTextView;

@property (nonatomic,weak) SendToolbar *sendToolbar;

@property (nonatomic,weak) UIImageView *imageView;

@property (nonatomic,strong) NSMutableArray *pictures;

@property (nonatomic,strong) EmotionKeyboard *emotionKeyboard;

@end

@implementation SendWeiboViewController

-(NSMutableArray *)pictures
{
    if (_pictures == nil) {
        _pictures = [NSMutableArray array];
    }
    return _pictures;
}

- (EmotionKeyboard *)emotionKeyboard {
    if (!_emotionKeyboard) {
        EmotionKeyboard *emotionKeyboard = [[EmotionKeyboard alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 250)];
        _emotionKeyboard = emotionKeyboard;
    }
    _emotionKeyboard.height = self.view.height - CGRectGetMaxY(self.sendToolbar.frame);
    return _emotionKeyboard;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addSendTextView];
    
    [self addSendToolbar];
    
    self.navigationItem.prompt = @"发微博";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithTitle:@"取消" NormalTitleColor:[UIColor orangeColor] HighlightTitleColor:[UIColor grayColor] target:self action:@selector(backBtnClick) isEnable:YES]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithTitle:@"发送" NormalTitleColor:[UIColor orangeColor] HighlightTitleColor:[UIColor grayColor] target:self action:@selector(sendWeibo) isEnable:NO]];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnEnable) name:@"vaildInput" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnDisable) name:@"invaildInput" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDisappear:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.sendTextView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.sendTextView resignFirstResponder];
}

- (void)keyboardAppear:(NSNotification *)notice
{
    if (_isSwitchingKeyboard) {
        return;
    }
    CGRect keyboardRect = [[notice.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:0.25f animations:^{
        self.sendToolbar.transform  = CGAffineTransformMakeTranslation(0, -keyboardRect.size.height);
    }];
}
- (void)keyboardDisappear:(NSNotification *)notice
{
    if (_isSwitchingKeyboard) {
        return;
    }
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
    dict[@"status"] = self.sendTextView.text;
    
    if (self.pictures.count) {
        [self sendWithImageWith:AFNManager parameters:dict];
    }
    else
        [self sendWithoutImageWith:AFNManager parameters:dict];
    
    [self backBtnClick];
    

}

- (void)sendWithImageWith:(AFHTTPRequestOperationManager *)AFNManager parameters:(NSDictionary *)dict
{
    
    [AFNManager POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *data = UIImageJPEGRepresentation(self.imageView.image, 1.0);
        [formData appendPartWithFileData:data name:@"pic" fileName:@"head.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [MBProgressHUD showSuccess:@"发送成功"];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showError:@"发送失败"];
        });
    }];
    
}

- (void)sendWithoutImageWith:(AFHTTPRequestOperationManager *)AFNManager parameters:(NSDictionary *)dict
{
    [AFNManager POST:@"https://api.weibo.com/2/statuses/update.json" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
        NSLog(@"%@",error);
    }];
}


- (void)backBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addSendToolbar
{
    SendToolbar *sendToolbar = [[SendToolbar alloc] init];
    [self.view addSubview:sendToolbar];
    _sendToolbar = sendToolbar;
    _sendToolbar.delegate = self;
}
- (void)addSendTextView
{
    SendTextView *sendTextView = [SendTextView SendTextView];
    _sendTextView = sendTextView;
    [self.view addSubview:sendTextView];
}

#pragma mark - sendtoolbarDelegate
- (void)SendToolbar:(SendToolbar *)sendtoolbar DidClickBtntype:(SendToolbarButtonType)btntype
{
    switch (btntype) {
        case SendToolbarButtonTypeCamera:
            [self openCamera];
            break;
        case SendToolbarButtonTypePicture:
            [self openPhoto];
            break;
        case SendToolbarButtonTypeEmotion:
            [self switchKeyboard];
            break;
        case SendToolbarButtonTypeKeyboard:
            [self switchKeyboard];
            break;
        default:
            break;
    }
}
#pragma mark - private method

- (void)switchKeyboard {
    _isSwitchingKeyboard = YES;
    if (self.sendTextView.inputView) {
        self.sendTextView.inputView = nil;
    } else {
        self.sendTextView.inputView = self.emotionKeyboard;
    }
    [self.sendTextView resignFirstResponder];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.sendTextView becomeFirstResponder];
        [_emotionKeyboard layoutIfNeeded];
    });
    _isSwitchingKeyboard = NO;
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.pictures addObject:[self addImageView]];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    ((UIImageView *)[self.pictures lastObject]).image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImageView *)addImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(10, 90, 80, 80);
    _imageView = imageView;
    [self.sendTextView addSubview:imageView];
    return imageView;
}
- (void)openCamera
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:ipc animated:YES completion:nil];
}

- (void)openPhoto
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.allowsEditing = YES;
    ipc.delegate = self;
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:ipc animated:YES completion:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
