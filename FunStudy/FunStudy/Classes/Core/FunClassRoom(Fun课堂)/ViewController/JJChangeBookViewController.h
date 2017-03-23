//
//  JJChangeBookViewController.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBaseViewController.h"
@class JJBookModel;
typedef void(^SelectedBookBlock)(JJBookModel *);

@interface JJChangeBookViewController : JJBaseViewController

@property (nonatomic, copy) SelectedBookBlock block;

//是否是自学中心跳转的
@property(nonatomic,assign)BOOL isSelfStudy;

@end
