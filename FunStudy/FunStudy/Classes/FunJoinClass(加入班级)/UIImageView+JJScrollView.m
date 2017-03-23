//
//  UIImageView+JJScrollView.m
//  FunStudy
//
//  Created by 唐天成 on 2016/12/28.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "UIImageView+JJScrollView.h"

//这个方法是为了让scrollView的滚动条一直存在



@implementation UIImageView (JJScrollView)

- (void)setAlpha:(CGFloat)alpha
{
    DebugLog(@"%ld",self.superview.tag);
    
    if (self.superview.tag == noDisableVerticalScrollTag) {
        if (alpha == 0 && self.autoresizingMask == UIViewAutoresizingFlexibleLeftMargin) {
            if (self.frame.size.width < 10 && self.frame.size.height > self.frame.size.width) {
                UIScrollView *sc = (UIScrollView*)self.superview;
                if (sc.frame.size.height < sc.contentSize.height) {
                    return;
                }
            }
        }
    }
    
    if (self.superview.tag == noDisableHorizontalScrollTag) {
        if (alpha == 0 && self.autoresizingMask == UIViewAutoresizingFlexibleTopMargin) {
            if (self.frame.size.height < 10 && self.frame.size.height < self.frame.size.width) {
                UIScrollView *sc = (UIScrollView*)self.superview;
                if (sc.frame.size.width < sc.contentSize.width) {
                    return;
                }
            }  
        }  
    }  
    
    [super setAlpha:alpha];  
}  

@end
