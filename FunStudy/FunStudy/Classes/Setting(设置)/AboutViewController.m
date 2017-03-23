//
//  AboutViewController.m
//  FunStudy
//
//  Created by tang on 16/11/12.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseView];
    [self setNavigationBar];
    
    //y  114 w 300 h 306
    
    [self showView];
}

- (void)showView{
    UIImageView *backView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"about_bg"]];
    backView.frame = CGRectMake((SCREEN_WIDTH -300 * KWIDTH_IPHONE6_SCALE)/2 , 114 *KWIDTH_IPHONE6_SCALE, 300 * KWIDTH_IPHONE6_SCALE, 306 *KWIDTH_IPHONE6_SCALE );
    
    //头像
    UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"about_icon"]];
    iconView.frame = CGRectMake((backView.width - 135*KWIDTH_IPHONE6_SCALE)/2, 51*KWIDTH_IPHONE6_SCALE, 135*KWIDTH_IPHONE6_SCALE, 135*KWIDTH_IPHONE6_SCALE);
    [backView addSubview:iconView];
    
    //版本
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iconView.frame), backView.width, 30*KWIDTH_IPHONE6_SCALE)];
        versionLabel.text = kVersion;
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = NORMAL_COLOR;
    [backView addSubview:versionLabel];
    
    //图像 102  34
    UIImageView *funView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"about_title"]];
    funView.frame = CGRectMake((backView.width - 102*KWIDTH_IPHONE6_SCALE)/2, CGRectGetMaxY(versionLabel.frame), 102*KWIDTH_IPHONE6_SCALE, 34*KWIDTH_IPHONE6_SCALE);
    [backView addSubview:funView];

    //网址
    UILabel *urlLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(funView.frame), backView.width, 30*KWIDTH_IPHONE6_SCALE)];
    urlLabel.text = @"www.51funstudy.com";
    urlLabel.textAlignment = NSTextAlignmentCenter;
    urlLabel.textColor = NORMAL_COLOR;
    [backView addSubview:urlLabel];
    
    [self.view addSubview:backView];
    
    
    
    
    //联系电话
    UILabel *phoneLbel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(backView.frame) + 60*KWIDTH_IPHONE6_SCALE, SCREEN_WIDTH, 20*KWIDTH_IPHONE6_SCALE)];
    phoneLbel.text = @"联系电话：40008 06173";
    phoneLbel.textAlignment = NSTextAlignmentCenter;
    phoneLbel.textColor = [UIColor whiteColor];
    [self.view addSubview:phoneLbel];
    
//    底部label
    UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(phoneLbel.frame)+25*KWIDTH_IPHONE6_SCALE, SCREEN_WIDTH, 20*KWIDTH_IPHONE6_SCALE)];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
     bottomLabel.textColor = [UIColor whiteColor];
    bottomLabel.text = @"北京市现代教学研究所";
    [self.view addSubview:bottomLabel];
}

//设置背景图
- (void)setBaseView {
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.image = [UIImage imageNamed:@"LoginBack"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
}
//设置导航条
- (void)setNavigationBar {
    self.titleName = @"关于我们";
}
@end
