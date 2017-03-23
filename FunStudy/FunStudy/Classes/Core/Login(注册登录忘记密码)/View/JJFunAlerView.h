//
//  JJFunAlerView.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/14.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CertainBlock)(void);

@interface JJFunAlerView : UIView
+ (void)showFunAlertViewWithTitle:(NSString *)title CenterBlock:(CertainBlock)block;
@end
