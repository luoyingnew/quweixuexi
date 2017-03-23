//
//  UILabel+JJInitChaneg.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/25.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "UILabel+JJInitChaneg.h"
#import <objc/runtime.h>

@implementation UILabel (JJInitChaneg)

// 加载这个分类的时候调用
+(void)load{
    // 交换方法实现,方法都是定义在类里面
    // class_getMethodImplementation:获取方法实现
    // class_getInstanceMethod:获取对象
    // class_getClassMethod:获取类方法
    // IMP:方法实现
    
    // imageNamed
    // Class:获取哪个类方法
    // SEL:获取方法编号,根据SEL就能去对应的类找方法
    //    Method imageNameMethod = class_getClassMethod([Person class], @selector(eat));
    //
    //    // xmg_imageNamed
    //    Method xmg_imageNamedMethod = class_getClassMethod([Person class], @selector(TTC_eat));
    
    Method oldNameMethod = class_getInstanceMethod([UILabel class], @selector(initWithFrame:));
    Method jj_newNamedMethod = class_getInstanceMethod([UILabel class], @selector(JJinitWithFrame:));
    // 交换方法实现
    method_exchangeImplementations(oldNameMethod, jj_newNamedMethod);
}
-(UILabel *)JJinitWithFrame:(CGRect)frame{
    UILabel *label = [self JJinitWithFrame:frame];
//    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.font =[UIFont boldSystemFontOfSize:label.font.pointSize * KWIDTH_IPHONE6_SCALE];
    return label;
}
@end
