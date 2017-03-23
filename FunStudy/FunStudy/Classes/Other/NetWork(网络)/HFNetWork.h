//
//  HFNetWork.h
//  HiFun
//
//  Created by attackt on 16/7/29.
//  Copyright © 2016年 attackt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

/**
 请求方法的枚举值
 */
typedef NS_ENUM(NSInteger, HTTPMethod) {
    HFRequestGET,
    HFRequestPOST,
    HFRequestPOSTUpload,
    HFRequestGETDownload
};
@class NSURLSessionTask;
typedef NSURLSessionTask HFURLSessionTask;

typedef void (^HFResponseSuccessBlock)(id response);
typedef void (^HFResponseFailureBlock)(NSError *error);
typedef void (^HFProgress)(NSProgress *progress);

@interface HFNetWork : NSObject

+ (AFHTTPSessionManager *)AFHTTPSessionManager;

/**
 *  GET 请求
 *
 *  @param url     URL
 *  @param params  请求参数
 *  @param isCache 是否使用缓存
 *  @param success 请求成功的回调
 *  @param fail    请求失败的回调
 *
 *  @return 有可能取消的API
 */
+ (HFURLSessionTask *)getWithURL:(NSString *)url
                          params:(NSDictionary *)params
                         isCache:(BOOL)isCache
                         success:(HFResponseSuccessBlock)success
                            fail:(HFResponseFailureBlock)fail;

/**
 *  POST请求
 *
 *  @param url     URL
 *  @param token   token, 根据后台需求填写token或nil
 *  @param params  请求参数
 *  @param isCache 是否使用缓存数据
 *  @param success 请求成功的回调
 *  @param fail    请求失败的回调
 *
 *  @return 有可能取消的API
 */
+ (HFURLSessionTask *)postWithURL:(NSString *)url
                           params:(NSDictionary *)params
                          isCache:(BOOL)isCache
                          success:(HFResponseSuccessBlock)success
                             fail:(HFResponseFailureBlock)fail;



/**
 下载

 // @param url      URL
 // @param params   请求参数
 // @param progress 是否使用缓存数据
 //@param progress 进度
 

 @return 可能取消的api
 */
+ (HFURLSessionTask *)downLoadWithURL:(NSString *)url
                      destinationPath:(NSString *)path
                               params:(NSDictionary *)params
                             progress:(HFProgress)progress;

///**
//  图片上传进度的控制
//
// @param url      URL
// @param params   请求参数
// @param progress 是否使用缓存数据
// @param success  请求成功的回调
// @param fail     请求失败的回调
//
// @return 有可能取消的API
// */
//+ (HFURLSessionTask *)uploadImageWithURL:(NSString *)url
//                                  params:(NSDictionary *)params
//                                progress:(HFProgress)progress
//                                 success:(HFResponseSuccessBlock)success
//                                    fail:(HFResponseFailureBlock)fail;

/**
 *  取消特定URL的请求
 *
 *  @param url URL字符串
 */
+ (void)cancelRequestWithURL:(NSString *)url;

/**
 *  取消所有请求
 */
+ (void)cancelAllRequest;

/**
 *  请求超时设定
 *
 *  @param timeInterval 超时时间
 */
+ (void)setTimeOut:(NSTimeInterval)timeInterval;
@end
