//
//  JJWordSpellingModel.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/22.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJBilingualResultModel.h"

@interface JJWordSpellingModel : NSObject
@property (nonatomic, strong) NSString *option_right;//中文
@property (nonatomic, strong) NSString *word;//单词
@property (nonatomic, strong) NSString *file_video;//音频路径
@property (nonatomic, strong) NSString *unit_id; //id
@property (nonatomic, strong) NSString *myAnswer;
@property(nonatomic,assign)BOOL isRight;//表示做完后的题是否正确
//大题描述
@property (nonatomic, strong) NSString *topic_title;


+ (JJWordSpellingModel *)modelWithDictionary:(NSDictionary *)dic;

////是否已经展示过
//@property(nonatomic,assign)BOOL isDisplay;

@end
