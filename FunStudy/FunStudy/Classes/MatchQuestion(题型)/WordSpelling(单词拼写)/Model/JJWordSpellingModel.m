//
//  JJWordSpellingModel.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/22.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJWordSpellingModel.h"
#import <ReactiveCocoa.h>

@implementation JJWordSpellingModel
+ (JJWordSpellingModel *)modelWithDictionary:(NSDictionary *)dic {
    JJWordSpellingModel *wordSpellingModel = [[JJWordSpellingModel alloc]init];
    wordSpellingModel.unit_id = dic[@"unit_id"];
    wordSpellingModel.file_video = dic[@"file_video"];
    wordSpellingModel.word = dic[@"topic_text"];
    wordSpellingModel.option_right = dic[@"option_desc"];
    
//    @weakify(wordSpellingModel);
//    [RACObserve(wordSpellingModel, myAnswer)subscribeNext:^(NSString *myAnswer) {
//        @strongify(wordSpellingModel);
//        if([myAnswer isEqualToString:wordSpellingModel.word]) {
//            wordSpellingModel.isRight = YES;
//        } else {
//            wordSpellingModel.isRight = NO;
//        }
//    }];

    return wordSpellingModel;
}

@end
