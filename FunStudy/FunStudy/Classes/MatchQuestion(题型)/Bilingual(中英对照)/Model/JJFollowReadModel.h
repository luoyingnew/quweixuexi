//
//  JJFollowReadModel.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/25.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJFollowReadModel : NSObject
//英文
@property (nonatomic, strong) NSString *topic_text;
//中文翻译
@property (nonatomic, strong) NSString *translateCHinese;
//id
@property (nonatomic, strong) NSString *unit_id;
//英文读音
@property (nonatomic, strong) NSString *file_video;
//得分
@property (nonatomic, assign) CGFloat score;
//大题描述
@property (nonatomic, strong) NSString *topic_title;

//homeworkId   主要是为了存储音频时和unit_id拼起来变成唯一标示
@property (nonatomic, strong) NSString *homeworkID;


@property (nonatomic, strong) NSString  *lastURL;

@end
