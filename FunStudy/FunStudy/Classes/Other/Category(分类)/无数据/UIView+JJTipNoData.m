//
//  UIView+JJTipNoData.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/15.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "UIView+JJTipNoData.h"
#import "JJTipNotData.h"

@interface UIView (JJTipNoData)

@property (nonatomic, strong) JJTipNotData *noDateView;


@end

@implementation UIView (JJTipNoData)

- (JJTipNotData *)noDateView {
    UIView *existingView = [self viewWithTag:80001];
    if(existingView) {
        if(![existingView isKindOfClass:[JJTipNotData class]]) {
            DebugLog(@"Unexpected view of class %@ found with badge tag.", existingView);
            return nil;
        } else {
            return (JJTipNotData *)existingView;
        }
    }
    JJTipNotData *_noNetWorkVIew = [JJTipNotData tipTryOnceView];
    _noNetWorkVIew.tag = 80001;
    DebugLog(@"%@",NSStringFromCGRect(self.bounds));
    _noNetWorkVIew.frame =CGRectMake(0, 0, self.width, self.height);// self.bounds;
    return _noNetWorkVIew;
}

- (void)showNoDateWithTitle:(NSString *)title
{
    self.noDateView.hidden = NO;
    [self addSubview:self.noDateView];
    self.noDateView.tipLabel.text = title;
}
- (void)hideNoDate
{
    self.noDateView.hidden = YES;
    //    if([self isKindOfClass:[UITableView class]] &&
    //       !self.userInteractionEnabled) {
    //        self.userInteractionEnabled = YES;
    //    }
}

@end
