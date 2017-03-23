//
//  JJLoginBtn.h
//  FunStudy
//
//  Created by 唐天成 on 2016/11/8.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJLoginBtn : UIView

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UILabel *numberLabel;

+ (instancetype)loginBtnWithFrame:(CGRect)frame btnName:(NSString *)btnName numberString:(NSString *)numberString target:(id)target action:(SEL)action  ;

@end
