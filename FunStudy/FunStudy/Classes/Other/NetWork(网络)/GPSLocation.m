//
//  GPSLocation.m
//  Chocolate
//
//  Created by lwb on 2016/10/18.
//  Copyright © 2016年 北京进击科技有限公司. All rights reserved.
//

#import "GPSLocation.h"
#import <CoreLocation/CoreLocation.h>

@interface GPSLocation()<CLLocationManagerDelegate>
@property (nonatomic, strong)CLLocationManager *locationManager;
@end


@implementation GPSLocation


#pragma mark Public - method
+ (GPSLocation *)shareInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)setupLocationManager{ // 主要用来获取当前定位的城市
    if (![self locationServicesEnabled]) {
        [self showAlert];
        return;
    }
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    if (IOS_VERSION >= 8.0) {
        [_locationManager requestWhenInUseAuthorization];//使用中授权
    }
    _locationManager.distanceFilter = 10.0;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    if (IOS_VERSION >= 9.0) {
        _locationManager.allowsBackgroundLocationUpdates = YES;
        [_locationManager requestLocation];
    } else {
        [_locationManager startUpdatingLocation];
    }
}

- (void)stopUpdateLocations {
    [_locationManager stopUpdatingLocation];
}

#pragma mark priviate methods
- (UIAlertController *)creatAlertController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"alertTitle_alert", "提醒") message:NSLocalizedString(@"alertMessage_locaton", "定位服务未打开") preferredStyle:UIAlertControllerStyleAlert];
    return alertController;
}

- (UIAlertView *)creatAlertView {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alertTitle_alert", "提醒")
                                                        message:NSLocalizedString(@"alertMessage_locaton", "定位服务未打开")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"alert_cancel", "取消")
                                              otherButtonTitles:NSLocalizedString(@"alert_open", "去打开"), nil];
    return alertView;
}

- (UIAlertAction *)openSettingsAlertAction {
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_open", "去打开") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self gotoServiceSettings];
    }];
    
    return alertAction;
}


- (UIAlertAction *)cancelAlertAction {
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_cancel", "取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    return alertAction;
}

- (void)showAlert {
    if (IOS_VERSION < 9.0) {
        UIAlertView *alertView = [self creatAlertView];
        [alertView show];
    } else {
        UIAlertController *alertController = [self creatAlertController];
        [alertController addAction:[self cancelAlertAction]];
        [alertController addAction:[self openSettingsAlertAction]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)gotoServiceSettings { //进入系统设置页面
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }

}

- (BOOL)locationServicesEnabled {
    if (([CLLocationManager locationServicesEnabled]) && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
        return YES;
    } else {
        return NO;
    }
}


#pragma mark CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //获取更新后的位置信息
    CLLocation *location = [locations lastObject];
    _latitude = location.coordinate.latitude;
    _longitude = location.coordinate.longitude;
    [_locationManager stopUpdatingLocation];
 }

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    DebugLog(@"locationManager %@ :定位失败", error);
}


#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self gotoServiceSettings];
    }
}



@end
