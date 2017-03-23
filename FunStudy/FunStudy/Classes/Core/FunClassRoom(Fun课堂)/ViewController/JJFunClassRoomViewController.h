//
//  JJFunClassRoomViewController.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/13.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBaseViewController.h"
#import "JJBookModel.h"

@interface JJFunClassRoomViewController : JJBaseViewController

@property (nonatomic, strong) JJBookModel *currentBookModel;
//是否是自学中心跳转的
@property(nonatomic,assign)BOOL isSelfStudy;

////titleName
//@property (nonatomic, strong) NSString *navigationTitleName;


@end
