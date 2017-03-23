//
//  AppDelegate.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/3.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "AppDelegate.h"
#import "JJTabbarController.h"
#import "JJLoginOrSignUpViewController.h"
#import "JJControllerTool.h"
#import "NetWorkChecker.h"
#import "UIView+viewController.h"
#import "AvoidCrash.h"
#import "IQKeyboardManager.h"
#import "iflyMSC/IFlyMSC.h"
#import "Definition.h"

//sharesdk
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"

//极光
// 引 JPush功能所需头 件
#import "JPUSHService.h"
// iOS10注册APNs所需头 件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max 
#import <UserNotifications/UserNotifications.h> 
#endif

@interface AppDelegate ()<JPUSHRegisterDelegate>

//@property (nonatomic, assign) NSInteger badgeNumber; // 远程通知消息数量

@end

@implementation AppDelegate
////只支持竖屏
//- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
//    return UIInterfaceOrientationMaskPortrait;
//}

//这个方法是UNIversal links的
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [JJHud showToast:@"ewqew"];
        DebugLog(@"userActivity = %@  activityType = %@  title = %@  userInfo = %@",userActivity.webpageURL,userActivity.activityType,userActivity.title,userActivity.userInfo);
    });
    
    return YES;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    DebugLog(@"%@",launchOptions);
    //sgareSDK
    [self setShareSDK];
    //防止奔溃
    [AvoidCrash becomeEffective];
    //键盘上升下降
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //ifly讯飞设置
    [self setIFLY];
    
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    [JJControllerTool chooseController];
    
    //一开始来先创建一个文件目录用于存储音频
    [self createCacheDirectory];
    
#ifdef DEBUG
    //do sth.
    //监听网络状态
    [NetWorkChecker shareInstance];
#else
    //do sth.
#endif
    
    //JPush
    // Required
    // notice: 3.0.0及以后版本注册可以这样写，也可以继续 旧的注册 式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //启动SDK
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHAppKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            DebugLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            DebugLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    //建立连接的时候注册别名
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    //发出通知让首页消息按钮的小红点状态改变
    if([UIApplication sharedApplication].applicationIconBadgeNumber == 0) {
        //如果没有通知
        [[NSNotificationCenter defaultCenter]postNotificationName:JpushMessageHideNotificatiion object:@(NO)];
    } else {
        [[NSNotificationCenter defaultCenter]postNotificationName:JpushMessageHideNotificatiion object:@(YES)];
    }
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [application.keyWindow.rootViewController showAlertWithTitle:@"A" message:@"fsd" cancelTitle:@"确定"];
//    });
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [[UIApplication sharedApplication].keyWindow.rootViewController showAlertWithTitle:@"123" message:@"er" cancelTitle:@"fs"];
//    });
    
    return YES;
}

#pragma mark - shareSDK
- (void)setShareSDK {
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:ShareSDKAppKey
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:WeiboAppKey
                                           appSecret:WeiboAppSecret
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:WeiChatAppId
                                       appSecret:WeiChatAppSecret];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:QQAppId
                                      appKey:QQAppSecret
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    return [ShareSDK handleOpenURL:url wxDelegate:self];
//}
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    return [ShareSDK]
//}
#pragma mark - ifly讯飞设置
- (void)setIFLY {
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_ALL];
    //打开输出在console的log开关
    [IFlySetting showLogcat:YES];
    
    //Appid 是应用的身份信息，具有唯一性，初始化时必须要传入 Appid。
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@", iflyAppID];
    [IFlySpeechUtility createUtility:initString];
}

//注册APNS成功并上报deviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

#pragma mark -- 极光推送回调方法
- (void)networkDidSetup:(NSNotification *)notification
{
    // 获取当前用户id，上报给极光，用作别名
    User *user = [User getUserInformation];
    if(user != nil) {
        //针对设备给极光服务器反馈了别名，app服务端可以用别名来针对性推送消息
        [JPUSHService setTags:nil alias:[NSString stringWithFormat:@"%@", user.fun_user_id] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
//            DebugLog(@"极光推送错误码+++++++：%d", iResCode);
            
            if (iResCode == 0) {
                DebugLog(@"极光推送：设置别名成功, 别名：%@", user.fun_user_id);
            }
        }];
    }
    
}

//收到通知   在前台会收到推送 ios9调用   应用程序在后台时,点击推送消息调用 ios9调用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    DebugLog(@"+++90%@", userInfo);
    // 获取服务器端推送过来的消息数量
    NSInteger i = [[[userInfo objectForKey:@"aps"] valueForKey:@"badge"] integerValue];
    DebugLog(@"还有多少个%ld",i);
