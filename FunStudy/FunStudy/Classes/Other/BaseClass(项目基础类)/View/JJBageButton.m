//
//  JJBageButton.m
//  FunStudy
//
//  Created by 唐天成 on 2016/11/12.
//  Copyright © 2016年 唐天成. All rights reserved.
//

#import "JJBageButton.h"

@implementation JJBageButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        //        self.size = self.currentBackgroundImage.size;
    }
    return self;
}

- (void)setBadgeValue:(NSString *)badgeValue
{
    if (badgeValue.intValue) {
        // 有未读消息
        self.hidden = NO;
        
        NSString *value = nil;
        if (badgeValue.intValue > 99) {
            
            value = @"99+";
        }else
        {
            value = badgeValue;
        }
        [self setTitle:value forState:UIControlStateNormal];
        
    }else
    {
        self.hidden = YES;
    }
}


@end
