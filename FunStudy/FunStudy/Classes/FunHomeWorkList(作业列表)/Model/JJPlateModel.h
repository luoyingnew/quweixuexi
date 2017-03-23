//
//  JJPlateModel.h
//  FunStudy
//
//  Created by 唐天成 on 2017/1/10.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJTopicModel.h"

@interface JJPlateModel : NSObject

//版块名称
@property (nonatomic, strong) NSString *plate_name;
//板块id
@property (nonatomic, strong) NSString *plate_id;

//homeworkid(这个是用于补作业时才需要用到的)
@property (nonatomic, strong) NSString *homework_id;
//topicModelArray(这个是当最新作业最新测验的时候用的)
@property (nonatomic, strong) NSMutableArray<JJTopicModel *> *topicDictArray;



//将服务器返回的JSON数组转为自己的模型数组,(原因:没办法)
+(NSArray *)plateModelArrayWithDictArray:(NSArray *)array;

@end
