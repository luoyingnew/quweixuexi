//
//  JJBilingualModel.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/24.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJBilingualModel : NSObject
//中文右
@property (nonatomic, strong) NSString  *option_desc;

//英文左
@property (nonatomic, strong) NSString *topic_text;

//id
@property (nonatomic, strong) NSString *unit_id;

//大题描述
@property (nonatomic, strong) NSString *topic_title;

@end
