//
//  JJTopicModel.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/23.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TopicType) {
    ListenType = 1,//听力
    SingleChooseType,//单项选择
    ClozeProcedureType,//完型填空
    ReadType,//阅读理解
    TranslateType,//翻译
    ErrorCorrectType,//改错
    WriteType,//作文
    WordSpellingType,//单词拼写
    FollowReadType,//跟读
    ReadWordType,//朗读
    BilingualType,//中英对照
    WordFollowReadType,//单词跟读
    WordSpellingTypeSecond,//单词拼写
    BilingualTypeSecond,//英汉对照
    ArticleFollowReadType,//全文跟读
    ArticalReadWordType//全文朗读
};

@interface JJTopicModel : NSObject

@property(nonatomic,assign)BOOL isSelfStudy;//是否是自学中心跳转的
@property (nonatomic, strong) NSString *homework_id;//作业id
@property (nonatomic, strong) NSString *topics_id;//大题ID
@property(nonatomic,assign)TopicType type;//大题类型
@property(nonatomic,assign)BOOL is_done;//是否已经完成
@property (nonatomic, strong) NSString *topic_title;//大题描述


@property(nonatomic,assign)NSInteger index;//在大题列表中处于第几个

@end
