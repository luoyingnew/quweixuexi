//
//  XZShare.m
//  NotAloneInTheDark
//
//  Created by hao on 2017/1/2.
//  Copyright © 2017年 XZ. All rights reserved.
//

#import "XZShare.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "UIColor+XZUtils.h"

@implementation XZShare {
    NSMutableDictionary *_params;
    NSString *_title;
    NSArray *_images;
    NSString *_content;
    NSString *_url;
    UIView *shareView;
    UIButton *wechatBtn;
    UIButton *wechatFriendBtn;
    UIButton *qqBtn;
    UIButton *weiboBtn;
    BOOL isHorz;
    CGFloat XZShareViewHeight;
}

+ (instancetype)sharedInstance {
    static id singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

+ (instancetype)sharedHorzInstance {
    static id singletonHorz = nil;
    static dispatch_once_t onceTokenHorz;
    dispatch_once(&onceTokenHorz, ^{
        singletonHorz = [[self alloc] initHorz];
    });
    return singletonHorz;
}

- (instancetype)init {
    if (self = [super init]) {
        XZShareViewHeight = 140;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        self.hidden = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tap];
        
        shareView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - XZShareViewHeight,  SCREEN_WIDTH, XZShareViewHeight)];
        shareView.backgroundColor = [UIColor xz_tabbarColor];
        [[UIApplication sharedApplication].keyWindow addSubview:shareView];
        
        wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        wechatBtn.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        [wechatBtn setTitle:@"微信" forState:UIControlStateNormal];
        [wechatBtn setImage:[UIImage imageNamed:@"share_wechat_40x40"] forState:UIControlStateNormal];
        [wechatBtn addTarget:self action:@selector(shareToWechat:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:wechatBtn];
        
        wechatFriendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        wechatFriendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        [wechatFriendBtn setTitle:@"朋友圈" forState:UIControlStateNormal];
        [wechatFriendBtn setImage:[UIImage imageNamed:@"share_wechatFreind_40x40"] forState:UIControlStateNormal];
        [wechatFriendBtn addTarget:self action:@selector(shareToWechatFriend:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:wechatFriendBtn];

        qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        qqBtn.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        [qqBtn setTitle:@"QQ" forState:UIControlStateNormal];
        [qqBtn setImage:[UIImage imageNamed:@"share_qq_40x40"] forState:UIControlStateNormal];
        [qqBtn addTarget:self action:@selector(shareToQQ:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:qqBtn];
        
        weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        weiboBtn.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        [weiboBtn setTitle:@"微博" forState:UIControlStateNormal];
        [weiboBtn setImage:[UIImage imageNamed:@"share_weibo_40x40"] forState:UIControlStateNormal];
        [weiboBtn addTarget:self action:@selector(shareToWeibo:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:weiboBtn];
        
        self.showBlk = ^(){};
        self.hideBlk = ^(){};
    }
    return self;
}

- (instancetype)initHorz {
    if (self = [super init]) {
        XZShareViewHeight = 110;
        isHorz = YES;
        self.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tap];
        
        shareView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT - XZShareViewHeight, 0,  XZShareViewHeight,SCREEN_WIDTH)];
        shareView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
        [[UIApplication sharedApplication].keyWindow addSubview:shareView];
        
        wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        wechatBtn.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        [wechatBtn setTitle:@"微信" forState:UIControlStateNormal];
        [wechatBtn setImage:[UIImage imageNamed:@"share_wechat_40x40"] forState:UIControlStateNormal];
        [wechatBtn addTarget:self action:@selector(shareToWechat:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:wechatBtn];
        
        wechatFriendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        wechatFriendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        [wechatFriendBtn setTitle:@"朋友圈" forState:UIControlStateNormal];
        [wechatFriendBtn setImage:[UIImage imageNamed:@"share_wechatFreind_40x40"] forState:UIControlStateNormal];
        [wechatFriendBtn addTarget:self action:@selector(shareToWechatFriend:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:wechatFriendBtn];
        
        qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        qqBtn.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        [qqBtn setTitle:@"QQ" forState:UIControlStateNormal];
        [qqBtn setImage:[UIImage imageNamed:@"share_qq_40x40"] forState:UIControlStateNormal];
        [qqBtn addTarget:self action:@selector(shareToQQ:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:qqBtn];
        
        weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        weiboBtn.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        [weiboBtn setTitle:@"微博" forState:UIControlStateNormal];
        [weiboBtn setImage:[UIImage imageNamed:@"share_weibo_40x40"] forState:UIControlStateNormal];
        [weiboBtn addTarget:self action:@selector(shareToWeibo:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:weiboBtn];
        
        self.showBlk = ^(){};
        self.hideBlk = ^(){};
    }
    return self;
}


- (void)shareWithTitle:(NSString *)title images:(NSArray *)images content:(NSString *)content url:(NSString *)url {
    _params = [NSMutableDictionary dictionary];
    _title = title;
    _images = [images copy];
    if (!_images || _images.count == 0) {
        _images = @[@"inviteLogo_96x96"];
    }
    _content = content;
    _url = url;
    
    [self show];
}

- (void)shareToWechat:(UIButton *)btn {
    [_params SSDKSetupWeChatParamsByText:_content title:_title url:[NSURL URLWithString:_url] thumbImage:_images[0] image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    [self shareType:SSDKPlatformSubTypeWechatSession param:_params];
}

- (void)shareToWechatFriend:(UIButton *)btn {
    [_params SSDKSetupWeChatParamsByText:_content title:_title url:[NSURL URLWithString:_url] thumbImage:_images[0] image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    [self shareType:SSDKPlatformSubTypeWechatTimeline param:_params];
}

- (void)shareToQQ:(UIButton *)btn {
    [_params SSDKSetupQQParamsByText:_content title:_title url:[NSURL URLWithString:_url] thumbImage:_images[0] image:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    [self shareType:SSDKPlatformSubTypeQQFriend param:_params];
}

- (void)shareToWeibo:(UIButton *)btn {
    [_params SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@%@", _content, _url] title:_title image:_images[0] url:[NSURL URLWithString:_url] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
    [self shareType:SSDKPlatformTypeSinaWeibo param:_params];
}

- (void)shareType:(SSDKPlatformType)type param:(NSMutableDictionary *)params {
    weakSelf(weakSelf);
    [ShareSDK share:type parameters:params onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        [weakSelf hide];
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                [JJHud showToast:@"分享成功"];
                break;
            }
            case SSDKResponseStateFail:
            {
                if (error.code == 208) {
                    [JJHud showToast:@"未安装客户端"];
                } else {
                    [JJHud showToast:@"分享失败"];
                }
                break;
            }
            default:
                break;
        }
    }];
}

- (void)show {
    CGFloat btnWidth = SCREEN_WIDTH / 4;
    CGFloat btnHeight = XZShareViewHeight;
    CGFloat topMargin = 0;
    if (isHorz) {
        btnWidth = SCREEN_WIDTH / 4.4;
        topMargin = (SCREEN_WIDTH - btnWidth*4)/2;
    }

    if ([WXApi isWXAppInstalled] == NO && [QQApiInterface isQQInstalled] == NO) {
        wechatBtn.hidden = YES;
        wechatFriendBtn.hidden = YES;
        qqBtn.hidden = YES;
        if (isHorz) {
            weiboBtn.frame = CGRectMake(0, topMargin, btnHeight, btnWidth);
        } else {
            weiboBtn.frame = CGRectMake(0, 0, btnWidth, btnHeight);
        }
    } else if ([WXApi isWXAppInstalled] == NO && [QQApiInterface isQQInstalled] == YES) {
        wechatBtn.hidden = YES;
        wechatFriendBtn.hidden = YES;
        qqBtn.hidden = NO;
        if (isHorz) {
            qqBtn.frame = CGRectMake(0, topMargin, btnHeight, btnWidth);
            weiboBtn.frame = CGRectMake(0, topMargin + btnWidth, btnHeight, btnWidth);
        } else {
            qqBtn.frame = CGRectMake(0, 0, btnWidth, btnHeight);
            weiboBtn.frame = CGRectMake(btnWidth, 0, btnWidth, btnHeight);
        }
    } else if ([WXApi isWXAppInstalled] == YES && [QQApiInterface isQQInstalled] == NO) {
        wechatBtn.hidden = NO;
        wechatFriendBtn.hidden = NO;
        qqBtn.hidden = YES;
        if (isHorz) {
            wechatBtn.frame = CGRectMake(0, topMargin, btnHeight, btnWidth);
            wechatFriendBtn.frame = CGRectMake(0, topMargin + btnWidth, btnHeight, btnWidth);
            weiboBtn.frame = CGRectMake(0, topMargin + btnWidth*2, btnHeight, btnWidth);
        } else {
            wechatBtn.frame = CGRectMake(0, 0, btnWidth, btnHeight);
            wechatFriendBtn.frame = CGRectMake(btnWidth, 0, btnWidth, btnHeight);
            weiboBtn.frame = CGRectMake(btnWidth * 2, 0, btnWidth, btnHeight);
        }
    } else {
        wechatBtn.hidden = NO;
        wechatFriendBtn.hidden = NO;
        qqBtn.hidden = NO;
        if (isHorz) {
            wechatBtn.frame = CGRectMake(0, topMargin, btnHeight, btnWidth);
            wechatFriendBtn.frame = CGRectMake(0, topMargin + btnWidth, btnHeight, btnWidth);
            qqBtn.frame = CGRectMake(0, topMargin + btnWidth*2, btnHeight, btnWidth);
            weiboBtn.frame = CGRectMake(0, topMargin + btnWidth*3, btnHeight, btnWidth);
        } else {
            wechatBtn.frame = CGRectMake(0, 0, btnWidth, btnHeight);
            wechatFriendBtn.frame = CGRectMake(btnWidth, 0, btnWidth, btnHeight);
            qqBtn.frame = CGRectMake(btnWidth * 2, 0, btnWidth, btnHeight);
            weiboBtn.frame = CGRectMake(btnWidth * 3, 0, btnWidth, btnHeight);
        }
    }
    [wechatBtn verticalCenterImageAndTitle:5];
    [wechatFriendBtn verticalCenterImageAndTitle:5];
    [qqBtn verticalCenterImageAndTitle:5];
    [weiboBtn verticalCenterImageAndTitle:5];

    if (isHorz) {
        shareView.transform = CGAffineTransformMakeTranslation(XZShareViewHeight, 0);
        [UIView animateWithDuration:0.35f animations:^{
            self.hidden = NO;
            shareView.transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:nil];
    } else {
        shareView.transform = CGAffineTransformMakeTranslation(0, XZShareViewHeight);
        [UIView animateWithDuration:0.35f animations:^{
            self.hidden = NO;
            shareView.transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:nil];
    }
    
    self.showBlk();
}

- (void)hide {
    if (isHorz) {
        [UIView animateWithDuration:0.35f animations:^{
            shareView.transform = CGAffineTransformMakeTranslation(XZShareViewHeight, 0);
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    } else {
        [UIView animateWithDuration:0.35f animations:^{
            shareView.transform = CGAffineTransformMakeTranslation(0, XZShareViewHeight);
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }
    self.hideBlk();
}
@end
