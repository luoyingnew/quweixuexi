//
//  NetWorkChecker.m
//  HiFun
//
//  Created by attackt on 16/7/28.
//  Copyright © 2016年 attackt. All rights reserved.
//

#import "NetWorkChecker.h"
@interface NetWorkChecker () {
    NetworkStatus _networkStatus;
}
@property (nonatomic, strong) Reachability *internetReach;


@end
@implementation NetWorkChecker

+ (NetWorkChecker *)shareInstance {
    static NetWorkChecker *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NetWorkChecker alloc] init];
    });
    return instance;
}

- (NetworkStatus)networkStatus {
    if (!_internetReach) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        _internetReach = [Reachability reachabilityForInternetConnection];
        [_internetReach startNotifier];
        _networkStatus = [self.internetReach currentReachabilityStatus];
    }
    
    switch ([_internetReach currentReachabilityStatus]) {
        case NotReachable:
            DebugLog(@"不能访问");
            _networkStatus = NotReachable;
            break;
        case ReachableViaWiFi:
            DebugLog(@"使用wifi访问");
            _networkStatus = ReachableViaWiFi;
            break;
        case ReachableViaWWAN:
            DebugLog(@"使用3G/4G访问");
            _networkStatus = ReachableViaWWAN;
            break;
        default:
            break;
    }
    return _networkStatus;
}

- (void)reachabilityChanged:(NSNotification *)notification {
    Reachability *curReachability = [notification object];
    NSParameterAssert([curReachability isKindOfClass:[Reachability class]]);
    NetworkStatus curStatus = [curReachability currentReachabilityStatus];
    BOOL notificationNetworkChange = [[NSUserDefaults standardUserDefaults]boolForKey:isNoticNetWork];
    switch (curStatus) {
        case NotReachable:
            _networkStatus = NotReachable;
            DebugLog(@"无网络");
            if(notificationNetworkChange) {
            [JJHud showToast:@"当前无网络"];
            }
            break;
        case ReachableViaWiFi:
            _networkStatus = ReachableViaWiFi;
            DebugLog(@"使用wifi网络");
            if(notificationNetworkChange) {
//            [JJHud showToast:@"当前使用wifi"];
            }
            break;
        case ReachableViaWWAN:
            _networkStatus = ReachableViaWWAN;
            DebugLog(@"使用3G/4G网络");
            if(notificationNetworkChange) {
            [JJHud showToast:@"当前使用3G/4G网络"];
            }
            break;
            
        default:
            break;
    }
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
