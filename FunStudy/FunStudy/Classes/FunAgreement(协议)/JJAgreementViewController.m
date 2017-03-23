//
//  JJAgreementViewController.m
//  FunStudy
//
//  Created by 唐天成 on 2017/1/10.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import "JJAgreementViewController.h"
#import "XPWebView.h"

@interface JJAgreementViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) XPWebView *webView;


@end

@implementation JJAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.image = [UIImage imageNamed:@"LoginBack"];
    [self.view addSubview:backImageView];
    [backImageView sendToBack];
    
    UIImageView *centerBackImageView = [[UIImageView alloc]init];
    centerBackImageView.userInteractionEnabled = YES;
    centerBackImageView.image = [UIImage imageNamed:@"Login_BackCenterImage"];
    [self.view addSubview:centerBackImageView];
    [centerBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(315 * KWIDTH_IPHONE6_SCALE);
        make.height.mas_equalTo(363 * KWIDTH_IPHONE6_SCALE);
    }];

    self.webView = [[XPWebView alloc]initWithFrame:CGRectMake(0, NAVIGATION_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_HEIGHT)];
    [self.view addSubview:self.webView];
    self.webView.remoteUrl = [NSString stringWithFormat:@"%@%@", DEVELOP_BASE_URL, API_PROTOCOL];
    self.webView.webViewProxyDelegate = self;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}


@end
