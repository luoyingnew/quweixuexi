//
//  JJSignUpPasswortViewController.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/9.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBaseViewController.h"

@interface JJSignUpPasswortViewController : JJBaseViewController
//头部名称
@property (nonatomic, copy) NSString *name;
//电话
@property (nonatomic, copy) NSString *mobile;
//验证码
@property (nonatomic,copy) NSString *v_code;
@end
