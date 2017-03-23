//
//  CKLClearCache.h
//  Chocolate
//
//  Created by hao on 16/11/14.
//  Copyright © 2016年 北京进击科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJClearCache : NSObject
/**
 计算缓存大小
 
 @return 返回格式化缓存大小
 */
+ (NSString *)calculateCaches;

/**
 清除缓存
 
 @return YES:成功；NO：失败
 */
+ (BOOL)clearCaches;

/**
 清除path文件夹下缓存大小
 
 @param path 路径
 
 @return 是否清理成功
 */
+ (BOOL)clearCacheWithFilePath:(NSString *)path;
@end