//    self.badgeNumber = [[[userInfo objectForKey:@"aps"] valueForKey:@"badge"] integerValue];
    
    if (application.applicationState == UIApplicationStateActive) {
        weakSelf(weakSelf);
        [[UIView currentViewController] showAlertWithTitle:@"推送消息" message:alert cancelBlock:^{
            // 通知消息角标
//            weakSelf.badgeNumber = 0;
        } certainBlock:^{
            [weakSelf handleRemoteNotificaionWithUserInfo:userInfo];
        }];
    }
    // 如果程序在后台和运行状态下
    if (application.applicationState != UIApplicationStateBackground && application.applicationState != UIApplicationStateActive) {
        [self handleRemoteNotificaionWithUserInfo:userInfo];
    }
    /*!
     * @abstract 处理收到的 APNs 消息
     */
    // Required, iOS 7及之后才能用 Support
    // 处理接收到的消息
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [application.keyWindow.rootViewController showAlertWithTitle:@"B" message:@"fsd" cancelTitle:@"确定"];
//    });
    
    
    //如果有通知
    [[NSNotificationCenter defaultCenter]postNotificationName:JpushMessageHideNotificatiion object:@(YES)];
}

//这个后面好像不用了,是ios7和7以前的
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"haha");
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [application.keyWindow.rootViewController showAlertWithTitle:@"C" message:@"fsd" cancelTitle:@"确定"];
//    });
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
//这个是应用程序在前台时 ios10会调用
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
//    UNNotificationRequest *request = notification.request; // 收到推送的请求
//    UNNotificationContent *content = request.content; // 收到推送的消息内容
//    
//    NSNumber *badge = content.badge;  // 推送消息的角标
//    NSString *body = content.body;    // 推送消息体
//    UNNotificationSound *sound = content.sound;  // 推送消息的声音
//    NSString *subtitle = content.subtitle;  // 推送消息的副标题
//    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        DebugLog(@"+++90%@", userInfo);
        // 获取服务器端推送过来的消息数量
//        self.badgeNumber = [[[userInfo objectForKey:@"aps"] valueForKey:@"badge"] integerValue];
        weakSelf(weakSelf);
        [[UIView currentViewController] showAlertWithTitle:@"推送消息" message:alert cancelBlock:^{
            // 通知消息角标
//            weakSelf.badgeNumber = 0;
        } certainBlock:^{
            [weakSelf handleRemoteNotificaionWithUserInfo:userInfo];
        }];

        [JPUSHService handleRemoteNotification:userInfo];
        DebugLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        
    }
    else {
        // 判断为本地通知
//        DebugLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [[UIApplication sharedApplication].keyWindow.rootViewController showAlertWithTitle:@"D" message:@"fsd" cancelTitle:@"确定"];
//    });
    //如果有通知
    [[NSNotificationCenter defaultCenter]postNotificationName:JpushMessageHideNotificatiion object:@(YES)];
}

//这个是应用程序在后台时,点击推送消息调用  ios10会调用
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
//    UNNotificationContent *content = request.content; // 收到推送的消息内容
//    NSNumber *badge = content.badge;  // 推送消息的角标
//    NSString *body = content.body;    // 推送消息体
//    UNNotificationSound *sound = content.sound;  // 推送消息的声音
//    NSString *subtitle = content.subtitle;  // 推送消息的副标题
//    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [self handleRemoteNotificaionWithUserInfo:userInfo];
        [JPUSHService handleRemoteNotification:userInfo];
        DebugLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
    }
    else {
//        // 判断为本地通知
//        DebugLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler();  // 系统要求执行这个方法
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [[UIApplication sharedApplication].keyWindow.rootViewController showAlertWithTitle:@"D" message:@"fsd" cancelTitle:@"确定"];
//    });
//
    //如果有通知
    [[NSNotificationCenter defaultCenter]postNotificationName:JpushMessageHideNotificatiion object:@(YES)];
}





#pragma mark -- 自定义方法
- (void)handleRemoteNotificaionWithUserInfo:(NSDictionary *)userInfo {
    if (userInfo) {
        // 通知消息角标
//        self.badgeNumber = 0;
//        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:self.badgeNumber];
//        [JPUSHService setBadge:self.badgeNumber];
        //发送通知跳回首页
        [[NSNotificationCenter defaultCenter]postNotificationName:POP object:@0 userInfo:nil];
    }
}
#endif
// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

//应用程序从前台进入后台会调用    应用程序从前台到杀死会调用
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // -- 极光推送
    // 将小红点清除
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

//应用程序从后台进入前台会调用
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // -- 极光推送
    // 将小红点清除
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//    [JPUSHService setBadge:0];

    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

//应用程序一启动的时候会调用    引用程序从后台进入前台会调用
- (void)applicationDidBecomeActive:(UIApplication *)application {
 
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


////这个方法是当从应用程序在前台->杀死应用程序   的时候会调用
//
- (void)applicationWillTerminate:(UIApplication *)application {
    // -- 极光推送
    // 将小红点清除
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
}


// 当应用程序接收到内存警告的时候就会调用
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    // 应该在该方法中释放掉不需要的内存
    // 1.停止所有的子线程下载
    [[SDWebImageManager sharedManager] cancelAll];
    // 2.清空SDWebImage保存的所有内存缓存
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}


/**
 *  创建音频缓存目录文件
 */
- (void)createCacheDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:JJAudioCachesDirectory]) {
        [fileManager createDirectoryAtPath:JJAudioCachesDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}
@end
