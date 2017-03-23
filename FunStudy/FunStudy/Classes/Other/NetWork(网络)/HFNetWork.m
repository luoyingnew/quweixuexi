//
//  HFNetWork.m
//  HiFun
//
//  Created by attackt on 16/7/29.
//  Copyright © 2016年 attackt. All rights reserved.
//

#import "HFNetWork.h"

#import "NetWorkChecker.h"
#import "YYCache.h"
#import "JJLoginOrSignUpViewController.h"
#import "JJNavigationController.h"

//static NSInteger i = 0;

@interface HFNetWork ()

@end


@implementation HFNetWork
//NSString *const hf_httpRequestKey = @"hf_httpRequestKey";
static NSMutableArray *hf_requestTasks;
static NSTimeInterval hf_timeout = 15.f;


#pragma mark Priviate -- Methods
+ (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hf_requestTasks = [[NSMutableArray alloc] init];
    });
    
    return hf_requestTasks;

}

// 字符串中含有中文字符的判断
+ (BOOL)isContainChineseStr:(NSString *)string {
    for(int i = 0;i < [string length];i++) {
        int a =[string characterAtIndex:i];
        if( a >0x4e00 && a <0x9fff) {
            return YES;
        }
    }
    return NO;
}

//网络实时状态的判断
+ (BOOL)isNetWorkEnable {
    BOOL isNetWorkEnable = [[NetWorkChecker shareInstance] networkStatus];
    return isNetWorkEnable;
}

//对URL含有中文的进行中文编码
+ (NSString *)hf_URLEncoding:(NSString *)url {
    if ([self isContainChineseStr:url]) {
        return [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    return url;
}


+ (AFHTTPSessionManager *)AFHTTPSessionManager {
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [httpManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [httpManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    User *user = [User getUserInformation];
    if(!(user.token == nil || [user.token isEqualToString:@""])){
        NSString *token = [NSString stringWithFormat:@"JWT %@",user.token];
        //        NSString *token = [NSString stringWithFormat:@"%@",user.token];
        [httpManager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    }
    httpManager.requestSerializer.timeoutInterval = hf_timeout; //请求超时设定
    httpManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    httpManager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    httpManager.securityPolicy = [[AFSecurityPolicy alloc] init];
    httpManager.securityPolicy.allowInvalidCertificates = YES;
    httpManager.securityPolicy.validatesDomainName = NO;
    httpManager.operationQueue.maxConcurrentOperationCount = 4;
    return httpManager;
}


+ (HFURLSessionTask *)requestWithHttpMethod:(HTTPMethod)httpMethod
                                  URLString:(NSString *)url
                                   progress:(HFProgress)progress
                                     params:(NSDictionary *)params
                                    isCache:(BOOL)isCache
                                   cacheKey:(NSString *)cacheKey
                               successBlock:(HFResponseSuccessBlock)success
                               failureBlock:(HFResponseFailureBlock)failure {
    
//    //先处理缓存问题
    YYCache *cache = [[YYCache alloc] initWithName:hf_httpRequestKey];
    cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    id cacheData;
    if (isCache) {
        cacheData = [cache objectForKey:cacheKey];
        if (cacheData) {
            success(cacheData);
            return nil;
        }
    }
    
    //如果没有缓存，则走正常的网络请求步骤
    if (![self isNetWorkEnable]) {
        
    }
    if (url) {
      url = [self hf_URLEncoding:url];
    }
    AFHTTPSessionManager *sessionManager = [self AFHTTPSessionManager];
    
    HFURLSessionTask *sessionTask = nil;
    if (httpMethod == HFRequestGET) {
        
          sessionTask = [sessionManager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              [[self allTasks] removeObject:task];
              if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
                  [self objectWithJSONData:responseObject];
              }
              
              //如果token登录过期
              NSString *tokExpiredString = responseObject[@"detail"];
              if(tokExpiredString.length != 0) {
                  [JJHud dismiss];
                  //先退出登录
                  [User removeUserInformation];
                  JJLoginOrSignUpViewController *loginOrSignUpVC = [[JJLoginOrSignUpViewController alloc]init];
                  JJNavigationController *loginOrSignUpViewController = [[JJNavigationController alloc]initWithRootViewController:loginOrSignUpVC];
                  loginOrSignUpViewController.navigationBarHidden = YES;
                  [UIApplication sharedApplication].keyWindow.rootViewController = loginOrSignUpViewController;
                  return;
              }
              
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[self allTasks] removeObject:task];
            failure(error);
        }];
    } else if (httpMethod == HFRequestPOST) {
        sessionTask = [sessionManager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [[self allTasks] removeObject:task];
             if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
                 [self objectWithJSONData:responseObject];
             }
            //如果token登录过期
            NSString *tokExpiredString = responseObject[@"detail"];
//            i++;
//            if(i == 10) {
//                tokExpiredString = @"dsfdsfs";
//            }
            if(tokExpiredString.length != 0) {
                [JJHud dismiss];
                //先退出登录
                [User removeUserInformation];
                JJLoginOrSignUpViewController *loginOrSignUpVC = [[JJLoginOrSignUpViewController alloc]init];
                JJNavigationController *loginOrSignUpViewController = [[JJNavigationController alloc]initWithRootViewController:loginOrSignUpVC];
                loginOrSignUpViewController.navigationBarHidden = YES;
                [UIApplication sharedApplication].keyWindow.rootViewController = loginOrSignUpViewController;
                return;
            }
            
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[self allTasks] removeObject:task];
            failure(error);
        }];
    } else if (httpMethod == HFRequestPOSTUpload) {
        sessionTask = [sessionManager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            progress ? progress (uploadProgress):nil;
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [[self allTasks] removeObject:task];
            if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
                [self objectWithJSONData:responseObject];
            }
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[self allTasks] removeObject:task];
            failure(error);
        }];
    }
