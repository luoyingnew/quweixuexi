//
//  UIScrollView+JJTouch.m
//  FunStudy
//
//  Created by 唐天成 on 2016/12/28.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "UIScrollView+JJTouch.h"

#define scrollViewClickTag 1861140

//写这个方法主要是因为在cell上面有scrollView的时候,点击cell不会触发didSelected方法
@implementation UIScrollView (JJTouch)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
//    if(self.tag == scrollViewClickTag) {
//        UIView *v= self.superview;
//        [v touchesBegan:touches withEvent:event];
//    } else {
        [super touchesBegan:touches withEvent:event];
//    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event

{
//    if(self.tag == scrollViewClickTag) {
//        UIView * v = self.superview;
//        
//        [v touchesEnded:touches withEvent:event];
//    } else {
        [super touchesEnded:touches withEvent:event];
//    }
    
    
}
@end
