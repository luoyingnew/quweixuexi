//
//  JJLessionWordModel.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJWordModel : NSObject
//单词音频路径
@property (nonatomic, strong) NSString *audio;
//单词
@property (nonatomic, strong) NSString *word;
//翻译
@property (nonatomic, strong) NSString *translation;

//是否怎在播放
@property(nonatomic,assign)BOOL isPlay;
//是否显示中文
@property(nonatomic,assign)BOOL isDisplayChinese;
@end
