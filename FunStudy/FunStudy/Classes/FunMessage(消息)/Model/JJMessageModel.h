//
//  JJMessageModel.h
//  FunStudy
//
//  Created by 唐天成 on 2016/12/13.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJMessageModel : NSObject

//@property (nonatomic, strong) NSString *introduction;//简介
//@property (nonatomic, strong) NSString *eh_id;//作业id
@property (nonatomic, strong) NSString *title;//标题展示
@property(nonatomic,assign)BOOL is_exam_homework;//是否是布置的作业或测验
@property(nonatomic,strong)NSArray<NSString *> *detail_list;

@property (nonatomic, strong) NSString *detailALlString;


//@property (nonatomic, strong) NSString *topic;//教材名称
//@property (nonatomic, strong) NSString *teacher;//老师名称
//@property (nonatomic, assign) NSInteger push_type;// # 消息类型  作业(1)or测验(2)
@property (nonatomic, strong) NSString *createtime;//截止时间
//@property(nonatomic,assign)BOOL is_done;//作业是否已经做完

@end
