//
//  JJRankModel.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/16.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJRankModel : NSObject
//用户名
@property (nonatomic, copy) NSString *user_name;
//学号
@property (nonatomic, copy) NSString *user_code;
//头像
@property (nonatomic, copy) NSString *avatar;
//金币
@property (nonatomic, assign) NSInteger user_coin;
//状元榜或智慧版
@property(nonatomic,assign)BOOL isRankTopScore;
@end
