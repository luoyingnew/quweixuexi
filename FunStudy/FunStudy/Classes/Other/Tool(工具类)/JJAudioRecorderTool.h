//
//  JJAudioRecorderTool.h
//  FunStudy
//
//  Created by 唐天成 on 2017/1/10.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

//录音时间间隔内做的回调事件
typedef void(^TimeActionBlock)(NSTimeInterval currentTime,NSTimeInterval maxTime);
//录音结束回调事件
typedef void(^RecordOverBlock)(NSTimeInterval currentTime,NSTimeInterval maxTime);


@interface JJAudioRecorderTool : NSObject

//单粒
+(instancetype)shareAudioRecorderTool;

/**
 开始录音

 @param path 音频存放地址
 @param maxTime 录音最大时间
 @param interval 录音间隔Timer
 @param block Timer执行事件
 */
- (void)startRecordWithDestinationPath:(NSString *)path MaxTime:(NSTimeInterval)maxTime timeInterval:(NSTimeInterval)interval block:(TimeActionBlock)block;

/**
 停止录音
 
 @param block 停止录音回调
 */
- (void)stopRecordWithBlock:(RecordOverBlock)block;
@end
