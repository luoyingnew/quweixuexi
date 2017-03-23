//
//  JJWordSpellingView.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/23.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJWordSpellingModel.h"
#import "JJProgressView.h"
#import "JJBilingualResultModel.h"

typedef void(^PlayAudioBlock)(void);

@interface JJWordSpellingView : UIView

@property (nonatomic, strong) JJWordSpellingModel *model;
@property (nonatomic, strong) JJBilingualResultModel *resultModel;


@property (nonatomic, copy) PlayAudioBlock playAudioBlock;


//进度条
//@property (nonatomic, strong) JJProgressView *progressView;
//单词字母Label数组
@property (nonatomic, strong) NSMutableArray<UILabel *> *wordLetterArray;
//可选字母Button数组
@property (nonatomic, strong) NSMutableArray<UIButton *> *chooseBtnArray;
//单词字母抽空数组
@property (nonatomic, strong) NSMutableArray<NSString *> *spaceLetterArray;
//底部待选字母数组
@property (nonatomic, strong) NSMutableArray<NSString *> *chooseLetterArray;

@end
