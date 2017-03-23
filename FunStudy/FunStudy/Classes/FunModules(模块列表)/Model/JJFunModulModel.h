//
//  JJFunModulModel.h
//  FunStudy
//
//  Created by 唐天成 on 2017/1/5.
//  Copyright © 2017年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJWordModel.h"

@interface JJFunModulModel : NSObject

@property (nonatomic, strong) NSString *plate_id;
@property (nonatomic, strong) NSString* plate_name;


@property (nonatomic, strong) NSArray<JJWordModel *> *word_list;

@end
