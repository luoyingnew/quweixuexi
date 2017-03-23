//
//  JJListenTestView.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/21.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJListenTestModel.h"

typedef void(^ListenBtnClickBlock)(id);

@interface JJListenTestView : UIView

@property (nonatomic, copy) ListenBtnClickBlock block;

+(instancetype)listenTestViewWithListenTestModel:(JJListenTestModel *)model listenBtnClickblock:(ListenBtnClickBlock)block;

@end
