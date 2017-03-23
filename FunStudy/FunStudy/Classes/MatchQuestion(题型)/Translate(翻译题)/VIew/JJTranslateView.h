//
//  JJTranslateView.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/21.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJTranslateModel.h"

typedef NS_ENUM(NSInteger, TranslateTestType){
    SingleEnToCH,//英->汉
    SingleCHToEn,//汉->英
};

@interface JJTranslateView : UIView

@property (nonatomic, strong) JJTranslateModel *translateModel;

+(instancetype)translateViewWithSingleTranslateModel:(JJTranslateModel *)model;

@property (nonatomic, strong) UITextField *textfield;


@end
