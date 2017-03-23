//
//  JJFunTrackModel.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/30.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JJFunTrackType){
    JJFunTrackHomework = 1,//作业
    JJFunTrackTest = 2,//测验
};

typedef NS_ENUM(NSInteger, JJFunTrackOverType){
    JJFunTrackOverYES = 1,//已完成
    JJFunTrackOverNO = 2,//未完成
};


@interface JJFunTrackModel : NSObject

@property (nonatomic, strong) NSString *title;//教材名称
@property (nonatomic, strong) NSString *endtime;//结束时间
@property (nonatomic, strong) NSString *score;//分数
@property (nonatomic, strong) NSString *teacher_comments;//分数评语
@property (nonatomic, assign) JJFunTrackOverType status;//作业完成状态
@property (nonatomic, strong) NSString *homework_exam_id;//这个是作业或测验的id
@property (nonatomic, strong) NSString *eh_id;//学生完成作业记录id
@property (nonatomic, assign) JJFunTrackType eh_type;//作业还是测验

@end
