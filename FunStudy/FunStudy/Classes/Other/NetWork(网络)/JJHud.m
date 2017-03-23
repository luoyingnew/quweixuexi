//
//  JJHud.m
//  Chocolate
//
//  Created by lwb on 2016/10/13.
//  Copyright © 2016年 北京进击科技有限公司. All rights reserved.
//

#import "JJHud.h"
#import "SVProgressHUD.h"
@interface JJHud()

@end
@implementation JJHud

//程序一启动时会调用该方法    目的:主要是因为发现HUD首次调用时不会有转圈效果,在最开始调用dismiss后就可以了,原因不明
+(void)load {

    [self dismiss];
}

#pragma mark Priviate Method
+ (void)initToastProgressHud {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
//    [SVProgressHUD setBackgroundLayerColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    [SVProgressHUD setRingThickness:5.0 * KWIDTH_IPHONE6_SCALE];
    [SVProgressHUD setInfoImage:nil];
    [SVProgressHUD setCornerRadius:5.0 * KWIDTH_IPHONE6_SCALE];
    [SVProgressHUD setFont:[UIFont boldSystemFontOfSize:15 * KWIDTH_IPHONE6_SCALE]];
}

+ (void)initLoadingHud {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
//    [SVProgressHUD setBackgroundLayerColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];


}
#pragma mark Public Method
+ (void)showToast:(NSString *)title {
    [self initToastProgressHud];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showInfoWithStatus:title];
    });
    
}

+ (void)showStatus:(NSString *)title {
    [self initLoadingHud];
    [SVProgressHUD showWithStatus:title];
}

+ (void)dismiss {
    [SVProgressHUD dismiss];
}


+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               cancelTitle:(NSString *)cancelTitle {
    
    if (IOS_VERSION >= 9.0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:cancleAction];
    } else {//版本向下兼容
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelTitle otherButtonTitles:nil, nil];
        [alert show];
    }
}

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               cancelTitle:(NSString *)cancelTitle
        fromViewController:(UIViewController *)viewController {
    if (IOS_VERSION >= 9.0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [viewController presentViewController:alert animated:YES completion:nil];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:cancleAction];
    } else {//版本向下兼容
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelTitle otherButtonTitles:nil, nil];
        [alert show];
    }
}
@end
