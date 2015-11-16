//
//  ClassifyTableView.m
//  新浪微博by孙浩胜
//
//  Created by apple on 15-3-19.
//  Copyright (c) 2015年 孙浩胜. All rights reserved.
//

#import "ClassifyTableView.h"
#import "UIImage+AutoStretch.h"
NSIndexPath *selectedIndex ;
@implementation ClassifyTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [[UIScreen mainScreen] bounds];
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [UIImage autoStretchWithimageName:@"popover_background"];
        imageView.center = CGPointMake(self.bounds.size.width/2,self.bounds.size.height/2 - 30);
        imageView.userInteractionEnabled = YES;
        
        
        UITableView *tv = [[UITableView alloc] initWithFrame:frame];
        tv.frame = CGRectMake(0, 0,imageView.bounds.size.width - 20,imageView.bounds.size.height-20);
        tv.center = CGPointMake(imageView.bounds.size.width/2 ,imageView.bounds.size.height/2);
        tv.backgroundColor = [UIColor clearColor];
        tv.delegate = self;
        tv.dataSource = self;
        tv.rowHeight = 40;
        tv.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        [imageView addSubview:tv];
        [self addSubview:imageView];
       
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
    _titleBtn.tag = 2;
    [_titleBtn setImage:[UIImage imageNamed:@"navigationbar_arrow_down_os7"] forState:UIControlStateNormal];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    cell.textLabel.text = [NSString stringWithFormat:@"我的好友%ld",indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:selectedIndex];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectedBackgroundView = nil;
    selectedIndex = indexPath;
    cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor orangeColor];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage autoStretchWithimageName:@"skin_cell_background"]];
    imageView.alpha = 0.2;
    [cell setSelectedBackgroundView:imageView];
    [cell setBackgroundView:nil];
    if ([self.delegate respondsToSelector:@selector(ClassifyTableView:selectedItem:)]) {
        [self.delegate ClassifyTableView:self selectedItem:cell.textLabel.text];
    }
    [self touchesEnded:nil withEvent:nil];
}
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].textLabel.textColor = [UIColor orangeColor];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.3;
    [tableView cellForRowAtIndexPath:indexPath].backgroundView = view;
    return YES;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].textLabel.textColor = [UIColor whiteColor];
    [tableView cellForRowAtIndexPath:indexPath].backgroundView = nil;
}

@end
