//
//  CKLClearCache.m
//  Chocolate
//
//  Created by hao on 16/11/14.
//  Copyright © 2016年 北京进击科技有限公司. All rights reserved.
//

#import "JJClearCache.h"

@implementation JJClearCache
#pragma mark -- 公开方法
/**
 计算缓存大小
 
 @return 返回格式化缓存大小
 */
+ (NSString *)calculateCaches {
    // 计算document下文件大小
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSInteger documentCaches = [self calculateCacheSizeWithFilePath:documentPath];
    // 计算library下文件大小
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSInteger libraryCaches = [self calculateCacheSizeWithFilePath:libraryPath];
    // 总文件大小
    NSInteger totalCaches = documentCaches + libraryCaches;
    // 将文件夹大小转换为 M/KB/B
    NSString *totalCachesStr = nil;
    
    if (totalCaches > 1000 * 1000){
        totalCachesStr = [NSString stringWithFormat:@"%.2fM",totalCaches / 1000.00f /1000.00f];
        
    }else if (totalCaches > 1000){
        totalCachesStr = [NSString stringWithFormat:@"%.2fKB",totalCaches / 1000.00f ];
        
    }else{
        totalCachesStr = [NSString stringWithFormat:@"%.2fB",totalCaches / 1.00f];
    }
    return totalCachesStr;
}

/**
 清除缓存
 
 @return YES:成功；NO：失败
 */
+ (BOOL)clearCaches {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    BOOL clearDocCachesResult = [self clearCacheWithFilePath:documentPath];
    // 计算library下文件大小
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    BOOL clearLibCachesResult = [self clearCacheWithFilePath:libraryPath];
    if (clearDocCachesResult == YES && clearLibCachesResult == YES) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark -- 私有方法
/**
 获取path路径下文件夹大小
 
 @param path 路径
 
 @return 缓存大小
 */
+ (NSInteger)calculateCacheSizeWithFilePath:(NSString *)path{
    
    // 获取“path”文件夹下的所有文件
    NSArray *subPathArr = [[NSFileManager defaultManager] subpathsAtPath:path];
    
    NSString *filePath  = nil;
    NSInteger totalSize = 0;
    
    for (NSString *subPath in subPathArr){
        
        //  拼接每一个文件的全路径
        filePath =[path stringByAppendingPathComponent:subPath];
        //  是否是文件夹，默认不是
        BOOL isDirectory = NO;
        //  判断文件是否存在
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        
        //  以上判断目的是忽略不需要计算的文件
        if (!isExist || isDirectory || [filePath containsString:@".DS"]){
            // 过滤: 1. 文件夹不存在  2. 过滤文件夹  3. 隐藏文件
            continue;
        }
        
        //  指定路径，获取这个路径的属性
        /**
         attributesOfItemAtPath: 文件夹路径
         该方法只能获取文件的属性, 无法获取文件夹属性, 所以也是需要遍历文件夹的每一个文件的原因
         */
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        
        //  获取每一个文件的大小
        NSInteger size = [dict[@"NSFileSize"] integerValue];
        
        //  计算总大小
        totalSize += size;
    }
    
    return totalSize;
}

/**
 清除path文件夹下缓存大小
 
 @param path 路径
 
 @return 是否清理成功
 */
+ (BOOL)clearCacheWithFilePath:(NSString *)path{
    
    //拿到path路径的下一级目录的子文件夹
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    NSString *filePath = nil;
    
    NSError *error = nil;
    
    for (NSString *subPath in subPathArr)
    {
        filePath = [path stringByAppendingPathComponent:subPath];
        
        //删除子文件夹
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
//        if (error) {
//            return NO;
//        }
    }
    return YES;
}
@end
