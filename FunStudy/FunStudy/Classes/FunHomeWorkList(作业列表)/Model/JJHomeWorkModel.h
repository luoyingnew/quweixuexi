//
//  JJHomeWorkModel.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/23.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJHomeWorkModel : NSObject
//作业id
@property (nonatomic, strong) NSString *homework_id;
//作业名字
@property (nonatomic, strong) NSString *homework_title;
//作业大题数量
@property (nonatomic, assign) NSInteger topics_count;

+ (instancetype)modelWithDict:(NSDictionary *)dict ;

@end
