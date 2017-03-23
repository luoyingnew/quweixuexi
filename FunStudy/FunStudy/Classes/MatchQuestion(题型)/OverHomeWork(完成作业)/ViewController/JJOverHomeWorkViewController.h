//
//  JJOverHomeWorkViewController.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/23.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBaseViewController.h"
#import "XZShare.h"
#import <ShareSDKUI/ShareSDKUI.h>

typedef void(^OverHomeworkBlock) (void);

@interface JJOverHomeWorkViewController : JJBaseViewController

@property (nonatomic, strong) NSString *homework_id;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, copy) OverHomeworkBlock overHomeworkBlock;

//是否是自学
@property (nonatomic, assign) BOOL isSelfStudy;


@end
