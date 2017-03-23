//
//  JJAudioRecorderTool.m
//  FunStudy
//
//  Created by 唐天成 on 2017/1/10.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import "JJAudioRecorderTool.h"
#import <AVFoundation/AVFoundation.h>

@interface JJAudioRecorderTool ()

//录音器
@property (nonatomic, strong) AVAudioRecorder *recorder;

@property (strong, nonatomic) dispatch_source_t timer;//定时器

@property (assign, nonatomic) CGFloat currentrecordTime;// 当前录音时间

@property (assign, nonatomic) CGFloat maxTime;// 允许录音的最长时间

@property (nonatomic, assign) CGFloat interval;// 时间间隔

@end

@implementation JJAudioRecorderTool

+(instancetype)shareAudioRecorderTool {
    static dispatch_once_t onceToken;
    static JJAudioRecorderTool *audioRecorderTool;
    dispatch_once(&onceToken, ^{
        audioRecorderTool = [[JJAudioRecorderTool alloc]init];
    });
    return audioRecorderTool;
}

//开始录音
- (void)startRecordWithDestinationPath:(NSString *)path MaxTime:(NSTimeInterval)maxTime timeInterval:(NSTimeInterval)interval block:(TimeActionBlock)block {
    self.maxTime = maxTime;
    self.currentrecordTime = 0.0;
    self.interval = interval;
    if(![self canRecord]){
        DebugLog(@"还没同意");
        return;
    }
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if (session == nil) {
        DebugLog(@"Error creating session: %@",[sessionError description]);
    }else{
        [session setActive:YES error:nil];
        DebugLog(@"fdsfs");
    }
    //设置录音的参数
    NSDictionary *settingRecorder = @{
                                      AVEncoderAudioQualityKey : [NSNumber numberWithInteger:AVAudioQualityHigh],
                                      AVEncoderBitRateKey : [NSNumber numberWithInteger:16],
                                      AVSampleRateKey : [NSNumber numberWithFloat:8000],
                                      AVNumberOfChannelsKey : [NSNumber numberWithInteger:2],
                                      };
    // 5.创建录音对象
    self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:path] settings:settingRecorder error:nil];
    [self.recorder prepareToRecord];
    [self.recorder record];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), interval * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
//        DebugLog(@"%@",[NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.currentrecordTime += self.interval;
            if (self.currentrecordTime > self.maxTime) {
                [self.recorder stop];
                dispatch_source_cancel(_timer);
            }
            if(block) {
                block(self.currentrecordTime, self.maxTime);
            }
        });
    });
    dispatch_resume(_timer);
}
//停止录音
- (void)stopRecordWithBlock:(RecordOverBlock)block {
    if(![self canRecord]){
        DebugLog(@"还没同意");
        return;
    }
    [self.recorder stop];
    dispatch_source_cancel(_timer);
    if(block) {
        block(self.currentrecordTime, self.maxTime);
    }
    self.currentrecordTime = 0.0;
}


#pragma mark - 判断是否允许使用麦克风7.0新增的方法requestRecordPermission
-(BOOL)canRecord
{
    __block BOOL bCanRecord = NO;
    if ([[UIDevice currentDevice] systemVersion].doubleValue >= 7.0)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                }
                else {
                    bCanRecord = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:nil
                                                    message:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"
                                                   delegate:nil
                                          cancelButtonTitle:@"关闭"
                                          otherButtonTitles:nil] show];
                    });
                }
            }];
        }
    }
    return bCanRecord;
}

@end
