//
//  JJMyCoinModel.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/29.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJMyCoinModel : NSObject

@property (nonatomic, strong) NSString  *reason;//原因
@property (nonatomic, assign) NSInteger number;//数量
@property(nonatomic,assign)BOOL is_done;
@property (nonatomic, strong) NSString *createtime;//时间戳


@end
