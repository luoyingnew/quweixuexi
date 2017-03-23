
//


#import "User.h"
#import "HFNetWork.h"
#import "MJExtension.h"
#import "JPUSHService.h"

@implementation User

+(NSDictionary*)mj_replacedKeyFromPropertyName{
    return @{@"last_new_homeworkID":@"new_homework", @"last_new_testID" : @"new_test", @"last_new_homework_title" : @"new_homework_title", @"last_new_test_title" : @"new_test_title"};
}

//用了MJExtension
//写上下面这句后直接就能自定义对象归档解档了,也就是可以变成2进制了
MJCodingImplementation

//- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    if ([key isEqualToString:@"id"]) {
//        self.userId = value;
//    }
//}

//- (NSString *)description {
//    return [NSString stringWithFormat:@"%@, %@", self.nickname, self.avatar];
//}

+ (void)saveUserInformation:(User *)user {
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:saveUserInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    //发出通知登录状态发生改变
//    [[NSNotificationCenter defaultCenter]postNotificationName:SignInTypeChangeNotification object:nil];
    
}

+ (User *)getUserInformation {
    
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:saveUserInfo];
    if (!userData) {
        return nil;
    }
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
    return user;
}

+ (void)removeUserInformation {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:saveUserInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //设置一个错误的别名
    [self networkDidSetup];
//    [[NSNotificationCenter defaultCenter]postNotificationName:SignInTypeChangeNotification object:nil];
}
#pragma mark -- 极光推送回调方法   退出登录的时候给一个空的别名
+ (void)networkDidSetup
{
    // 获取当前用户id，上报给极光，用作别名
    User *user = [User getUserInformation];
    //针对设备给极光服务器反馈了别名，app服务端可以用别名来针对性推送消息
    [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        DebugLog(@"极光推送错误码+++++++：%d", iResCode);
        
        if (iResCode == 0) {
            DebugLog(@"极光推送：设置别名成功, 别名：%@", user.fun_user_id);
        }
    }];
}

- (NSString *)userId{
    if(_fun_user_id == nil){
        _fun_user_id = @"";
    }
    return _fun_user_id;
}
@end
