//
//  JJFunLessionModel.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/16.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJFunLessionModel : NSObject

@property (nonatomic, strong) NSString *book_id;

@property (nonatomic, strong) NSString *unit_title;
@property (nonatomic, strong) NSString *unit_id;
@property (nonatomic, assign) BOOL is_homework;//是否有作业
@property(nonatomic,assign)BOOL has_words;//是否有单元单词
@property(nonatomic,assign)NSInteger homework_type;//小学或初中作业， 1或2，
@property(nonatomic,assign)BOOL is_done;// 是否在自学中心做完改作业

@end
