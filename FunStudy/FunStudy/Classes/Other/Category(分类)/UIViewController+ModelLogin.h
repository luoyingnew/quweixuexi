//
//  UIViewController+ModelLogin.h
//  XiaoHaiTun
//
//  Created by 唐天成 on 16/9/27.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ModelLogin)
- (void)modelToLoginVC ;

//该控制器是否是push出来的(YES:push   NO  present)
- (BOOL)isPushWayAppear;
@end
