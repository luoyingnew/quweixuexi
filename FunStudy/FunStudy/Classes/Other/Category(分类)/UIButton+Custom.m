//
//  UIButton+Custom.m
//  HiFun
//
//  Created by hao on 16/8/18.
//  Copyright © 2016年 attackt. All rights reserved.
//

#import "UIButton+Custom.h"
#import <objc/runtime.h>

@implementation UIButton (Custom)
- (void)verticalCenterImageAndTitle:(float)space {
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGFloat totalHeight = (imageSize.height + titleSize.height + space);
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height),0.0);
    NSLog(@"%@  %@   %@",NSStringFromCGRect(self.frame),NSStringFromUIEdgeInsets(UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width)),NSStringFromUIEdgeInsets(UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height),0.0)));
}

- (void)verticalCenterImageAndTitle {
    const int DEFAULT_SPACING = 6.0f;
    [self verticalCenterImageAndTitle:DEFAULT_SPACING];
}

- (void)horizontalCenterImageAndTitle:(float)space {
//    CGSize imageSize = self.imageView.frame.size;
//    CGSize titleSize = self.titleLabel.frame.size;
//    CGFloat totalWidth = (imageSize.width + titleSize.width + space);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, space / 2.0);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, space / 2.0, 0, 0);
}

- (void)horizontalCenterTitleAndImage:(float)space {
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGFloat totalWidth = (imageSize.width + titleSize.width + space);
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, titleSize.width + space/2, 0.0, - (titleSize.width + space/2));
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - (imageSize.width + space/2),0.0,imageSize.width + space/2);

}

@end

/*=====================================================*/

@implementation UIButton (Enlarge)

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

- (void) setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left {
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect) enlargedRect {
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge) {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    } else {
        return self.bounds;
    }
}

- (UIView*) hitTest:(CGPoint) point withEvent:(UIEvent*) event {
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}

@end
