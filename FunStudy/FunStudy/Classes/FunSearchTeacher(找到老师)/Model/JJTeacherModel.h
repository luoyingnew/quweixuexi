//
//  JJTeacherModel.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJClassModel.h"

@interface JJTeacherModel : NSObject
//教师id
@property (nonatomic, strong) NSString *teacher_id;
//教师的班级数组
@property (nonatomic, strong) NSArray<JJClassModel *> *class_list;

//老师名称
@property (nonatomic, strong) NSString *nicename;
//老师编号
@property (nonatomic, strong) NSString *user_code;

@end
