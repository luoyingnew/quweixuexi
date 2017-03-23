//
//  JJUnitModel.h
//  FunStudy
//
//  Created by 唐天成 on 2017/1/10.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJPlateModel.h"

@interface JJUnitModel : NSObject

//单元名称
@property (nonatomic, strong) NSString *unit_title;
//作业id
@property (nonatomic, strong) NSString* homework_id;



////板块数组
//@property (nonatomic, strong) NSMutableArray<JJPlateModel *> *plateDictArray;
//
////将服务器返回的JSON数组转为自己的模型数组,(原因:没办法)
//+(NSArray *)unitModelArrayWithDictArray:(NSArray *)array;

@end
