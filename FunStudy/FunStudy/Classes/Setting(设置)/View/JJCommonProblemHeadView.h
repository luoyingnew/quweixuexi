//
//  JJCommonProblemHeadView.h
//  FunStudy
//
//  Created by 唐天成 on 2016/12/2.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJCommonProblemModel.h"


//typedef void(^MoreQuestionBlock)(void);

@interface JJCommonProblemHeadView : UIView

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) JJCommonProblemModel *model;

//@property (nonatomic, copy) MoreQuestionBlock block;

@end