//    else if(httpMethod == HFRequestGETDownload){
//        NSURL *urll = [NSURL URLWithString:url];
//        NSURLRequest *request = [NSURLRequest requestWithURL:urll];
//        sessionTask = [sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//            progress ? progress (downloadProgress):nil;
//        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//            NSLog(@"sa");
//            return [NSURL fileURLWithPath:@"/Users/tangtiancheng/Desktop/ProjectGitLab/3.mp4"];
//        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//            NSLog(@"sb下载好啦");
//        }];
//        [sessionTask resume];
//    }
    if (sessionTask) {
        [[self allTasks] addObject:sessionTask];
    }
    return sessionTask;
}

/**
 *  NSData转为json数据
 */
+ (nullable id)objectWithJSONData:(nonnull NSData *)JSONData {
    NSError *error;
    id JSONObject = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:&error];
    return JSONObject;
}


#pragma mark Public -- Methods
+ (HFURLSessionTask *)getWithURL:(NSString *)url
                          params:(NSDictionary *)params
                         isCache:(BOOL)isCache
                         success:(HFResponseSuccessBlock)success
                            fail:(HFResponseFailureBlock)fail {
    NSString *cacheKey = url;
    return [self requestWithHttpMethod:HFRequestGET
                             URLString:url
                              progress:nil
                                params:params
                               isCache:isCache
                              cacheKey:cacheKey
                          successBlock:success
                          failureBlock:fail];
}


+ (HFURLSessionTask *)postWithURL:(NSString *)url
                           params:(NSDictionary *)params
                          isCache:(BOOL)isCache
                          success:(HFResponseSuccessBlock)success
                             fail:(HFResponseFailureBlock)fail {
    NSString *cacheKey = url;
    return [self requestWithHttpMethod:HFRequestPOST
                             URLString:url
                              progress:nil
                                params:params
                               isCache:isCache
                              cacheKey:cacheKey
                          successBlock:success
                          failureBlock:fail];
}



+ (HFURLSessionTask *)downLoadWithURL:(NSString *)url
                      destinationPath:(NSString *)path
                               params:(NSDictionary *)params
                             progress:(HFProgress)progress{
//    return
    //如果没有缓存，则走正常的网络请求步骤
    if (![self isNetWorkEnable]) {
        
    }
    if (url) {
        url = [self hf_URLEncoding:url];
    }
    AFHTTPSessionManager *sessionManager = [self AFHTTPSessionManager];
    HFURLSessionTask *sessionTask = nil;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    sessionTask = [sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        progress ? progress (downloadProgress):nil;
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSLog(@"sa");
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            DebugLog(@"下载发生错误");
        } else {
            DebugLog(@"sb下载好啦");
        }
//        [[self allTasks] removeObject:sessionTask];

    }];
    [sessionTask resume];
//    if (sessionTask) {
//        [[self allTasks] addObject:sessionTask];
//    }
    return sessionTask;
}


////进度log信息 NSLog(@"进度为:%.2f%%",100.0*progress.completedUnitCount/progress.totalUnitCount);
//+ (HFURLSessionTask *)uploadImageWithURL:(NSString *)url
//                                  params:(NSDictionary *)params
//                                progress:(HFProgress)progress
//                                 success:(HFResponseSuccessBlock)success
//                                    fail:(HFResponseFailureBlock)fail{
//    return [self requestWithHttpMethod:HFRequestPOSTUpload
//                             URLString:url
//                              progress:progress
//                                params:params
//                               isCache:NO
//                              cacheKey:nil
//                          successBlock:success
//                          failureBlock:fail];
//    
//}

+ (void)cancelAllRequest {
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(HFURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[HFURLSessionTask class]]) {
                [task cancel];
            }
        }];
        [[self allTasks] removeAllObjects];
    }
}

+ (void)cancelRequestWithURL:(NSString *)url {
    if (!url) {
        return;
    }
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(HFURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[HFURLSessionTask class]] && [task.currentRequest.URL.absoluteString hasSuffix:url]) {
                [task cancel];
                [[self allTasks] removeObject:task];
                return ;
            }
        }];
    }
}

+ (void)setTimeOut:(NSTimeInterval)timeInterval {
    hf_timeout = timeInterval;
}
@end
